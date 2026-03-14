import { NextRequest, NextResponse } from "next/server";
import { searchSources } from "@/lib/data-server";
import { logActivity, getUserFromRequest } from "@/lib/activity-log";

export async function GET(request: NextRequest) {
  const q = request.nextUrl.searchParams.get("q");
  if (!q || !q.trim()) {
    return NextResponse.json({ results: [] });
  }

  const username = getUserFromRequest(request);
  logActivity(username, "search", "/api/search", { query: q });

  const results = await searchSources(q);
  return NextResponse.json({ results });
}
