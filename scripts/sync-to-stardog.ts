/**
 * Bulk sync Neo4j knowledge graph data to Stardog.
 *
 * Reads all Entity, Source, RELATES_TO, and MENTIONS data from Neo4j,
 * converts to RDF triples, and batch-inserts into Stardog.
 *
 * Usage:
 *   npx tsx scripts/sync-to-stardog.ts
 *
 * Requires .env.local with Neo4j and Stardog credentials.
 */

import { config } from "dotenv";
config({ path: ".env.local" });

import { runCypher } from "../src/lib/neo4j";
import { runSparqlUpdate, runSparqlSelect } from "../src/lib/stardog";

const DAF = "https://daf-metadata.mil/ontology/";

function escapeSparql(s: string): string {
  return s.replace(/\\/g, "\\\\").replace(/"/g, '\\"').replace(/\n/g, "\\n").replace(/\r/g, "");
}

function toSlug(name: string): string {
  return encodeURIComponent(name.replace(/\s+/g, "_"));
}

async function syncToStardog() {
  console.log("=== Syncing Neo4j → Stardog ===\n");

  // Check Stardog connection
  try {
    const result = await runSparqlSelect("SELECT (COUNT(*) AS ?count) WHERE { ?s ?p ?o }");
    const existing = result[0]?.count || "0";
    console.log(`Stardog currently has ${existing} triples\n`);
  } catch (e) {
    console.error("Failed to connect to Stardog:", e);
    process.exit(1);
  }

  // 1. Fetch all sources from Neo4j
  console.log("Fetching sources from Neo4j...");
  const sources = await runCypher<{
    url: string;
    title: string;
    tier: string;
    sourceType: string;
    chunkCount: number;
  }>(
    `MATCH (s:Source)
     RETURN s.url AS url, s.title AS title, s.tier AS tier,
            s.source_type AS sourceType, s.chunk_count AS chunkCount`,
  );
  console.log(`  Found ${sources.length} sources`);

  // 2. Fetch all entities
  console.log("Fetching entities from Neo4j...");
  const entities = await runCypher<{
    name: string;
    type: string;
    aliases: string[];
  }>(
    `MATCH (e:Entity)
     RETURN e.name AS name, e.type AS type, e.aliases AS aliases`,
  );
  console.log(`  Found ${entities.length} entities`);

  // 3. Fetch all RELATES_TO relationships
  console.log("Fetching relationships from Neo4j...");
  const relationships = await runCypher<{
    fromName: string;
    relType: string;
    toName: string;
    evidence: string | null;
    sourceUrl: string | null;
  }>(
    `MATCH (a:Entity)-[r:RELATES_TO]->(b:Entity)
     RETURN a.name AS fromName, r.rel_type AS relType, b.name AS toName,
            r.evidence AS evidence, r.source_url AS sourceUrl`,
  );
  console.log(`  Found ${relationships.length} RELATES_TO relationships`);

  // 4. Fetch all MENTIONS relationships
  console.log("Fetching MENTIONS from Neo4j...");
  const mentions = await runCypher<{
    sourceUrl: string;
    entityName: string;
  }>(
    `MATCH (s:Source)-[:MENTIONS]->(e:Entity)
     RETURN s.url AS sourceUrl, e.name AS entityName`,
  );
  console.log(`  Found ${mentions.length} MENTIONS relationships\n`);

  // Build all triples
  console.log("Building RDF triples...");
  const triples: string[] = [];

  // Source triples
  for (const s of sources) {
    const iri = `<${DAF}source/${toSlug(s.url)}>`;
    triples.push(`${iri} a <${DAF}Source> .`);
    triples.push(`${iri} <${DAF}url> "${escapeSparql(s.url)}" .`);
    if (s.title) triples.push(`${iri} <${DAF}title> "${escapeSparql(s.title)}" .`);
    if (s.tier) triples.push(`${iri} <${DAF}tier> "${escapeSparql(s.tier)}" .`);
    if (s.sourceType) triples.push(`${iri} <${DAF}sourceType> "${escapeSparql(s.sourceType)}" .`);
    if (s.chunkCount) triples.push(`${iri} <${DAF}chunkCount> "${s.chunkCount}"^^<http://www.w3.org/2001/XMLSchema#integer> .`);
  }

  // Entity triples
  for (const e of entities) {
    const iri = `<${DAF}entity/${toSlug(e.name)}>`;
    triples.push(`${iri} a <${DAF}${e.type || "Entity"}> .`);
    triples.push(`${iri} <http://www.w3.org/2004/02/skos/core#prefLabel> "${escapeSparql(e.name)}" .`);
    if (e.aliases) {
      for (const alias of e.aliases) {
        triples.push(`${iri} <http://www.w3.org/2004/02/skos/core#altLabel> "${escapeSparql(alias)}" .`);
      }
    }
  }

  // RELATES_TO triples
  for (const r of relationships) {
    const fromIri = `<${DAF}entity/${toSlug(r.fromName)}>`;
    const toIri = `<${DAF}entity/${toSlug(r.toName)}>`;
    triples.push(`${fromIri} <${DAF}rel/${r.relType}> ${toIri} .`);
  }

  // MENTIONS triples
  for (const m of mentions) {
    const sourceIri = `<${DAF}source/${toSlug(m.sourceUrl)}>`;
    const entityIri = `<${DAF}entity/${toSlug(m.entityName)}>`;
    triples.push(`${sourceIri} <http://purl.org/dc/terms/references> ${entityIri} .`);
  }

  console.log(`  Total triples: ${triples.length}\n`);

  // Insert in batches
  const BATCH_SIZE = 500;
  let inserted = 0;
  for (let i = 0; i < triples.length; i += BATCH_SIZE) {
    const batch = triples.slice(i, i + BATCH_SIZE);
    const sparql = `INSERT DATA { ${batch.join("\n")} }`;
    await runSparqlUpdate(sparql);
    inserted += batch.length;
    console.log(`  Inserted ${inserted}/${triples.length} triples (${Math.round(inserted / triples.length * 100)}%)`);
  }

  // Verify
  const finalCount = await runSparqlSelect("SELECT (COUNT(*) AS ?count) WHERE { ?s ?p ?o }");
  console.log(`\nDone! Stardog now has ${finalCount[0]?.count || "unknown"} triples.`);
}

syncToStardog().catch((e) => {
  console.error("Sync failed:", e);
  process.exit(1);
});
