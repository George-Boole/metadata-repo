/**
 * Backfill the Neo4j knowledge graph from existing Supabase sources.
 *
 * For each active source, fetches its chunks, runs LLM-based entity/relationship
 * extraction via Gemini Flash, and writes the results to Neo4j.
 *
 * Usage:
 *   npx tsx scripts/backfill-graph.ts
 *
 * Requires .env.local with Supabase, Neo4j, and Google AI credentials.
 */

import { config } from "dotenv";
config({ path: ".env.local" });

import { getSupabaseServer } from "../src/lib/supabase";
import { extractEntitiesAndRelationships } from "../src/lib/ingest/graph-extract";
import { writeToGraph } from "../src/lib/ingest/graph-write";
import { runCypher } from "../src/lib/neo4j";

async function backfillGraph() {
  const supabase = getSupabaseServer();

  // Get all active sources
  const { data: sources, error } = await supabase
    .from("sources")
    .select("id, url, title")
    .eq("status", "active")
    .order("title");

  if (error || !sources) {
    console.error("Failed to fetch sources:", error);
    process.exit(1);
  }

  console.log(`Found ${sources.length} sources to process`);

  for (let i = 0; i < sources.length; i++) {
    const source = sources[i];

    // Check if source already has graph data
    try {
      const existing = await runCypher<{ count: number }>(
        `MATCH (s:Source {url: $url})-[:MENTIONS]->() RETURN count(*) as count`,
        { url: source.url },
      );
      if (existing.length > 0 && existing[0].count > 0) {
        console.log(`[${i + 1}/${sources.length}] ${source.title} — already has graph data, skipping`);
        continue;
      }
    } catch {
      // Neo4j query failed, try processing anyway
    }

    // Fetch chunks for this source
    const { data: chunks } = await supabase
      .from("chunks")
      .select("content")
      .eq("source_id", source.id)
      .order("metadata->index")
      .limit(20);

    if (!chunks || chunks.length === 0) {
      console.log(`[${i + 1}/${sources.length}] ${source.title} — no chunks, skipping`);
      continue;
    }

    try {
      const extraction = await extractEntitiesAndRelationships(
        chunks.map((c) => c.content),
        source.title,
      );

      const result = await writeToGraph(source.id, source.url, extraction);
      console.log(
        `[${i + 1}/${sources.length}] ${source.title} — ${result.entities} entities, ${result.relationships} relationships`,
      );
    } catch (e) {
      console.error(`[${i + 1}/${sources.length}] ${source.title} — ERROR:`, e);
    }

    // Rate limit: 1 per second to avoid hitting Gemini quotas
    await new Promise((resolve) => setTimeout(resolve, 1000));
  }

  console.log("Backfill complete!");
  process.exit(0);
}

backfillGraph();
