import { NextRequest, NextResponse } from "next/server";
import { getSupabaseServer } from "@/lib/supabase";
import { chatLimiter, getClientId, rateLimitResponse } from "@/lib/rate-limit";

/** GET /api/conversations — list conversations for current user */
export async function GET(request: NextRequest) {
  const clientId = getClientId(request);
  const limit = chatLimiter(clientId);
  if (!limit.success) return rateLimitResponse(limit.reset);

  const username = request.headers.get("x-user") || "admin";

  const supabase = getSupabaseServer();
  const { data, error } = await supabase
    .from("conversations")
    .select("id, title, updated_at")
    .eq("user_id", username)
    .order("updated_at", { ascending: false })
    .limit(50);

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ conversations: data || [] });
}

/** POST /api/conversations — create a new conversation */
export async function POST(request: NextRequest) {
  const clientId = getClientId(request);
  const limit = chatLimiter(clientId);
  if (!limit.success) return rateLimitResponse(limit.reset);

  const username = request.headers.get("x-user") || "admin";
  const body = await request.json().catch(() => ({}));
  const title = body.title || "New conversation";

  const supabase = getSupabaseServer();
  const { data, error } = await supabase
    .from("conversations")
    .insert({ user_id: username, title })
    .select("id, title, updated_at")
    .single();

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json(data);
}
