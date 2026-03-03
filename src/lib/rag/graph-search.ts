import { runCypher } from "../neo4j";

/** Known standard name patterns for entity extraction from queries */
const STANDARD_PATTERNS = [
  /\bDoDI\s*\d{4}\.\d{2}\b/gi,
  /\bIC-[A-Z]{2,5}\b/gi,
  /\bNIEM\b/gi,
  /\bDDMS\b/gi,
  /\bDCAT\b/gi,
  /\bDublin\s*Core\b/gi,
  /\bISO\s*\d{4,5}(?:-\d+)?\b/gi,
  /\bOWL\s*2?\b/gi,
  /\bSKOS\b/gi,
  /\bGENC\b/gi,
  /\bDCAMPS-?C?\b/gi,
  /\bPurview\b/gi,
  /\bVaronis\b/gi,
  /\bCollibra\b/gi,
  /\bTitus\b/gi,
  /\bBoldon\s*James\b/gi,
  /\bOPSWAT\b/gi,
  /\bFortra\b/gi,
  /\bW3C\b/gi,
  /\bODNI\b/gi,
];

/** Extract entity names from a user query using regex patterns */
export function extractQueryEntities(query: string): string[] {
  const found: string[] = [];
  for (const pattern of STANDARD_PATTERNS) {
    const matches = query.match(pattern);
    if (matches) {
      for (const m of matches) {
        const normalized = m.trim();
        if (!found.some((f) => f.toLowerCase() === normalized.toLowerCase())) {
          found.push(normalized);
        }
      }
    }
  }
  return found;
}

export interface GraphContext {
  entities: string[];
  relationships: Array<{
    from: string;
    relType: string;
    to: string;
    evidence?: string;
  }>;
  connectedSourceUrls: string[];
}

/** Perform a 2-hop graph traversal from matched entities */
export async function graphSearch(query: string): Promise<GraphContext> {
  const entities = extractQueryEntities(query);

  if (entities.length === 0) {
    return { entities: [], relationships: [], connectedSourceUrls: [] };
  }

  try {
    // Find entities by name or alias match
    const entityResults = await runCypher<{
      name: string;
      type: string;
    }>(
      `UNWIND $names AS queryName
       MATCH (e:Entity)
       WHERE e.name =~ ('(?i).*' + queryName + '.*')
          OR ANY(a IN e.aliases WHERE a =~ ('(?i).*' + queryName + '.*'))
       RETURN DISTINCT e.name AS name, e.type AS type
       LIMIT 20`,
      { names: entities },
    );

    if (entityResults.length === 0) {
      return { entities, relationships: [], connectedSourceUrls: [] };
    }

    const matchedNames = entityResults.map((e) => e.name);

    // 2-hop traversal from matched entities
    const relResults = await runCypher<{
      fromName: string;
      relType: string;
      toName: string;
      evidence: string | null;
    }>(
      `UNWIND $names AS entityName
       MATCH (e:Entity {name: entityName})-[r:RELATES_TO]-(related:Entity)
       RETURN e.name AS fromName, r.rel_type AS relType, related.name AS toName, r.evidence AS evidence
       UNION
       UNWIND $names AS entityName
       MATCH (e:Entity {name: entityName})-[r:RELATES_TO]-(hop1:Entity)-[r2:RELATES_TO]-(hop2:Entity)
       WHERE hop2.name <> e.name
       RETURN hop1.name AS fromName, r2.rel_type AS relType, hop2.name AS toName, r2.evidence AS evidence
       LIMIT 30`,
      { names: matchedNames },
    );

    // Get source URLs connected to matched entities
    const sourceResults = await runCypher<{ url: string }>(
      `UNWIND $names AS entityName
       MATCH (e:Entity {name: entityName})<-[:MENTIONS]-(s:Source)
       RETURN DISTINCT s.url AS url
       LIMIT 20`,
      { names: matchedNames },
    );

    const relationships = relResults.map((r) => ({
      from: r.fromName,
      relType: r.relType,
      to: r.toName,
      evidence: r.evidence || undefined,
    }));

    // Deduplicate relationships
    const seen = new Set<string>();
    const uniqueRels = relationships.filter((r) => {
      const key = `${r.from}-${r.relType}-${r.to}`;
      if (seen.has(key)) return false;
      seen.add(key);
      return true;
    });

    return {
      entities: matchedNames,
      relationships: uniqueRels,
      connectedSourceUrls: sourceResults.map((s) => s.url),
    };
  } catch (e) {
    console.warn("Graph search failed (non-fatal):", e);
    return { entities, relationships: [], connectedSourceUrls: [] };
  }
}
