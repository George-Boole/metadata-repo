import { NextResponse } from "next/server";
import { runCypher } from "@/lib/neo4j";

export async function GET() {
  try {
    const entities = await runCypher<{ name: string; type: string }>(
      `MATCH (e:Entity)
       RETURN e.name AS name, e.type AS type
       LIMIT 200`,
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

    const nodeSet = new Set<string>();
    const nodeTypeMap = new Map<string, string>();

    for (const e of entities) {
      nodeSet.add(e.name);
      nodeTypeMap.set(e.name, e.type);
    }
    for (const r of relationships) {
      nodeSet.add(r.fromName);
      nodeSet.add(r.toName);
    }

    const nodes = Array.from(nodeSet).map((name) => ({
      id: name,
      type: nodeTypeMap.get(name) || "Entity",
    }));

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
