import { config } from "dotenv";
config({ path: ".env.local" });
import { createClient } from "@supabase/supabase-js";

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!,
);

async function fixTiers() {
  // Check current state
  const { data: all } = await supabase.from("sources").select("id, tier");
  const counts: Record<string, number> = {};
  for (const r of all ?? []) {
    counts[r.tier ?? "null"] = (counts[r.tier ?? "null"] || 0) + 1;
  }
  console.log("Before fix:", counts);

  // Fix uppercase tier values
  const fixes: [string, string][] = [
    ["2A", "2a"],
    ["2B", "2b"],
    ["Tier1", "1"],
    ["Tier2A", "2a"],
    ["Tier2B", "2b"],
    ["Tier3", "3"],
  ];

  for (const [from, to] of fixes) {
    const { data: updated, error } = await supabase
      .from("sources")
      .update({ tier: to })
      .eq("tier", from)
      .select("id");

    if (error) {
      console.error(`Error fixing ${from} → ${to}:`, error.message);
      continue;
    }
    if (updated && updated.length > 0) {
      console.log(`  Fixed ${updated.length} rows: ${from} → ${to}`);
    }
  }

  // Final state
  const { data: final } = await supabase.from("sources").select("id, tier");
  const finalCounts: Record<string, number> = {};
  for (const r of final ?? []) {
    finalCounts[r.tier ?? "null"] = (finalCounts[r.tier ?? "null"] || 0) + 1;
  }
  console.log("After fix:", finalCounts);
}

fixTiers().catch(console.error);
