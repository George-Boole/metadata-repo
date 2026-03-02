import { NextRequest, NextResponse } from "next/server";
import { getSupabaseServer } from "@/lib/supabase";
import { adminLimiter, getClientId, rateLimitResponse } from "@/lib/rate-limit";

export async function GET(request: NextRequest) {
  const clientId = getClientId(request);
  const limit = adminLimiter(clientId);
  if (!limit.success) return rateLimitResponse(limit.reset);

  try {
    const supabase = getSupabaseServer();

    const [sourcesRes, chunksRes, usersRes] = await Promise.all([
      supabase.from("sources").select("status"),
      supabase.from("chunks").select("id", { count: "exact", head: true }),
      supabase.from("users").select("id", { count: "exact", head: true }),
    ]);

    if (sourcesRes.error || chunksRes.error || usersRes.error) {
      console.error("Stats API errors:", {
        sources: sourcesRes.error,
        chunks: chunksRes.error,
        users: usersRes.error,
      });
      return NextResponse.json(
        { error: "Failed to load statistics" },
        { status: 500 }
      );
    }

    const sources = sourcesRes.data || [];
    const active = sources.filter((s) => s.status === "active").length;
    const pending = sources.filter((s) => s.status === "pending").length;
    const errored = sources.filter((s) => s.status === "error").length;

    return NextResponse.json({
      sources: {
        total: sources.length,
        active,
        pending,
        error: errored,
      },
      chunks: chunksRes.count ?? 0,
      users: usersRes.count ?? 0,
    });
  } catch (error) {
    console.error("Stats API error:", error);
    return NextResponse.json(
      { error: "Failed to load statistics" },
      { status: 500 }
    );
  }
}
