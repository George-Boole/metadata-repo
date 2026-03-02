export interface CrawlResult {
  url: string;
  title: string;
  markdown: string;
  description?: string;
}

/**
 * Crawl a URL using Jina Reader API (free, no SDK needed).
 * Returns clean markdown content.
 */
async function crawlWithJina(url: string): Promise<CrawlResult> {
  const response = await fetch(`https://r.jina.ai/${url}`, {
    headers: {
      Accept: "application/json",
      "X-Return-Format": "markdown",
    },
  });

  if (!response.ok) {
    throw new Error(`Jina Reader failed (${response.status}): ${await response.text()}`);
  }

  const data = await response.json();
  return {
    url,
    title: data.data?.title || "",
    markdown: data.data?.content || "",
    description: data.data?.description,
  };
}

/**
 * Crawl a URL using Firecrawl API (500 free credits).
 * Better for JS-heavy pages that Jina can't render.
 */
async function crawlWithFirecrawl(url: string): Promise<CrawlResult> {
  const { default: FirecrawlApp } = await import("@mendable/firecrawl-js");
  const app = new FirecrawlApp({ apiKey: process.env.FIRECRAWL_API_KEY });

  const doc = await app.scrape(url, { formats: ["markdown"] });

  return {
    url,
    title: doc.metadata?.title || "",
    markdown: doc.markdown || "",
    description: doc.metadata?.description,
  };
}

export type CrawlEngine = "jina" | "firecrawl" | "auto";

/**
 * Crawl a URL and return markdown content.
 * - "jina": Use Jina Reader only
 * - "firecrawl": Use Firecrawl only
 * - "auto" (default): Try Jina first, fall back to Firecrawl
 */
export async function crawlUrl(
  url: string,
  engine: CrawlEngine = "auto"
): Promise<CrawlResult> {
  if (engine === "firecrawl") return crawlWithFirecrawl(url);
  if (engine === "jina") return crawlWithJina(url);

  // Auto: try Jina first, fall back to Firecrawl
  try {
    return await crawlWithJina(url);
  } catch (jinaError) {
    console.warn("Jina Reader failed, trying Firecrawl:", jinaError);
    return await crawlWithFirecrawl(url);
  }
}
