import { NextResponse } from "next/server";
import { getSupabaseServer } from "@/lib/supabase";

/**
 * POST /api/setup/chat-tables — auto-create conversations + chat_messages tables.
 *
 * Uses a workaround since Supabase JS client doesn't support raw DDL:
 * tries to query each table, and if missing, creates them via the
 * Supabase Management API or instructs the user.
 */
export async function POST() {
  const supabase = getSupabaseServer();

  // Check if tables already exist
  const { error: convErr } = await supabase
    .from("conversations")
    .select("id")
    .limit(1);

  const { error: msgErr } = await supabase
    .from("chat_messages")
    .select("id")
    .limit(1);

  if (!convErr && !msgErr) {
    return NextResponse.json({
      success: true,
      message: "Chat tables already exist",
    });
  }

  // Tables don't exist — try creating via Supabase SQL API
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL || "";
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY || "";

  const sql = `
    CREATE TABLE IF NOT EXISTS conversations (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      user_id TEXT NOT NULL,
      title TEXT,
      created_at TIMESTAMPTZ DEFAULT NOW(),
      updated_at TIMESTAMPTZ DEFAULT NOW()
    );
    CREATE TABLE IF NOT EXISTS chat_messages (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
      role TEXT NOT NULL CHECK (role IN ('user', 'assistant')),
      content TEXT NOT NULL,
      created_at TIMESTAMPTZ DEFAULT NOW()
    );
    CREATE INDEX IF NOT EXISTS idx_conversations_user
      ON conversations(user_id, updated_at DESC);
    CREATE INDEX IF NOT EXISTS idx_messages_conversation
      ON chat_messages(conversation_id, created_at ASC);
  `;

  // Try the Supabase SQL endpoint (available on newer Supabase versions)
  const endpoints = [
    `${url}/pg/query`,
    `${url}/rest/v1/rpc/exec_sql`,
  ];

  for (const endpoint of endpoints) {
    try {
      const res = await fetch(endpoint, {
        method: "POST",
        headers: {
          apikey: key,
          Authorization: `Bearer ${key}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(
          endpoint.includes("rpc")
            ? { sql }
            : { query: sql }
        ),
      });

      if (res.ok) {
        return NextResponse.json({
          success: true,
          message: "Chat tables created successfully",
        });
      }
    } catch {
      // Try next endpoint
    }
  }

  // If none of the programmatic approaches work, return instructions
  const projectRef = url
    .replace("https://", "")
    .replace(".supabase.co", "");

  return NextResponse.json(
    {
      success: false,
      message: "Could not auto-create tables. Please run the SQL manually.",
      instructions: [
        `1. Open: https://supabase.com/dashboard/project/${projectRef}/sql/new`,
        "2. Paste the contents of scripts/create-chat-tables.sql",
        "3. Click Run",
      ],
      sql: sql.trim(),
    },
    { status: 422 }
  );
}
