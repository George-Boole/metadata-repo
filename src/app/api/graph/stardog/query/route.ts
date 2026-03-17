import { NextResponse } from "next/server";
import { NextRequest } from "next/server";
import { isStardogConfigured, runSparqlSelect } from "@/lib/stardog";

export async function POST(request: NextRequest) {
  try {
    if (!isStardogConfigured()) {
      return NextResponse.json({ error: "Stardog not configured" }, { status: 503 });
    }

    const { sparql } = await request.json();

    if (!sparql || typeof sparql !== "string") {
      return NextResponse.json({ error: "Missing sparql parameter" }, { status: 400 });
    }

    // Safety: only allow read queries from the UI
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
