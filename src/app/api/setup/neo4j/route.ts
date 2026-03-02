import { NextResponse } from "next/server";
import { runCypher } from "@/lib/neo4j";

export async function POST() {
  try {
    // Create uniqueness constraints
    const constraints = [
      "CREATE CONSTRAINT standard_id IF NOT EXISTS FOR (s:Standard) REQUIRE s.id IS UNIQUE",
      "CREATE CONSTRAINT guidance_id IF NOT EXISTS FOR (g:Guidance) REQUIRE g.id IS UNIQUE",
      "CREATE CONSTRAINT profile_id IF NOT EXISTS FOR (p:Profile) REQUIRE p.id IS UNIQUE",
      "CREATE CONSTRAINT tool_id IF NOT EXISTS FOR (t:Tool) REQUIRE t.id IS UNIQUE",
      "CREATE CONSTRAINT ontology_id IF NOT EXISTS FOR (o:Ontology) REQUIRE o.id IS UNIQUE",
      "CREATE CONSTRAINT element_id IF NOT EXISTS FOR (e:Element) REQUIRE e.id IS UNIQUE",
    ];

    // Create indexes for common query properties
    const indexes = [
      "CREATE INDEX standard_name IF NOT EXISTS FOR (s:Standard) ON (s.name)",
      "CREATE INDEX guidance_name IF NOT EXISTS FOR (g:Guidance) ON (g.name)",
      "CREATE INDEX profile_name IF NOT EXISTS FOR (p:Profile) ON (p.name)",
      "CREATE INDEX tool_name IF NOT EXISTS FOR (t:Tool) ON (t.name)",
      "CREATE INDEX ontology_name IF NOT EXISTS FOR (o:Ontology) ON (o.name)",
      "CREATE INDEX standard_tier IF NOT EXISTS FOR (s:Standard) ON (s.tier)",
    ];

    const results: string[] = [];

    for (const q of [...constraints, ...indexes]) {
      await runCypher(q);
      results.push(q.split(" ")[2] || "done");
    }

    return NextResponse.json({
      success: true,
      message: "Neo4j schema initialized",
      created: results,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unknown error";
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
