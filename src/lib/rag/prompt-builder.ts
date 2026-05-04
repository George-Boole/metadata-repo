import { getSupabaseServer } from "../supabase";
import type { ChunkMatch } from "./vector-search";
import type { GraphContext } from "./graph-search";

const DEFAULT_SYSTEM_PROMPT = `You are the DAF Standards Brain, an AI assistant for the Department of the Air Force Metadata Standards Repository. Answer questions about metadata standards, specifications, and guidance documents. Always cite your sources using [Source Title](url) format. If you don't know the answer, say so — do not make up information.`;

/**
 * Get the system prompt from app_settings, with fallback.
 */
export async function getSystemPrompt(): Promise<string> {
  try {
    const supabase = getSupabaseServer();
    const { data } = await supabase
      .from("app_settings")
      .select("value")
      .eq("key", "system_prompt")
      .single();

    return (data?.value as string) || DEFAULT_SYSTEM_PROMPT;
  } catch {
    return DEFAULT_SYSTEM_PROMPT;
  }
}

/**
 * Build the full prompt by combining the system prompt with retrieved context chunks.
 */
export function buildContextPrompt(
  systemPrompt: string,
  chunks: ChunkMatch[]
): string {
  if (chunks.length === 0) {
    return (
      systemPrompt +
      "\n\nNo relevant content was found in the knowledge base for this query. Let the user know you don't have information on this topic yet, and suggest they try a different question."
    );
  }

  const contextBlocks = chunks
    .map((chunk, i) => {
      const source = chunk.source_title
        ? `[${chunk.source_title}](${chunk.source_url})`
        : chunk.source_url || "Unknown source";
      const heading = chunk.heading ? ` > ${chunk.heading}` : "";
      const tier = chunk.tier ? ` [Tier: ${chunk.tier}]` : "";

      return `--- Context ${i + 1}${tier} ---\nSource: ${source}${heading}\n\n${chunk.content}`;
    })
    .join("\n\n");

  return `${systemPrompt}

## Retrieved Context

The following content was retrieved from the knowledge base. Use it to answer the user's question. Always cite sources using [Source Title](url) format when referencing this content.

${contextBlocks}

## Instructions

- Ground your answer in the retrieved context above.
- Cite every claim using [Source Title](url) format so the user can verify.
- If the context doesn't contain enough information to answer fully, say what you can and note the gap.
- Do not fabricate information not present in the context.`;
}

/**
 * Build hybrid context prompt that includes both retrieved chunks and graph relationships.
 */
export function buildHybridContextPrompt(
  systemPrompt: string,
  chunks: ChunkMatch[],
  graphContext: GraphContext,
): string {
  const basePrompt = buildContextPrompt(systemPrompt, chunks);

  // If no graph context, return the base prompt
  if (graphContext.relationships.length === 0) {
    return basePrompt;
  }

  // Format graph relationships as additional context
  const relLines = graphContext.relationships.map((r) => {
    const relLabel = r.relType.replace(/_/g, " ").toLowerCase();
    return `- ${r.from} ${relLabel} ${r.to}`;
  });

  const graphSection = `

## Knowledge Graph Context

The following relationships were found in the standards knowledge graph for entities mentioned in the query:

${relLines.join("\n")}

Use these relationships to provide more complete and accurate answers about how standards relate to each other.`;

  return basePrompt + graphSection;
}
