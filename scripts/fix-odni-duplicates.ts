/**
 * Fix broken ODNI source URLs and merge duplicate entries.
 * Old entries (from Session 12a) have broken URLs with extra path segments.
 * New entries (from Session 12b) have correct canonical URLs.
 */
import { config } from "dotenv";
config({ path: ".env.local" });
import { createClient } from "@supabase/supabase-js";

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL as string,
  process.env.SUPABASE_SERVICE_ROLE_KEY as string,
);

async function mergeAndDelete(
  keepId: string,
  deleteId: string,
  label: string,
  newUrl?: string,
) {
  // Move chunks from deleteId to keepId
  const { count: moved } = await supabase
    .from("chunks")
    .update({ source_id: keepId })
    .eq("source_id", deleteId)
    .select("id");
  console.log(`  Moved ${moved} chunks from delete→keep`);

  // Update chunk_count on keep entry
  const { count: total } = await supabase
    .from("chunks")
    .select("id", { count: "exact", head: true })
    .eq("source_id", keepId);

  const updateData: Record<string, unknown> = { chunk_count: total };
  if (newUrl) updateData.url = newUrl;

  await supabase.from("sources").update(updateData).eq("id", keepId);
  console.log(`  Updated ${label} chunk_count to ${total}${newUrl ? ", fixed URL" : ""}`);

  // Delete old source
  await supabase.from("sources").delete().eq("id", deleteId);
  console.log(`  Deleted duplicate entry`);
}

async function main() {
  // 1. IC-EDH: old entry (broken URL, 114 ZIP chunks) → merge into new entry (correct URL, 31 chunks)
  console.log("--- IC-EDH: merge old (ZIP content) into new (correct URL) ---");
  await mergeAndDelete(
    "572b9d15-1c4c-470e-97c1-fe96b16ff968", // keep: correct URL, 31 chunks
    "993c5a34-8173-427b-9008-b93318011da2", // delete: broken URL, 114 ZIP chunks
    "IC-EDH",
  );

  // 2. IC-ISM: merge small correct-URL entry into main entry, fix URL
  // Main: e1192832 (2522 chunks, broken URL)
  // Small: c8a9fac9 "ODNI: Information Security Marking Metadata" (31 chunks, correct URL)
  console.log("\n--- IC-ISM: merge small entry into main, fix URL ---");
  await mergeAndDelete(
    "e1192832-4916-4096-a5c6-23cef781861c", // keep: main entry, 2522 chunks
    "c8a9fac9-df95-4730-9cc6-45aa6b9653a9", // delete: "ODNI: ISM Metadata", 31 chunks
    "IC-ISM",
    "https://www.dni.gov/index.php/who-we-are/organizations/ic-cio/ic-technical-specifications/information-security-marking-metadata",
  );

  // 3. Delete stale IC-ISM duplicate (1 chunk, broken URL)
  console.log("\n--- IC-ISM stale: delete 1-chunk duplicate ---");
  const staleIsm = "f685bf0d-af60-4f9d-8ada-b207f3fa4bf0";
  await supabase.from("chunks").delete().eq("source_id", staleIsm);
  await supabase.from("sources").delete().eq("id", staleIsm);
  console.log("  Deleted stale IC-ISM entry");

  // 4. DDMS: delete old entry (1 chunk, broken URL), keep "ODNI: DoD Discovery Metadata" (30 chunks)
  console.log("\n--- DDMS: delete old entry ---");
  const oldDdms = "a770ff67-26b8-4b72-b232-6310d051b104";
  await supabase.from("chunks").delete().eq("source_id", oldDdms);
  await supabase.from("sources").delete().eq("id", oldDdms);
  console.log("  Deleted old DDMS entry");

  // Verify
  console.log("\n--- Verification ---");
  const { data: verify } = await supabase
    .from("sources")
    .select("title, url, chunk_count")
    .or(
      "title.ilike.%IC-EDH%,title.ilike.%IC-ISM%,title.ilike.%DDMS%,title.ilike.%Enterprise Data Header%,title.ilike.%Discovery Metadata%,title.ilike.%Information Security Marking%",
    );
  for (const s of verify || []) {
    console.log(`  ${s.chunk_count}\t${s.title}`);
    console.log(`    ${s.url}`);
  }

  const { count: sourceCount } = await supabase
    .from("sources")
    .select("id");
  console.log(`\nTotal sources: ${sourceCount}`);
  console.log("Done!");
  process.exit(0);
}

main();
