import { NextRequest, NextResponse } from "next/server";
import { runSparqlSelect } from "@/lib/stardog";
import { adminLimiter, getClientId, rateLimitResponse } from "@/lib/rate-limit";

export async function POST(request: NextRequest) {
  const clientId = getClientId(request);
  const limit = adminLimiter(clientId);
  if (!limit.success) return rateLimitResponse(limit.reset);

  try {
    const { sparql } = await request.json();

    if (!sparql || typeof sparql !== "string") {
      return NextResponse.json({ error: "Missing sparql parameter" }, { status: 400 });
    }

    // Safety: only allow SELECT queries from the UI
    const trimmed = sparql.trim().toUpperCase();
    if (!trimmed.startsWith("SELECT") && !trimmed.startsWith("ASK") && !trimmed.startsWith("DESCRIBE") && !trimmed.startsWith("CONSTRUCT")) {
      return NextResponse.json({ error: "Only read queries (SELECT/ASK/DESCRIBE/CONSTRUCT) are allowed" }, { status: 403 });
    }

    const results = await runSparqlSelect(sparql);
    return NextResponse.json({ results });
  } catch (error) {
    console.error("Stardog query error:", error);
    return NextResponse.json({ error: "Query execution failed" }, { status: 500 });
  }
}
