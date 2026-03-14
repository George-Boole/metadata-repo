import { NextRequest, NextResponse } from "next/server";
import { getSupabaseServer } from "@/lib/supabase";
import { adminLimiter, getClientId, rateLimitResponse } from "@/lib/rate-limit";

export async function GET(request: NextRequest) {
  const clientId = getClientId(request);
  const limit = adminLimiter(clientId);
  if (!limit.success) return rateLimitResponse(limit.reset);

  try {
    const supabase = getSupabaseServer();
    const url = request.nextUrl;
    const username = url.searchParams.get("username");
    const action = url.searchParams.get("action");
    const limit_param = parseInt(url.searchParams.get("limit") || "100", 10);
    const offset = parseInt(url.searchParams.get("offset") || "0", 10);

    let query = supabase
      .from("user_activity_log")
      .select("*", { count: "exact" })
      .order("created_at", { ascending: false })
      .range(offset, offset + limit_param - 1);

    if (username) query = query.eq("username", username);
    if (action) query = query.eq("action", action);

    const { data, error, count } = await query;

    if (error) {
      console.error("Activity log query error:", error);
      return NextResponse.json({ error: "Failed to load activity log" }, { status: 500 });
    }

    // Also fetch user summary stats
    const { data: users } = await supabase
      .from("users")
      .select("username, display_name, role, created_at, last_login_at, login_count")
      .order("last_login_at", { ascending: false, nullsFirst: false });

    return NextResponse.json({
      events: data || [],
      total: count ?? 0,
      users: users || [],
    });
  } catch (error) {
    console.error("Activity API error:", error);
    return NextResponse.json({ error: "Failed to load activity data" }, { status: 500 });
  }
}
