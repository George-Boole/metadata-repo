import { generateObject } from "ai";
import { google } from "@ai-sdk/google";
import { z } from "zod";

const ExtractionSchema = z.object({
  entities: z.array(z.object({
    name: z.string(),
    type: z.enum(["Standard", "Guidance", "Tool", "Profile", "Ontology", "Organization"]),
    aliases: z.array(z.string()),
  })),
  relationships: z.array(z.object({
    from: z.string(),
    to: z.string(),
    type: z.enum(["MANDATES", "REFERENCES", "IMPLEMENTS", "SUPPORTS", "CHILD_OF", "PART_OF"]),
    evidence: z.string(),
  })),
});

export type ExtractionResult = z.infer<typeof ExtractionSchema>;

export async function extractEntitiesAndRelationships(
  chunks: string[],
  sourceTitle: string,
): Promise<ExtractionResult> {
  // Concatenate first N chunks, staying within ~8K tokens
  const MAX_CHARS = 32000;
  let combined = "";
  for (const chunk of chunks) {
    if (combined.length + chunk.length > MAX_CHARS) break;
    combined += chunk + "\n\n";
  }

  if (!combined.trim()) {
    return { entities: [], relationships: [] };
  }

  const { object } = await generateObject({
    model: google("gemini-2.0-flash"),
    schema: ExtractionSchema,
    prompt: `You are analyzing content from "${sourceTitle}" to build a knowledge graph of metadata standards and related entities.

Extract all named standards, specifications, guidance documents, tools, ontologies, and organizations mentioned in the text below.

For each pair of related entities, identify the relationship type:
- MANDATES: a policy document mandates use of a standard
- REFERENCES: a document references another
- IMPLEMENTS: a tool or profile implements a standard
- SUPPORTS: a tool supports a standard or specification
- CHILD_OF: a sub-specification is a child of a parent spec
- PART_OF: an element or component is part of a larger spec

Rules:
- Use canonical names (e.g., "IC-ISM" not "Information Security Marking")
- Include aliases (e.g., name: "IC-ISM", aliases: ["ISM", "Information Security Marking Implementers Guide"])
- Only extract entities and relationships that are clearly stated in the text
- Provide brief evidence quotes for each relationship

Content:
${combined}`,
  });

  return object;
}
