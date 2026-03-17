import { NextResponse } from "next/server";
import { runCypher } from "@/lib/neo4j";

export async function GET() {
  try {
    const [entityRes, sourceRes, relRes, mentionRes] = await Promise.all([
      runCypher<{ count: number }>("MATCH (e:Entity) RETURN count(e) AS count"),
      runCypher<{ count: number }>("MATCH (s:Source) RETURN count(s) AS count"),
      runCypher<{ count: number }>("MATCH ()-[r:RELATES_TO]->() RETURN count(r) AS count"),
      runCypher<{ count: number }>("MATCH ()-[r:MENTIONS]->() RETURN count(r) AS count"),
    ]);

    // Neo4j Integer objects have .low property
    const toNum = (val: unknown): number => {
      if (typeof val === "number") return val;
      if (val && typeof val === "object" && "low" in val) return (val as { low: number }).low;
      return 0;
    };

    return NextResponse.json({
      entities: toNum(entityRes[0]?.count),
      sources: toNum(sourceRes[0]?.count),
      relatesToCount: toNum(relRes[0]?.count),
      mentionsCount: toNum(mentionRes[0]?.count),
    });
  } catch (error) {
    console.error("Neo4j stats error:", error);
    return NextResponse.json({ error: "Failed to get Neo4j stats" }, { status: 500 });
  }
}
