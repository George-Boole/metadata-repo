/**
 * Backfill user_activity_log from existing conversations and chat_messages.
 * Run once: npx tsx scripts/backfill-activity.ts
 */
import { config } from "dotenv";
config({ path: ".env.local" });
import { createClient } from "@supabase/supabase-js";

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
);

async function main() {
  console.log("Backfilling activity log from existing data...\n");

  // 1. Backfill chat activity from conversations
  const { data: conversations, error: convErr } = await supabase
    .from("conversations")
    .select("id, user_id, created_at, title");

  if (convErr) {
    console.error("Failed to fetch conversations:", convErr.message);
    return;
  }

  console.log(`Found ${conversations?.length ?? 0} conversations`);

  // Get chat message counts per conversation
  const { data: messages, error: msgErr } = await supabase
    .from("chat_messages")
    .select("conversation_id, role, created_at")
    .eq("role", "user")
    .order("created_at", { ascending: true });

  if (msgErr) {
    console.error("Failed to fetch messages:", msgErr.message);
    return;
  }

  console.log(`Found ${messages?.length ?? 0} user messages`);

  // Insert chat events for each user message
  const chatEvents = (messages || []).map((msg) => {
    const conv = conversations?.find((c) => c.id === msg.conversation_id);
    return {
      username: conv?.user_id || "unknown",
      action: "chat",
      path: "/api/chat",
      metadata: { conversation_id: msg.conversation_id, backfilled: true },
      created_at: msg.created_at,
    };
  });

  if (chatEvents.length > 0) {
    const { error: insertErr } = await supabase
      .from("user_activity_log")
      .insert(chatEvents);

    if (insertErr) {
      console.error("Failed to insert chat events:", insertErr.message);
    } else {
      console.log(`Inserted ${chatEvents.length} chat events`);
    }
  }

  // 2. Backfill source ingestion events from sources table
  const { data: sources, error: srcErr } = await supabase
    .from("sources")
    .select("id, title, url, source_type, created_at")
    .order("created_at", { ascending: true });

  if (srcErr) {
    console.error("Failed to fetch sources:", srcErr.message);
    return;
  }

  console.log(`Found ${sources?.length ?? 0} sources`);

  const ingestEvents = (sources || []).map((src) => ({
    username: "admin",
    action: src.source_type === "upload" ? "ingest_upload" : "ingest_url",
    path: src.source_type === "upload" ? "/api/ingest/upload" : "/api/ingest",
    metadata: {
      source_id: src.id,
      title: src.title,
      url: src.url,
      backfilled: true,
    },
    created_at: src.created_at,
  }));

  if (ingestEvents.length > 0) {
    // Insert in batches of 100
    for (let i = 0; i < ingestEvents.length; i += 100) {
      const batch = ingestEvents.slice(i, i + 100);
      const { error: insertErr } = await supabase
        .from("user_activity_log")
        .insert(batch);

      if (insertErr) {
        console.error(`Failed to insert ingest batch ${i}:`, insertErr.message);
      } else {
        console.log(`Inserted ingest events batch: ${i + 1}-${i + batch.length}`);
      }
    }
  }

  // 3. Summary
  const { count } = await supabase
    .from("user_activity_log")
    .select("*", { count: "exact", head: true });

  console.log(`\nBackfill complete. Total activity events: ${count}`);
}

main().catch(console.error);
