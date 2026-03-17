import { NextResponse } from "next/server";
import { runCypher } from "@/lib/neo4j";
import { getSupabaseServer } from "@/lib/supabase";

export async function GET() {
  try {
    // Fetch entities with their mentioning source URLs
    const entities = await runCypher<{ name: string; type: string; sourceUrl: string | null }>(
      `MATCH (e:Entity)
       OPTIONAL MATCH (s:Source)-[:MENTIONS]->(e)
       RETURN e.name AS name, e.type AS type, s.url AS sourceUrl
       LIMIT 400`,
    );

    const relationships = await runCypher<{
      fromName: string;
      relType: string;
      toName: string;
    }>(
      `MATCH (a:Entity)-[r:RELATES_TO]->(b:Entity)
       RETURN a.name AS fromName, r.rel_type AS relType, b.name AS toName
       LIMIT 500`,
    );

    // Build node map with source URLs
    const nodeTypeMap = new Map<string, string>();
    const nodeSourceUrls = new Map<string, Set<string>>();

    for (const e of entities) {
      nodeTypeMap.set(e.name, e.type);
      if (e.sourceUrl) {
        if (!nodeSourceUrls.has(e.name)) nodeSourceUrls.set(e.name, new Set());
        nodeSourceUrls.get(e.name)!.add(e.sourceUrl);
      }
    }
    for (const r of relationships) {
      if (!nodeTypeMap.has(r.fromName)) nodeTypeMap.set(r.fromName, "Entity");
      if (!nodeTypeMap.has(r.toName)) nodeTypeMap.set(r.toName, "Entity");
    }

    // Batch-resolve source URLs to Supabase IDs
    const allUrls = new Set<string>();
    for (const urls of nodeSourceUrls.values()) {
      for (const u of urls) allUrls.add(u);
    }

    const urlToId = new Map<string, string>();
    if (allUrls.size > 0) {
      try {
        const supabase = getSupabaseServer();
        const { data } = await supabase
          .from("sources")
          .select("id, url")
          .in("url", Array.from(allUrls).slice(0, 200));
        if (data) {
          for (const row of data) urlToId.set(row.url, row.id);
        }
      } catch {
        // Non-fatal — nodes just won't be clickable
      }
    }

    const nodes = Array.from(nodeTypeMap.entries()).map(([name, type]) => {
      const sourceUrls = nodeSourceUrls.get(name);
      const sourceIds = sourceUrls
        ? Array.from(sourceUrls).map((u) => urlToId.get(u)).filter(Boolean)
        : [];
      return {
        id: name,
        type,
        sourceIds: sourceIds.length > 0 ? sourceIds : undefined,
      };
    });

    const links = relationships.map((r) => ({
      source: r.fromName,
      target: r.toName,
      type: r.relType,
    }));

    return NextResponse.json({ nodes, links });
  } catch (error) {
    console.error("Neo4j graph data error:", error);
    return NextResponse.json({ error: "Failed to load graph data" }, { status: 500 });
  }
}
