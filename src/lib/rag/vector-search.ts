import { embedText } from "../embeddings";
import { getSupabaseServer } from "../supabase";

export interface ChunkMatch {
  id: string;
  source_id: string;
  content: string;
  chunk_type: string;
  source_url: string;
  source_title: string;
  tier: string | null;
  heading: string | null;
  metadata: Record<string, unknown>;
  similarity: number;
}

export interface VectorSearchOptions {
  query: string;
  matchCount?: number;
  matchThreshold?: number;
  filterTier?: string | null;
}

/**
 * Perform vector similarity search against the chunks table.
 * Embeds the query, then calls the match_chunks RPC.
 */
export async function vectorSearch(
  options: VectorSearchOptions
): Promise<ChunkMatch[]> {
  const {
    query,
    matchCount = 8,
    matchThreshold = 0.3,
    filterTier = null,
  } = options;

  // 1. Embed the query
  const queryEmbedding = await embedText(query);

  // 2. Call Supabase RPC
  const supabase = getSupabaseServer();
  const { data, error } = await supabase.rpc("match_chunks", {
    query_embedding: JSON.stringify(queryEmbedding),
    match_threshold: matchThreshold,
    match_count: matchCount,
    filter_tier: filterTier,
  });

  if (error) {
    console.error("Vector search error:", error);
    return [];
  }

  return (data as ChunkMatch[]) || [];
}
