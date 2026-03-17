import { NextResponse } from "next/server";
import { NextRequest } from "next/server";
import { runCypher } from "@/lib/neo4j";

/** Search entities by partial name match (case-insensitive, anywhere in name) */
export async function GET(request: NextRequest) {
  const q = request.nextUrl.searchParams.get("q");
  if (!q || q.trim().length < 2) {
    return NextResponse.json({ entities: [] });
  }

  try {
    const results = await runCypher<{ name: string; type: string }>(
      `MATCH (e:Entity)
       WHERE toLower(e.name) CONTAINS toLower($q)
       RETURN e.name AS name, e.type AS type
       ORDER BY size(e.name)
       LIMIT 15`,
      { q: q.trim() },
    );

    return NextResponse.json({ entities: results });
  } catch (error) {
    console.error("Entity search error:", error);
    return NextResponse.json({ entities: [] });
  }
}
