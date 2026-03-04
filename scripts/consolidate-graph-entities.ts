/**
 * Consolidate fragmented entities in Neo4j.
 *
 * Problems addressed:
 * 1. Entity fragmentation: IC-EDH has 15+ variants (IC-EDH, IC-EDH.XML, Enterprise Data Header, etc.)
 * 2. Junk entities: file names (*.xsd, *.sch), XSD types, boilerplate sidebar links
 * 3. Relationship noise: boilerplate content created low-value relationships
 *
 * Strategy:
 * - Phase 1: Delete junk entities matching file/type patterns
 * - Phase 2: Merge fragmented entities into canonical names
 * - Phase 3: Report final stats
 *
 * Usage:
 *   npx tsx scripts/consolidate-graph-entities.ts [--dry-run]
 */

import { config } from "dotenv";
config({ path: ".env.local" });

import { runCypher } from "../src/lib/neo4j";

const DRY_RUN = process.argv.includes("--dry-run");

/** Patterns matching junk entities that should be deleted */
const JUNK_PATTERNS = [
  // File names (with extensions)
  /\.(xsd|sch|xml|json|pdf|zip|csv|txt|wsdl|xsl|xslt)($|\s)/i,
  // XSD type/element names
  /^(xs:|xsd:|ism:|edh:|ntk:|arh:|ism_|ISM_|NTK_|EDH_)/,
  // Controlled vocabulary enumeration file names (without extension)
  /^CVEnum/,
  // Schematron rule IDs
  /^[A-Z]+_ID_\d+/,
  // AddBackNamespaces XSLT helpers
  /^AddBackNamespaces/,
  // Version patterns as standalone entities
  /^v\d+(\.\d+)*$/i,
  /^\d+\.\d+(\.\d+)*$/,
  // Namespace URIs
  /^(urn:|http:|https:)/i,
  // File path references
  /^\.\/|^\.\.\//,
  // Very short meaningless names (1-2 chars)
  /^.{1,2}$/,
  // Generic terms that shouldn't be entities
  /^(Metadata|Schema|XML|JSON|PDF|Document|Specification|Standard|Rule|Type|Element|Attribute|Namespace|Pattern|Assertion|Test)$/i,
  // Schematron/XSLT infrastructure references
  /^(Schematron|XSLT|XPath)\s/i,
  // Individual elements referenced as entities (parenthesized)
  /\(.*Element\)$/,
  // XSL file references
  /\.xsl$/i,
];

/** Canonical name mappings: canonical → patterns to merge */
const CANONICAL_MAPPINGS: Record<string, RegExp[]> = {
  "IC-ISM": [
    /^IC-ISM$/i,
    /IC-ISM/i,
    /Information Security Marking/i,
    /^ISM$/i,
    /ISM Metadata/i,
    /CAPCO/i,
  ],
  "IC-EDH": [
    /^IC-EDH$/i,
    /IC-EDH/i,
    /Enterprise Data Header/i,
    /^EDH$/i,
  ],
  "IC-TDF": [
    /^IC-TDF$/i,
    /IC-TDF/i,
    /Trusted Data Format/i,
    /^TDF$/i,
  ],
  "DDMS": [
    /^DDMS$/i,
    /DoD Discovery Metadata/i,
    /Discovery Metadata Specification/i,
  ],
  "GENC": [
    /^GENC$/i,
    /Geopolitical Entities.*Names.*Codes/i,
  ],
  "IC-ID": [
    /^IC-ID$/i,
    /IC-ID/i,
    /Intelligence Community Identifier/i,
  ],
  "NIEM": [
    /^NIEM$/i,
    /National Information Exchange Model/i,
  ],
  "Dublin Core": [
    /^Dublin Core$/i,
    /^DCMI$/i,
    /Dublin Core Metadata/i,
  ],
  "DCAT": [
    /^DCAT$/i,
    /Data Catalog Vocabulary/i,
  ],
  "IC-NTK": [
    /^IC-NTK$/i,
    /IC-NTK/i,
    /Need To Know/i,
    /^NTK$/i,
  ],
  "IC-ARH": [
    /^IC-ARH$/i,
    /IC-ARH/i,
    /Access Rights Header/i,
    /^ARH$/i,
  ],
};

async function deleteJunkEntities() {
  console.log("\n=== Phase 1: Delete junk entities ===\n");

  // Get all entities
  const entities = await runCypher<{ name: string; type: string; relCount: number }>(
    `MATCH (e:Entity)
     OPTIONAL MATCH (e)-[r]-()
     RETURN e.name AS name, e.type AS type, count(r) AS relCount
     ORDER BY e.name`,
  );

  console.log(`Total entities: ${entities.length}`);

  let deleted = 0;
  for (const entity of entities) {
    const isJunk = JUNK_PATTERNS.some((p) => p.test(entity.name));
    if (!isJunk) continue;

    if (DRY_RUN) {
      console.log(`  [DRY-RUN] Would delete: "${entity.name}" (${entity.relCount} rels)`);
    } else {
      await runCypher(
        `MATCH (e:Entity {name: $name}) DETACH DELETE e`,
        { name: entity.name },
      );
      console.log(`  Deleted: "${entity.name}" (${entity.relCount} rels)`);
    }
    deleted++;
  }

  console.log(`\nPhase 1 complete: ${deleted} junk entities ${DRY_RUN ? "would be " : ""}deleted`);
}

async function mergeFragmentedEntities() {
  console.log("\n=== Phase 2: Merge fragmented entities ===\n");

  for (const [canonical, patterns] of Object.entries(CANONICAL_MAPPINGS)) {
    // Find all entities matching any of the patterns
    const allEntities = await runCypher<{
      name: string;
      type: string;
      aliases: string[];
    }>(
      `MATCH (e:Entity) RETURN e.name AS name, e.type AS type, COALESCE(e.aliases, []) AS aliases`,
    );

    const matches = allEntities.filter((e) =>
      e.name !== canonical && patterns.some((p) => p.test(e.name)),
    );

    if (matches.length === 0) {
      console.log(`${canonical}: no duplicates found`);
      continue;
    }

    const duplicateNames = matches.map((m) => m.name);
    console.log(`${canonical}: merging ${matches.length} duplicates: ${duplicateNames.join(", ")}`);

    if (DRY_RUN) {
      console.log(`  [DRY-RUN] Would merge into ${canonical}`);
      continue;
    }

    // Collect all aliases from duplicates
    const allAliases = new Set<string>();
    for (const m of matches) {
      allAliases.add(m.name);
      for (const a of m.aliases) allAliases.add(a);
    }
    // Also get canonical's existing aliases
    const canonicalEntity = allEntities.find((e) => e.name === canonical);
    if (canonicalEntity) {
      for (const a of canonicalEntity.aliases) allAliases.add(a);
    }
    allAliases.delete(canonical); // Don't include canonical name in aliases

    // Ensure canonical entity exists
    await runCypher(
      `MERGE (e:Entity {name: $name})
       SET e.type = "Standard", e.aliases = $aliases, e.updated_at = datetime()`,
      { name: canonical, aliases: [...allAliases] },
    );

    // For each duplicate: move RELATES_TO and MENTIONS edges, then delete
    for (const dup of duplicateNames) {
      // Move outgoing RELATES_TO from dup to canonical
      await runCypher(
        `MATCH (dup:Entity {name: $dupName})-[r:RELATES_TO]->(target:Entity)
         WHERE target.name <> $canonical
         WITH dup, r, target
         MERGE (c:Entity {name: $canonical})
         MERGE (c)-[r2:RELATES_TO {rel_type: r.rel_type}]->(target)
         ON CREATE SET r2.evidence = r.evidence, r2.source_url = r.source_url, r2.updated_at = datetime()
         DELETE r`,
        { dupName: dup, canonical },
      );

      // Move incoming RELATES_TO to dup → canonical
      await runCypher(
        `MATCH (source:Entity)-[r:RELATES_TO]->(dup:Entity {name: $dupName})
         WHERE source.name <> $canonical
         WITH source, r, dup
         MERGE (c:Entity {name: $canonical})
         MERGE (source)-[r2:RELATES_TO {rel_type: r.rel_type}]->(c)
         ON CREATE SET r2.evidence = r.evidence, r2.source_url = r.source_url, r2.updated_at = datetime()
         DELETE r`,
        { dupName: dup, canonical },
      );

      // Move MENTIONS from Source → dup to Source → canonical
      await runCypher(
        `MATCH (s:Source)-[m:MENTIONS]->(dup:Entity {name: $dupName})
         WITH s, m, dup
         MERGE (c:Entity {name: $canonical})
         MERGE (s)-[:MENTIONS]->(c)
         DELETE m`,
        { dupName: dup, canonical },
      );

      // Delete the duplicate entity
      await runCypher(
        `MATCH (e:Entity {name: $name}) DETACH DELETE e`,
        { name: dup },
      );
    }

    console.log(`  Merged ${matches.length} → ${canonical} (${allAliases.size} aliases)`);
  }
}

async function deleteLowValueEntities() {
  console.log("\n=== Phase 2b: Delete low-value entities ===\n");

  // Delete entities that have no relationships and aren't mentioned by any source
  const orphans = await runCypher<{ name: string }>(
    `MATCH (e:Entity)
     WHERE NOT (e)-[:RELATES_TO]-()
       AND NOT ()-[:MENTIONS]->(e)
     RETURN e.name AS name`,
  );

  if (orphans.length > 0) {
    if (DRY_RUN) {
      console.log(`  [DRY-RUN] Would delete ${orphans.length} orphan entities`);
      for (const o of orphans.slice(0, 10)) {
        console.log(`    "${o.name}"`);
      }
      if (orphans.length > 10) console.log(`    ... and ${orphans.length - 10} more`);
    } else {
      await runCypher(
        `MATCH (e:Entity)
         WHERE NOT (e)-[:RELATES_TO]-()
           AND NOT ()-[:MENTIONS]->(e)
         DETACH DELETE e`,
      );
      console.log(`  Deleted ${orphans.length} orphan entities`);
    }
  }

  // Delete self-referential relationships
  const selfRels = await runCypher<{ count: number }>(
    `MATCH (e:Entity)-[r:RELATES_TO]->(e) RETURN count(r) AS count`,
  );
  if (selfRels[0]?.count > 0) {
    if (DRY_RUN) {
      console.log(`  [DRY-RUN] Would delete ${selfRels[0].count} self-referential relationships`);
    } else {
      await runCypher(`MATCH (e:Entity)-[r:RELATES_TO]->(e) DELETE r`);
      console.log(`  Deleted ${selfRels[0].count} self-referential relationships`);
    }
  }
}

async function reportStats() {
  console.log("\n=== Final Stats ===\n");

  const stats = await runCypher<{
    entities: number;
    sources: number;
    mentions: number;
    relatesTo: number;
  }>(
    `MATCH (e:Entity) WITH count(e) AS entities
     MATCH (s:Source) WITH entities, count(s) AS sources
     OPTIONAL MATCH ()-[m:MENTIONS]->() WITH entities, sources, count(m) AS mentions
     OPTIONAL MATCH ()-[r:RELATES_TO]->() WITH entities, sources, mentions, count(r) AS relatesTo
     RETURN entities, sources, mentions, relatesTo`,
  );

  if (stats.length > 0) {
    const s = stats[0];
    console.log(`  Entities:     ${s.entities}`);
    console.log(`  Sources:      ${s.sources}`);
    console.log(`  MENTIONS:     ${s.mentions}`);
    console.log(`  RELATES_TO:   ${s.relatesTo}`);
  }

  // Top entities by relationship count
  const top = await runCypher<{ name: string; type: string; rels: number }>(
    `MATCH (e:Entity)-[r:RELATES_TO]-()
     RETURN e.name AS name, e.type AS type, count(r) AS rels
     ORDER BY rels DESC
     LIMIT 20`,
  );

  console.log("\n  Top entities by relationship count:");
  for (const t of top) {
    console.log(`    ${t.rels}\t${t.name} (${t.type})`);
  }
}

async function main() {
  console.log(DRY_RUN ? "=== DRY RUN MODE ===" : "=== CONSOLIDATING GRAPH ENTITIES ===");

  await deleteJunkEntities();
  await mergeFragmentedEntities();
  await deleteLowValueEntities();
  await reportStats();

  console.log("\nDone!");
  process.exit(0);
}

main();
