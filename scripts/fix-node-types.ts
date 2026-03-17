/**
 * Fix misclassified entity types in Neo4j and Stardog.
 * Run with: npx tsx scripts/fix-node-types.ts
 */
import { config } from "dotenv";
config({ path: ".env.local" });

import { runCypher } from "../src/lib/neo4j";
import { isStardogConfigured, runSparqlUpdate } from "../src/lib/stardog";

const DAF = "https://daf-metadata.mil/ontology/";

// Rules: [pattern test, correct type]
const TYPE_RULES: [RegExp, string][] = [
  // DoD Instructions, Directives, Manuals
  [/^DoDI\s/i, "Guidance"],
  [/^DoDD\s/i, "Guidance"],
  [/^DoDM\s/i, "Guidance"],
  [/^DoD Instruction\s/i, "Guidance"],
  [/^DoD Directive\s/i, "Guidance"],
  [/^DoD Manual\s/i, "Guidance"],
  // Executive Orders
  [/^Executive Order\s/i, "Guidance"],
  // US Code titles
  [/^Title \d+.*United States Code/i, "Guidance"],
  [/^Title \d+.*U\.S\.C/i, "Guidance"],
  [/^Section \d+.*Title \d+/i, "Guidance"],
  [/Section 794d/i, "Guidance"],
  // Joint Publications
  [/^Joint Publication/i, "Guidance"],
  // NIST
  [/^NIST\s/i, "Standard"],
  // CNSSI
  [/^CNSSI/i, "Standard"],
  [/^CNSS\s/i, "Standard"],
  // OMB - these are guidance, not organizations
  [/^Office of Management and Budget/i, "Guidance"],
  [/^OMB\s/i, "Guidance"],
];

function getCorrectType(name: string): string | null {
  for (const [pattern, type] of TYPE_RULES) {
    if (pattern.test(name)) return type;
  }
  return null;
}

async function main() {
  console.log("Fetching all entities from Neo4j...");

  const entities = await runCypher<{ name: string; type: string }>(
    `MATCH (e:Entity) RETURN e.name AS name, e.type AS type`
  );

  console.log(`Found ${entities.length} entities`);

  const fixes: { name: string; oldType: string; newType: string }[] = [];

  for (const entity of entities) {
    const correctType = getCorrectType(entity.name);
    if (correctType && correctType !== entity.type) {
      fixes.push({ name: entity.name, oldType: entity.type, newType: correctType });
    }
  }

  console.log(`Found ${fixes.length} misclassified entities`);

  if (fixes.length === 0) {
    console.log("Nothing to fix!");
    return;
  }

  // Fix in Neo4j
  console.log("\n--- Fixing Neo4j ---");
  let neo4jFixed = 0;
  for (const fix of fixes) {
    try {
      await runCypher(
        `MATCH (e:Entity {name: $name}) SET e.type = $newType`,
        { name: fix.name, newType: fix.newType }
      );
      console.log(`  ${fix.oldType} -> ${fix.newType}: ${fix.name.slice(0, 60)}`);
      neo4jFixed++;
    } catch (err) {
      console.error(`  FAILED: ${fix.name}`, err);
    }
  }
  console.log(`Fixed ${neo4jFixed} entities in Neo4j`);

  // Fix in Stardog
  if (isStardogConfigured()) {
    console.log("\n--- Fixing Stardog ---");
    let stardogFixed = 0;
    for (const fix of fixes) {
      try {
        // Delete old type triple and insert new one
        const entityUri = `<${DAF}entity/${encodeURIComponent(fix.name)}>`;
        await runSparqlUpdate(`
          DELETE { ${entityUri} a <${DAF}${fix.oldType}> }
          INSERT { ${entityUri} a <${DAF}${fix.newType}> }
          WHERE { ${entityUri} a <${DAF}${fix.oldType}> }
        `);
        stardogFixed++;
      } catch (err) {
        // Some entities may not exist in Stardog with the same URI pattern
      }
    }
    console.log(`Fixed ${stardogFixed} entities in Stardog`);
  } else {
    console.log("\nStardog not configured, skipping");
  }

  console.log("\nDone!");
  process.exit(0);
}

main().catch((err) => {
  console.error("Fatal error:", err);
  process.exit(1);
});
