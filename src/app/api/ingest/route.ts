import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { ingestUrl } from "@/lib/ingest/pipeline";
import { ingestLimiter, getClientId, rateLimitResponse } from "@/lib/rate-limit";

const IngestRequestSchema = z.object({
  url: z.string().url(),
  tier: z.string().optional(),
  source_type: z.string().optional(),
  title: z.string().optional(),
  crawl_engine: z.enum(["jina", "firecrawl", "auto"]).optional(),
});

export async function POST(request: NextRequest) {
  const clientId = getClientId(request);
  const limit = ingestLimiter(clientId);
  if (!limit.success) return rateLimitResponse(limit.reset);

  try {
    const body = await request.json();
    const parsed = IngestRequestSchema.parse(body);

    const result = await ingestUrl({
      url: parsed.url,
      tier: parsed.tier,
      sourceType: parsed.source_type,
      title: parsed.title,
      crawlEngine: parsed.crawl_engine,
    });

    return NextResponse.json(result, {
      status: result.status === "success" ? 200 : 500,
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: "Invalid request", details: error.issues },
        { status: 400 }
      );
    }

    console.error("Ingest API error:", error);
    return NextResponse.json(
      { error: "Failed to ingest content" },
      { status: 500 }
    );
  }
}
