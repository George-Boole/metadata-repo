import { runCypher } from "../neo4j";
import type { ExtractionResult } from "./graph-extract";

export async function writeToGraph(
  sourceId: string,
  sourceUrl: string,
  extraction: ExtractionResult,
): Promise<{ entities: number; relationships: number }> {
  let entityCount = 0;
  let relCount = 0;

  // Create/merge entities
  for (const entity of extraction.entities) {
    await runCypher(
      `MERGE (e:Entity {name: $name})
       SET e.type = $type, e.aliases = $aliases, e.updated_at = datetime()
       WITH e
       MATCH (s:Source {url: $sourceUrl})
       MERGE (s)-[:MENTIONS]->(e)`,
      {
        name: entity.name,
        type: entity.type,
        aliases: entity.aliases,
        sourceUrl,
      },
    );
    entityCount++;
  }

  // Create/merge relationships
  // Uses RELATES_TO with a rel_type property since Neo4j AuraDB Free lacks APOC
  for (const rel of extraction.relationships) {
    await runCypher(
      `MATCH (a:Entity {name: $from}), (b:Entity {name: $to})
       MERGE (a)-[r:RELATES_TO {rel_type: $relType}]->(b)
       SET r.evidence = $evidence, r.source_url = $sourceUrl, r.updated_at = datetime()`,
      {
        from: rel.from,
        to: rel.to,
        relType: rel.type,
        evidence: rel.evidence,
        sourceUrl,
      },
    );
    relCount++;
  }

  return { entities: entityCount, relationships: relCount };
}
