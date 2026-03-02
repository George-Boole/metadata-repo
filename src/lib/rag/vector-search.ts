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
 * Hybrid search: combines vector similarity with full-text keyword matching.
 * Ensures results aren't limited to only semantically similar content —
 * explicit keyword mentions (e.g., "W3C", "DCAT") surface relevant chunks
 * even when the embedding distance is large.
 */
export async function vectorSearch(
  options: VectorSearchOptions
): Promise<ChunkMatch[]> {
  const {
    query,
    matchCount = 12,
    matchThreshold = 0.25,
    filterTier = null,
  } = options;

  const queryEmbedding = await embedText(query);

  const supabase = getSupabaseServer();
  const { data, error } = await supabase.rpc("hybrid_search", {
    query_embedding: JSON.stringify(queryEmbedding),
    query_text: query,
    match_threshold: matchThreshold,
    match_count: matchCount,
    filter_tier: filterTier,
    keyword_weight: 0.3,
    vector_weight: 0.7,
  });

  if (error) {
    console.error("Hybrid search error:", JSON.stringify(error));
    // Fallback to vector-only search
    const { data: fallback, error: fallbackError } = await supabase.rpc(
      "match_chunks",
      {
        query_embedding: JSON.stringify(queryEmbedding),
        match_threshold: matchThreshold,
        match_count: matchCount,
        filter_tier: filterTier,
      }
    );
    if (fallbackError) {
      console.error("Vector search fallback error:", fallbackError);
      return [];
    }
    return (fallback as ChunkMatch[]) || [];
  }

  return (data as ChunkMatch[]) || [];
}
