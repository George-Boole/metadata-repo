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
    model: google("gemini-2.5-flash"),
    schema: ExtractionSchema,
    prompt: `You are analyzing content from "${sourceTitle}" to build a knowledge graph of metadata standards and related entities.

Extract ONLY well-known, named standards, specifications, guidance documents, tools, ontologies, and organizations mentioned in the text below.

For each pair of related entities, identify the relationship type:
- MANDATES: a policy document mandates use of a standard
- REFERENCES: a document references another standard or specification
- IMPLEMENTS: a tool or profile implements a standard
- SUPPORTS: a tool supports a standard or specification
- CHILD_OF: a sub-specification is a child of a parent spec
- PART_OF: an element or component is part of a larger spec

Rules for entity extraction:
- Use canonical short names (e.g., "IC-ISM" not "Information Security Marking", "NIEM" not "National Information Exchange Model")
- Include common aliases (e.g., name: "IC-ISM", aliases: ["ISM", "Information Security Marking"])
- Only extract entities that are distinct, named standards/specs/tools/organizations
- Maximum 15 entities per extraction — focus on the most important ones
- Only extract relationships that are explicitly stated in the text, with brief evidence quotes

DO NOT extract any of the following as entities:
- File names (e.g., "CVEnumISM25X.xsd", "ISM_CAPCO_RESOURCE.sch", "Declass.pdf")
- XSD element/type names (e.g., "xs:complexType", "edh:DataItemCreateDateTime", "ism:SCIcontrols")
- Schema namespace URIs (e.g., "urn:us:gov:ic:edh", "http://www.w3.org/2001/XMLSchema")
- Version numbers as standalone entities (e.g., "v13", "2.1", "25X")
- Navigation/sidebar links or boilerplate website content
- Generic terms like "metadata", "XML", "schema", "specification" as entities
- Individual Schematron rules or assertion IDs
- Authors, editors, or individual people

Content:
${combined}`,
  });

  return object;
}
