/**
 * Bulk ingestion script for Tier 3 tools and ontology sources.
 *
 * Usage:
 *   npx tsx scripts/ingest-tools-ontologies.ts
 *
 * Requires the app's environment variables (.env.local) to be available.
 * Uses the ingest pipeline directly (not the HTTP API) to avoid needing
 * the dev server running.
 */

import { config } from "dotenv";
config({ path: ".env.local" });
import { ingestUrl } from "../src/lib/ingest/pipeline";

interface IngestJob {
  url: string;
  title: string;
  tier: string;
  sourceType: string;
}

const JOBS: IngestJob[] = [
  // ── Tier 3: Tagging & Labeling Tools ──────────────────────
  {
    url: "https://mundosystems.com",
    title: "DCAMPS-C (Mundo Systems)",
    tier: "3",
    sourceType: "tool",
  },
  {
    url: "https://learn.microsoft.com/en-us/purview/information-protection",
    title: "Microsoft Purview Information Protection",
    tier: "3",
    sourceType: "tool",
  },
  {
    url: "https://www.varonis.com/products/data-classification-engine",
    title: "Varonis Data Classification Engine",
    tier: "3",
    sourceType: "tool",
  },
  {
    url: "https://www.collibra.com/us/en/platform/data-classification",
    title: "Collibra Data Classification",
    tier: "3",
    sourceType: "tool",
  },
  {
    url: "https://www.fortra.com/products/data-classification",
    title: "Fortra Data Classification (Titus)",
    tier: "3",
    sourceType: "tool",
  },
  {
    url: "https://www.opswat.com/products/data-classification",
    title: "OPSWAT Data Classification (Boldon James)",
    tier: "3",
    sourceType: "tool",
  },

  // ── Ontologies ────────────────────────────────────────────
  {
    url: "https://www.w3.org/TR/owl2-overview/",
    title: "OWL 2 Web Ontology Language Overview",
    tier: "ontology",
    sourceType: "ontology",
  },
  {
    url: "https://lov.linkeddata.es/dataset/lov/",
    title: "Linked Open Vocabularies (LOV)",
    tier: "ontology",
    sourceType: "ontology",
  },
];

async function main() {
  console.log(`Starting bulk ingestion of ${JOBS.length} sources...\n`);

  let success = 0;
  let failed = 0;

  for (const job of JOBS) {
    console.log(`Ingesting: ${job.title}`);
    console.log(`  URL: ${job.url}`);
    console.log(`  Tier: ${job.tier}, Type: ${job.sourceType}`);

    try {
      const result = await ingestUrl({
        url: job.url,
        title: job.title,
        tier: job.tier,
        sourceType: job.sourceType,
      });

      if (result.status === "success") {
        console.log(`  OK — ${result.chunkCount} chunks\n`);
        success++;
      } else {
        console.log(`  FAILED — ${result.error}\n`);
        failed++;
      }
    } catch (err) {
      console.log(`  ERROR — ${err}\n`);
      failed++;
    }
  }

  console.log(`\nDone: ${success} succeeded, ${failed} failed out of ${JOBS.length} total.`);
  process.exit(failed > 0 ? 1 : 0);
}

main();
