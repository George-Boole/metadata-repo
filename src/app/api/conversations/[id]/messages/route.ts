import { NextRequest, NextResponse } from "next/server";
import { getSupabaseServer } from "@/lib/supabase";
import { chatLimiter, getClientId, rateLimitResponse } from "@/lib/rate-limit";

/** GET /api/conversations/[id]/messages — load messages for a conversation */
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const clientId = getClientId(request);
  const limit = chatLimiter(clientId);
  if (!limit.success) return rateLimitResponse(limit.reset);

  const { id } = await params;
  const supabase = getSupabaseServer();

  const { data, error } = await supabase
    .from("chat_messages")
    .select("id, role, content, created_at")
    .eq("conversation_id", id)
    .order("created_at", { ascending: true });

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ messages: data || [] });
}
