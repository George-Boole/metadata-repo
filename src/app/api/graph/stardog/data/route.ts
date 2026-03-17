import { NextResponse } from "next/server";
import { isStardogConfigured, runSparqlSelect } from "@/lib/stardog";
import { getSupabaseServer } from "@/lib/supabase";

const DAF = "https://daf-metadata.mil/ontology/";

export async function GET() {
  try {
    if (!isStardogConfigured()) {
      return NextResponse.json({ error: "Stardog not configured" }, { status: 503 });
    }

    // Fetch entities with their mentioning source URLs
    const entities = await runSparqlSelect<{ name: string; type: string; sourceUrl?: string }>(
      `SELECT ?name ?type ?sourceUrl WHERE {
        ?entity a ?typeIri .
        FILTER(STRSTARTS(STR(?typeIri), "${DAF}"))
        FILTER(?typeIri != <${DAF}Source>)
        BIND(REPLACE(STR(?typeIri), "${DAF}", "") AS ?type)
        ?entity <http://www.w3.org/2004/02/skos/core#prefLabel> ?name .
        OPTIONAL {
          ?source <http://purl.org/dc/terms/references> ?entity .
          ?source <${DAF}url> ?sourceUrl .
        }
      } LIMIT 400`,
    );

    const relationships = await runSparqlSelect<{
      fromName: string;
      relType: string;
      toName: string;
    }>(
      `SELECT ?fromName ?relType ?toName WHERE {
        ?from ?relIri ?to .
        FILTER(STRSTARTS(STR(?relIri), "${DAF}rel/"))
        BIND(REPLACE(STR(?relIri), "${DAF}rel/", "") AS ?relType)
        ?from <http://www.w3.org/2004/02/skos/core#prefLabel> ?fromName .
        ?to <http://www.w3.org/2004/02/skos/core#prefLabel> ?toName .
      } LIMIT 500`,
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
        // Non-fatal
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
    console.error("Stardog graph data error:", error);
    return NextResponse.json({ error: "Failed to load graph data" }, { status: 500 });
  }
}
