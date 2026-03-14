import { NextRequest, NextResponse } from "next/server";
import { getSupabaseServer } from "@/lib/supabase";
import { hashPassword } from "@/lib/auth";
import { adminLimiter, getClientId, rateLimitResponse } from "@/lib/rate-limit";
import { logActivity, getUserFromRequest } from "@/lib/activity-log";

export async function GET(request: NextRequest) {
  const clientId = getClientId(request);
  const limit = adminLimiter(clientId);
  if (!limit.success) return rateLimitResponse(limit.reset);

  const supabase = getSupabaseServer();
  const { data, error } = await supabase
    .from("users")
    .select("id, username, role, display_name, created_at, last_login_at, login_count")
    .order("created_at", { ascending: true });

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ users: data });
}

export async function POST(request: NextRequest) {
  const clientId = getClientId(request);
  const limit = adminLimiter(clientId);
  if (!limit.success) return rateLimitResponse(limit.reset);

  const body = await request.json();
  const { username, password, display_name, role } = body;

  if (!username || !password) {
    return NextResponse.json(
      { error: "Username and password are required" },
      { status: 400 }
    );
  }

  if (role && !["admin", "user"].includes(role)) {
    return NextResponse.json(
      { error: "Role must be 'admin' or 'user'" },
      { status: 400 }
    );
  }

  const passwordHash = await hashPassword(password);
  const supabase = getSupabaseServer();

  const { data, error } = await supabase
    .from("users")
    .insert({
      username,
      password_hash: passwordHash,
      role: role || "user",
      display_name: display_name || null,
    })
    .select("id, username, role, display_name, created_at")
    .single();

  if (error) {
    if (error.code === "23505") {
      return NextResponse.json(
        { error: "Username already exists" },
        { status: 409 }
      );
    }
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  const actor = getUserFromRequest(request);
  logActivity(actor, "admin_create_user", "/api/admin/users", {
    new_username: username,
    role: role || "user",
  });

  return NextResponse.json({ user: data }, { status: 201 });
}
