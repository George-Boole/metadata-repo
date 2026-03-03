import { config } from "dotenv";
config({ path: ".env.local" });
import { getSupabaseServer } from "../src/lib/supabase";
import { ingestZipContents } from "../src/lib/ingest/pipeline";

interface OdniSpec {
  label: string;
  titleSearch: string; // Supabase ILIKE pattern for finding the source
  zipUrl: string;
  priority: number;
}

// Priority-ordered ODNI specs — real download URLs from dni.gov
const ODNI_SPECS: OdniSpec[] = [
  {
    label: "IC-ISM",
    titleSearch: "IC-ISM%Information Security Marking",
    zipUrl: "https://www.dni.gov/files/documents/CIO/ICEA/Dec2022/ISM/ISM-Public-Standalone.zip",
    priority: 1,
  },
  {
    label: "IC-EDH",
    titleSearch: "IC-EDH%Enterprise Data Header",
    zipUrl: "https://www.dni.gov/files/documents/CIO/ICEA/Dec2022/IC-EDH/IC-EDH-Public-Standalone.zip",
    priority: 2,
  },
  {
    label: "IC-TDF",
    titleSearch: "%Trusted Data Format",
    zipUrl: "https://www.dni.gov/files/documents/CIO/ICEA/Dec2022/IC-TDF/IC-TDF-Public-Standalone.zip",
    priority: 3,
  },
  {
    label: "IC-GENC",
    titleSearch: "%Geopolitical Entities%",
    zipUrl: "https://www.dni.gov/files/documents/CIO/ICEA/Dec2022/IC-GENC/IC-GENC-Public-Standalone.zip",
    priority: 4,
  },
];

async function ingestOdniZips() {
  const supabase = getSupabaseServer();

  // Sort by priority
  const sorted = [...ODNI_SPECS].sort((a, b) => a.priority - b.priority);

  for (const spec of sorted) {
    console.log(`\n--- Processing ${spec.label} (priority ${spec.priority}) ---`);

    // Find existing source by title match
    const { data: sources } = await supabase
      .from("sources")
      .select("id, url, title, chunk_count")
      .ilike("title", spec.titleSearch)
      .eq("status", "active")
      .limit(1);

    if (!sources || sources.length === 0) {
      console.log(`  No existing source found for "${spec.label}" (search: ${spec.titleSearch}), skipping`);
      continue;
    }

    const source = sources[0];
    console.log(`  Found source: ${source.title} (${source.chunk_count} chunks)`);

    try {
      const result = await ingestZipContents(
        source.id,
        source.url,
        source.title,
        spec.zipUrl,
        "2a",
      );

      console.log(
        `  Done: ${result.filesProcessed} files processed, ${result.totalChunks} new chunks`,
      );
      console.log(
        `  ${source.title} went from ${source.chunk_count} to ${source.chunk_count + result.totalChunks} chunks`,
      );
    } catch (e) {
      console.error(`  ERROR processing ${spec.label}:`, e);
    }

    // Rate limit between specs
    await new Promise((resolve) => setTimeout(resolve, 2000));
  }

  console.log("\nODNI zip ingestion complete!");
  process.exit(0);
}

ingestOdniZips();
