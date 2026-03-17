import { runSparqlUpdate } from "../stardog";
import type { ExtractionResult } from "./graph-extract";

const DAF = "https://daf-metadata.mil/ontology/";

/** Escape a string for use inside a SPARQL literal */
function escapeSparql(s: string): string {
  return s.replace(/\\/g, "\\\\").replace(/"/g, '\\"').replace(/\n/g, "\\n").replace(/\r/g, "");
}

/** Build a safe IRI-friendly slug from a name */
function toSlug(name: string): string {
  return encodeURIComponent(name.replace(/\s+/g, "_"));
}

/**
 * Write extraction results to Stardog as RDF triples.
 * Mirrors writeToGraph() in graph-write.ts but uses SPARQL INSERT DATA.
 */
export async function writeToStardog(
  sourceId: string,
  sourceUrl: string,
  extraction: ExtractionResult,
): Promise<{ entities: number; relationships: number }> {
  let entityCount = 0;
  let relCount = 0;

  // Build a single SPARQL INSERT DATA with all triples for efficiency
  const triples: string[] = [];

  // Source triple
  triples.push(`<${DAF}source/${toSlug(sourceId)}> a <${DAF}Source> .`);
  triples.push(`<${DAF}source/${toSlug(sourceId)}> <${DAF}url> "${escapeSparql(sourceUrl)}" .`);

  // Entities
  for (const entity of extraction.entities) {
    const entityIri = `<${DAF}entity/${toSlug(entity.name)}>`;
    triples.push(`${entityIri} a <${DAF}${entity.type}> .`);
    triples.push(`${entityIri} <http://www.w3.org/2004/02/skos/core#prefLabel> "${escapeSparql(entity.name)}" .`);

    for (const alias of entity.aliases) {
      triples.push(`${entityIri} <http://www.w3.org/2004/02/skos/core#altLabel> "${escapeSparql(alias)}" .`);
    }

    // MENTIONS link from source to entity
    triples.push(`<${DAF}source/${toSlug(sourceId)}> <http://purl.org/dc/terms/references> ${entityIri} .`);
    entityCount++;
  }

  // Relationships
  for (const rel of extraction.relationships) {
    const fromIri = `<${DAF}entity/${toSlug(rel.from)}>`;
    const toIri = `<${DAF}entity/${toSlug(rel.to)}>`;
    triples.push(`${fromIri} <${DAF}rel/${rel.type}> ${toIri} .`);

    if (rel.evidence) {
      // Store evidence as a reified statement using a blank node pattern
      const evidenceSlug = toSlug(`${rel.from}_${rel.type}_${rel.to}`);
      triples.push(`<${DAF}evidence/${evidenceSlug}> <${DAF}evidence> "${escapeSparql(rel.evidence)}" .`);
      triples.push(`<${DAF}evidence/${evidenceSlug}> <${DAF}sourceUrl> "${escapeSparql(sourceUrl)}" .`);
    }
    relCount++;
  }

  if (triples.length > 0) {
    // Batch in groups to avoid overly large queries
    const BATCH_SIZE = 200;
    for (let i = 0; i < triples.length; i += BATCH_SIZE) {
      const batch = triples.slice(i, i + BATCH_SIZE);
      const sparql = `INSERT DATA { ${batch.join("\n")} }`;
      await runSparqlUpdate(sparql);
    }
  }

  return { entities: entityCount, relationships: relCount };
}

/**
 * Write a source node to Stardog (step 8b in pipeline — mirrors Neo4j Source MERGE).
 */
export async function writeStardogSourceNode(
  url: string,
  title: string,
  tier: string,
  sourceType: string,
  chunkCount: number,
): Promise<void> {
  const sourceIri = `<${DAF}source/${toSlug(url)}>`;
  const triples = [
    `${sourceIri} a <${DAF}Source> .`,
    `${sourceIri} <${DAF}url> "${escapeSparql(url)}" .`,
    `${sourceIri} <${DAF}title> "${escapeSparql(title)}" .`,
    `${sourceIri} <${DAF}tier> "${escapeSparql(tier)}" .`,
    `${sourceIri} <${DAF}sourceType> "${escapeSparql(sourceType)}" .`,
    `${sourceIri} <${DAF}chunkCount> "${chunkCount}"^^<http://www.w3.org/2001/XMLSchema#integer> .`,
  ];

  await runSparqlUpdate(`INSERT DATA { ${triples.join("\n")} }`);
}
