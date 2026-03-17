import { runSparqlSelect } from "../stardog";
import { extractQueryEntities } from "./graph-search";
import type { GraphContext } from "./graph-search";

const DAF = "https://daf-metadata.mil/ontology/";

/** Max relationships to return (keeps prompt manageable) */
const MAX_RELATIONSHIPS = 30;

/**
 * SPARQL-based graph search against Stardog.
 * Mirrors graphSearch() in graph-search.ts but uses SPARQL instead of Cypher.
 */
export async function stardogGraphSearch(query: string): Promise<GraphContext> {
  const regexEntities = extractQueryEntities(query);

  // Extract search terms from the query
  const queryTerms = query
    .replace(/[^a-zA-Z0-9\s-]/g, " ")
    .trim()
    .split(/\s+/)
    .filter((w) => w.length >= 3);

  if (regexEntities.length === 0 && queryTerms.length === 0) {
    return { entities: [], relationships: [], connectedSourceUrls: [] };
  }

  try {
    // Find entities matching the query terms via prefLabel or altLabel
    const searchTerms = [...new Set([...regexEntities, ...queryTerms])];
    const filterClauses = searchTerms
      .map((t) => `CONTAINS(LCASE(?label), LCASE("${t.replace(/"/g, '\\"')}"))`)
      .join(" || ");

    const entityResults = await runSparqlSelect<{ name: string; type: string }>(
      `SELECT DISTINCT ?name ?type WHERE {
        ?entity a ?typeIri .
        FILTER(STRSTARTS(STR(?typeIri), "${DAF}"))
        BIND(REPLACE(STR(?typeIri), "${DAF}", "") AS ?type)
        { ?entity <http://www.w3.org/2004/02/skos/core#prefLabel> ?label }
        UNION
        { ?entity <http://www.w3.org/2004/02/skos/core#altLabel> ?label }
        FILTER(${filterClauses})
        ?entity <http://www.w3.org/2004/02/skos/core#prefLabel> ?name .
      } LIMIT 15`,
    );

    const matchedNames = entityResults.map((e) => e.name);

    if (matchedNames.length === 0) {
      return { entities: regexEntities, relationships: [], connectedSourceUrls: [] };
    }

    // 1-hop traversal: find relationships involving matched entities
    const nameFilter = matchedNames
      .map((n) => `"${n.replace(/"/g, '\\"')}"`)
      .join(", ");

    const relResults = await runSparqlSelect<{
      fromName: string;
      relType: string;
      toName: string;
    }>(
      `SELECT DISTINCT ?fromName ?relType ?toName WHERE {
        ?from <http://www.w3.org/2004/02/skos/core#prefLabel> ?fromName .
        ?from ?relIri ?to .
        FILTER(STRSTARTS(STR(?relIri), "${DAF}rel/"))
        BIND(REPLACE(STR(?relIri), "${DAF}rel/", "") AS ?relType)
        ?to <http://www.w3.org/2004/02/skos/core#prefLabel> ?toName .
        FILTER(?fromName IN (${nameFilter}) || ?toName IN (${nameFilter}))
      } LIMIT 100`,
    );

    // Get source URLs connected to matched entities
    const sourceResults = await runSparqlSelect<{ url: string }>(
      `SELECT DISTINCT ?url WHERE {
        ?source <http://purl.org/dc/terms/references> ?entity .
        ?entity <http://www.w3.org/2004/02/skos/core#prefLabel> ?name .
        FILTER(?name IN (${nameFilter}))
        ?source <${DAF}url> ?url .
      } LIMIT 20`,
    );

    const relationships = relResults.map((r) => ({
      from: r.fromName,
      relType: r.relType,
      to: r.toName,
    }));

    // Deduplicate
    const seen = new Set<string>();
    const uniqueRels = relationships.filter((r) => {
      const key = `${r.from}-${r.relType}-${r.to}`;
      const reverseKey = `${r.to}-${r.relType}-${r.from}`;
      if (seen.has(key) || seen.has(reverseKey)) return false;
      seen.add(key);
      return true;
    });

    return {
      entities: matchedNames,
      relationships: uniqueRels.slice(0, MAX_RELATIONSHIPS),
      connectedSourceUrls: sourceResults.map((s) => s.url),
    };
  } catch (e) {
    console.warn("Stardog graph search failed (non-fatal):", e);
    return { entities: regexEntities, relationships: [], connectedSourceUrls: [] };
  }
}
