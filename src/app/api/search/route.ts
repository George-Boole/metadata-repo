import { NextRequest, NextResponse } from "next/server";
import { searchSources } from "@/lib/data-server";

export async function GET(request: NextRequest) {
  const q = request.nextUrl.searchParams.get("q");
  if (!q || !q.trim()) {
    return NextResponse.json({ results: [] });
  }

  const results = await searchSources(q);
  return NextResponse.json({ results });
}
