import { NextRequest, NextResponse } from "next/server";
import { getSupabaseServer } from "@/lib/supabase";
import { hashPassword } from "@/lib/auth";
import { adminLimiter, getClientId, rateLimitResponse } from "@/lib/rate-limit";
import { logActivity, getUserFromRequest } from "@/lib/activity-log";

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const clientId = getClientId(request);
  const limit = adminLimiter(clientId);
  if (!limit.success) return rateLimitResponse(limit.reset);

  const { id } = await params;
  const supabase = getSupabaseServer();

  const { error } = await supabase.from("users").delete().eq("id", id);

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  const actor = getUserFromRequest(request);
  logActivity(actor, "admin_delete_user", `/api/admin/users/${id}`, { deleted_user_id: id });

  return NextResponse.json({ success: true });
}

export async function PATCH(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const clientId = getClientId(request);
  const limit = adminLimiter(clientId);
  if (!limit.success) return rateLimitResponse(limit.reset);

  const { id } = await params;
  const body = await request.json();
  const { display_name, role, password } = body as {
    display_name?: string;
    role?: "admin" | "user";
    password?: string;
  };

  const updates: Record<string, unknown> = {};
  if (display_name !== undefined) updates.display_name = display_name || null;
  if (role && (role === "admin" || role === "user")) updates.role = role;
  if (password) updates.password_hash = await hashPassword(password);

  if (Object.keys(updates).length === 0) {
    return NextResponse.json({ error: "No fields to update" }, { status: 400 });
  }

  const supabase = getSupabaseServer();
  const { error } = await supabase.from("users").update(updates).eq("id", id);

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  const actor = getUserFromRequest(request);
  logActivity(actor, "admin_update_user", `/api/admin/users/${id}`, {
    updated_fields: Object.keys(updates),
  });

  return NextResponse.json({ success: true });
}
