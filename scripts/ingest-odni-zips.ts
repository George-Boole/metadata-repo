import "dotenv/config";
import { getSupabaseServer } from "../src/lib/supabase";
import { ingestZipContents } from "../src/lib/ingest/pipeline";

interface OdniSpec {
  title: string;
  zipUrl: string;
  priority: number;
}

// Priority-ordered ODNI specs
const ODNI_SPECS: OdniSpec[] = [
  {
    title: "IC-ISM",
    zipUrl: "https://www.dni.gov/files/ICEA/documents/IC-ISM_Standalone.zip",
    priority: 1,
  },
  {
    title: "IC-EDH",
    zipUrl: "https://www.dni.gov/files/ICEA/documents/IC-EDH_Standalone.zip",
    priority: 2,
  },
  {
    title: "DDMS",
    zipUrl: "https://www.dni.gov/files/ICEA/documents/DDMS_Standalone.zip",
    priority: 3,
  },
  {
    title: "IC-TDF",
    zipUrl: "https://www.dni.gov/files/ICEA/documents/IC-TDF_Standalone.zip",
    priority: 4,
  },
  {
    title: "GENC",
    zipUrl: "https://www.dni.gov/files/ICEA/documents/GENC_Standalone.zip",
    priority: 5,
  },
  {
    title: "IC-ID",
    zipUrl: "https://www.dni.gov/files/ICEA/documents/IC-ID_Standalone.zip",
    priority: 6,
  },
];

async function ingestOdniZips() {
  const supabase = getSupabaseServer();

  // Sort by priority
  const sorted = [...ODNI_SPECS].sort((a, b) => a.priority - b.priority);

  for (const spec of sorted) {
    console.log(`\n--- Processing ${spec.title} (priority ${spec.priority}) ---`);

    // Find existing source by title match
    const { data: sources } = await supabase
      .from("sources")
      .select("id, url, title, chunk_count")
      .ilike("title", `%${spec.title}%`)
      .eq("status", "active")
      .limit(1);

    if (!sources || sources.length === 0) {
      console.log(`  No existing source found for "${spec.title}", skipping`);
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
      console.error(`  ERROR processing ${spec.title}:`, e);
    }

    // Rate limit between specs
    await new Promise((resolve) => setTimeout(resolve, 2000));
  }

  console.log("\nODNI zip ingestion complete!");
  process.exit(0);
}

ingestOdniZips();
