import { NextRequest, NextResponse } from "next/server";
import { runSparqlSelect } from "@/lib/stardog";
import { adminLimiter, getClientId, rateLimitResponse } from "@/lib/rate-limit";

export async function GET(request: NextRequest) {
  const clientId = getClientId(request);
  const limit = adminLimiter(clientId);
  if (!limit.success) return rateLimitResponse(limit.reset);

  try {
    const [tripleCount, entityCount, sourceCount, relCount] = await Promise.all([
      runSparqlSelect<{ count: string }>("SELECT (COUNT(*) AS ?count) WHERE { ?s ?p ?o }"),
      runSparqlSelect<{ count: string }>(
        `SELECT (COUNT(DISTINCT ?e) AS ?count) WHERE {
          ?e <http://www.w3.org/2004/02/skos/core#prefLabel> ?name .
        }`,
      ),
      runSparqlSelect<{ count: string }>(
        `SELECT (COUNT(DISTINCT ?s) AS ?count) WHERE {
          ?s a <https://daf-metadata.mil/ontology/Source> .
        }`,
      ),
      runSparqlSelect<{ count: string }>(
        `SELECT (COUNT(*) AS ?count) WHERE {
          ?from ?rel ?to .
          FILTER(STRSTARTS(STR(?rel), "https://daf-metadata.mil/ontology/rel/"))
        }`,
      ),
    ]);

    return NextResponse.json({
      connected: true,
      triples: parseInt(tripleCount[0]?.count || "0"),
      entities: parseInt(entityCount[0]?.count || "0"),
      sources: parseInt(sourceCount[0]?.count || "0"),
      relationships: parseInt(relCount[0]?.count || "0"),
    });
  } catch (error) {
    console.error("Stardog status error:", error);
    return NextResponse.json({
      connected: false,
      error: "Failed to connect to Stardog",
      triples: 0,
      entities: 0,
      sources: 0,
      relationships: 0,
    });
  }
}
