import { NextRequest, NextResponse } from "next/server";
import { getSupabaseServer } from "@/lib/supabase";
import { adminLimiter, getClientId, rateLimitResponse } from "@/lib/rate-limit";

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const clientId = getClientId(request);
  const limit = adminLimiter(clientId);
  if (!limit.success) return rateLimitResponse(limit.reset);

  const { id } = await params;
  const supabase = getSupabaseServer();

  // Delete chunks first (FK constraint)
  await supabase.from("chunks").delete().eq("source_id", id);

  // Delete source
  const { error } = await supabase.from("sources").delete().eq("id", id);

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ success: true });
}
