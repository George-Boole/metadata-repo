import { NextRequest, NextResponse } from "next/server";
import { getSupabaseServer } from "@/lib/supabase";
import { chatLimiter, getClientId, rateLimitResponse } from "@/lib/rate-limit";

/** DELETE /api/conversations/[id] — delete a conversation */
export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const clientId = getClientId(request);
  const limit = chatLimiter(clientId);
  if (!limit.success) return rateLimitResponse(limit.reset);

  const { id } = await params;
  const supabase = getSupabaseServer();

  // CASCADE will delete messages too
  const { error } = await supabase.from("conversations").delete().eq("id", id);

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ success: true });
}

/** PATCH /api/conversations/[id] — update conversation title */
export async function PATCH(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const clientId = getClientId(request);
  const limit = chatLimiter(clientId);
  if (!limit.success) return rateLimitResponse(limit.reset);

  const { id } = await params;
  const body = await request.json();
  const { title } = body;

  if (!title) {
    return NextResponse.json({ error: "Title required" }, { status: 400 });
  }

  const supabase = getSupabaseServer();
  const { error } = await supabase
    .from("conversations")
    .update({ title })
    .eq("id", id);

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ success: true });
}
