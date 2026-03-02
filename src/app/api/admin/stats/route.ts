import { NextResponse } from "next/server";
import { getSupabaseServer } from "@/lib/supabase";

export async function GET() {
  const supabase = getSupabaseServer();

  const [sourcesRes, chunksRes, usersRes] = await Promise.all([
    supabase.from("sources").select("status"),
    supabase.from("chunks").select("id", { count: "exact", head: true }),
    supabase.from("users").select("id", { count: "exact", head: true }),
  ]);

  const sources = sourcesRes.data || [];
  const active = sources.filter((s) => s.status === "active").length;
  const pending = sources.filter((s) => s.status === "pending").length;
  const error = sources.filter((s) => s.status === "error").length;

  return NextResponse.json({
    sources: {
      total: sources.length,
      active,
      pending,
      error,
    },
    chunks: chunksRes.count ?? 0,
    users: usersRes.count ?? 0,
  });
}
