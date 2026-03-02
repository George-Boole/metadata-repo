import { crawlUrl, CrawlEngine } from "./crawl";
import { chunkMarkdown } from "./chunker";
import { embedTexts } from "../embeddings";
import { getSupabaseServer } from "../supabase";
import { runCypher } from "../neo4j";

export interface IngestOptions {
  url: string;
  tier?: string;
  sourceType?: string;
  title?: string;
  crawlEngine?: CrawlEngine;
}

export interface IngestResult {
  sourceId: string;
  url: string;
  title: string;
  chunkCount: number;
  status: "success" | "error";
  error?: string;
}

export async function ingestUrl(options: IngestOptions): Promise<IngestResult> {
  const supabase = getSupabaseServer();
  let title = options.title || "";

  try {
    // 1. Crawl
    const crawled = await crawlUrl(options.url, options.crawlEngine);
    title = options.title || crawled.title || new URL(options.url).hostname;

    // 2. Chunk
    const chunks = chunkMarkdown(crawled.markdown);
    if (chunks.length === 0) {
      return {
        sourceId: "",
        url: options.url,
        title,
        chunkCount: 0,
        status: "error",
        error: "No content extracted from URL",
      };
    }

    // 3. Prepend source context to each chunk for better embedding relevance
    const contextPrefix = [
      title ? `Source: ${title}` : null,
      options.tier ? `Tier: ${options.tier}` : null,
      options.sourceType ? `Type: ${options.sourceType}` : null,
      options.url ? `URL: ${options.url}` : null,
    ]
      .filter(Boolean)
      .join(" | ");

    const enrichedChunks = chunks.map((c) => ({
      ...c,
      content: contextPrefix
        ? `[${contextPrefix}]\n\n${c.content}`
        : c.content,
    }));

    // 4. Embed all chunks (using enriched content)
    const embeddings = await embedTexts(enrichedChunks.map((c) => c.content));

    // 4. Upsert source record
    const { data: source, error: sourceError } = await supabase
      .from("sources")
      .upsert(
        {
          url: options.url,
          title,
          source_type: options.sourceType || "webpage",
          tier: options.tier || null,
          status: "active",
          chunk_count: chunks.length,
          error_message: null,
          metadata: { description: crawled.description || null },
        },
        { onConflict: "url" }
      )
      .select("id")
      .single();

    if (sourceError || !source) {
      return {
        sourceId: "",
        url: options.url,
        title,
        chunkCount: 0,
        status: "error",
        error: sourceError?.message || "Failed to create source",
      };
    }

    // 5. Delete existing chunks for this source (handles re-ingestion)
    await supabase.from("chunks").delete().eq("source_id", source.id);

    // 6. Insert chunks in batches (using enriched content with source context)
    const chunkRows = enrichedChunks.map((chunk, i) => ({
      source_id: source.id,
      content: chunk.content,
      embedding: JSON.stringify(embeddings[i]),
      chunk_type: "text",
      source_url: options.url,
      source_title: title,
      tier: options.tier || null,
      heading: chunk.heading || null,
      metadata: {
        index: chunk.index,
        token_estimate: chunk.tokenEstimate,
      },
    }));

    const CHUNK_BATCH_SIZE = 50;
    for (let i = 0; i < chunkRows.length; i += CHUNK_BATCH_SIZE) {
      const batch = chunkRows.slice(i, i + CHUNK_BATCH_SIZE);
      const { error } = await supabase.from("chunks").insert(batch);
      if (error) {
        // Update source status to reflect partial failure
        await supabase
          .from("sources")
          .update({
            status: "error",
            error_message: `Chunk insert failed at batch ${i}: ${error.message}`,
          })
          .eq("id", source.id);

        return {
          sourceId: source.id,
          url: options.url,
          title,
          chunkCount: i,
          status: "error",
          error: `Chunk insert failed at batch ${i}: ${error.message}`,
        };
      }
    }

    // 7. Create/update Neo4j node (optional — don't fail if Neo4j is down)
    try {
      await runCypher(
        `
        MERGE (s:Source {url: $url})
        SET s.title = $title,
            s.tier = $tier,
            s.source_type = $sourceType,
            s.chunk_count = $chunkCount,
            s.updated_at = datetime()
        `,
        {
          url: options.url,
          title,
          tier: options.tier || "",
          sourceType: options.sourceType || "webpage",
          chunkCount: chunks.length,
        }
      );
    } catch (e) {
      console.warn("Neo4j node creation failed (non-fatal):", e);
    }

    return {
      sourceId: source.id,
      url: options.url,
      title,
      chunkCount: chunks.length,
      status: "success",
    };
  } catch (e) {
    // Update source with error if it exists
    const errMsg = e instanceof Error ? e.message : String(e);
    try {
      await supabase
        .from("sources")
        .update({ status: "error", error_message: errMsg })
        .eq("url", options.url);
    } catch {
      // ignore — source may not exist yet
    }

    return {
      sourceId: "",
      url: options.url,
      title,
      chunkCount: 0,
      status: "error",
      error: errMsg,
    };
  }
}
