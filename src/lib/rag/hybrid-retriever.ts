import { vectorSearch, type ChunkMatch } from "./vector-search";
import { graphSearch, type GraphContext } from "./graph-search";

export interface HybridResult {
  chunks: ChunkMatch[];
  graphContext: GraphContext;
}

/**
 * Hybrid retrieval: runs vector search and graph search in parallel.
 * Boosts chunks from graph-connected sources by moving them up in the results.
 */
export async function hybridRetrieve(query: string): Promise<HybridResult> {
  // Run both searches in parallel
  const [chunks, graphContext] = await Promise.all([
    vectorSearch({
      query,
      matchCount: 12,
      matchThreshold: 0.25,
    }),
    graphSearch(query).catch(() => ({
      entities: [] as string[],
      relationships: [] as Array<{ from: string; relType: string; to: string; evidence?: string }>,
      connectedSourceUrls: [] as string[],
    })),
  ]);

  // If we have graph-connected source URLs, boost those chunks
  if (graphContext.connectedSourceUrls.length > 0) {
    const connectedUrls = new Set(graphContext.connectedSourceUrls);

    // Sort: graph-connected sources first (within their similarity tier), then rest
    const boosted = [...chunks].sort((a, b) => {
      const aConnected = connectedUrls.has(a.source_url);
      const bConnected = connectedUrls.has(b.source_url);

      if (aConnected && !bConnected) return -1;
      if (!aConnected && bConnected) return 1;

      // Within same category, maintain similarity order
      return b.similarity - a.similarity;
    });

    return { chunks: boosted, graphContext };
  }

  return { chunks, graphContext };
}
