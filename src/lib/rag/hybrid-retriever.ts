import { vectorSearch, type ChunkMatch } from "./vector-search";
import { graphSearch, type GraphContext } from "./graph-search";
import { stardogGraphSearch } from "./stardog-search";

export interface HybridResult {
  chunks: ChunkMatch[];
  graphContext: GraphContext;
  stardogContext?: GraphContext;
}

const EMPTY_GRAPH: GraphContext = {
  entities: [],
  relationships: [],
  connectedSourceUrls: [],
};

/**
 * Hybrid retrieval: runs vector search, Neo4j graph search, and Stardog graph search in parallel.
 * Boosts chunks from graph-connected sources by moving them up in the results.
 */
export async function hybridRetrieve(query: string): Promise<HybridResult> {
  // Run all three searches in parallel
  const [chunks, graphContext, stardogContext] = await Promise.all([
    vectorSearch({
      query,
      matchCount: 12,
      matchThreshold: 0.25,
    }),
    graphSearch(query).catch(() => EMPTY_GRAPH),
    stardogGraphSearch(query).catch(() => EMPTY_GRAPH),
  ]);

  // Merge connected URLs from both graph backends for boosting
  const allConnectedUrls = new Set([
    ...graphContext.connectedSourceUrls,
    ...stardogContext.connectedSourceUrls,
  ]);

  // If we have graph-connected source URLs, boost those chunks
  if (allConnectedUrls.size > 0) {
    // Sort: graph-connected sources first (within their similarity tier), then rest
    const boosted = [...chunks].sort((a, b) => {
      const aConnected = allConnectedUrls.has(a.source_url);
      const bConnected = allConnectedUrls.has(b.source_url);

      if (aConnected && !bConnected) return -1;
      if (!aConnected && bConnected) return 1;

      // Within same category, maintain similarity order
      return b.similarity - a.similarity;
    });

    return { chunks: boosted, graphContext, stardogContext };
  }

  return { chunks, graphContext, stardogContext };
}
