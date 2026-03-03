import { config } from "dotenv";
config({ path: ".env.local" });
import { createClient } from "@supabase/supabase-js";

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL as string,
  process.env.SUPABASE_SERVICE_ROLE_KEY as string,
);

async function main() {
  const { data } = await supabase
    .from("sources")
    .select("id, title, url, chunk_count")
    .eq("tier", "2a")
    .order("title");

  for (const s of data || []) {
    console.log(`${s.chunk_count}\t${s.title}`);
    console.log(`  ${s.url}`);
  }
  console.log(`\nTotal: ${data?.length} tier 2a sources`);
}
main();
