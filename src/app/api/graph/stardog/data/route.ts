import { NextResponse } from "next/server";
import { isStardogConfigured, runSparqlSelect } from "@/lib/stardog";

const DAF = "https://daf-metadata.mil/ontology/";

export async function GET() {
  try {
    if (!isStardogConfigured()) {
      return NextResponse.json({ error: "Stardog not configured" }, { status: 503 });
    }

    const entities = await runSparqlSelect<{ name: string; type: string }>(
      `SELECT ?name ?type WHERE {
        ?entity a ?typeIri .
        FILTER(STRSTARTS(STR(?typeIri), "${DAF}"))
        FILTER(?typeIri != <${DAF}Source>)
        BIND(REPLACE(STR(?typeIri), "${DAF}", "") AS ?type)
        ?entity <http://www.w3.org/2004/02/skos/core#prefLabel> ?name .
      } LIMIT 200`,
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
    console.error("Stardog graph data error:", error);
    return NextResponse.json({ error: "Failed to load graph data" }, { status: 500 });
  }
}
