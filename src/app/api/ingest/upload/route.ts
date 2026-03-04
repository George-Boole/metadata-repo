import { NextRequest, NextResponse } from "next/server";
import { ingestFile } from "@/lib/ingest/pipeline";
import { ingestLimiter, getClientId, rateLimitResponse } from "@/lib/rate-limit";

const MAX_FILE_SIZE = 50 * 1024 * 1024; // 50 MB
const ALLOWED_EXTENSIONS = ["pdf", "txt", "md", "csv", "xml", "xsd", "sch", "json"];

export async function POST(request: NextRequest) {
  const clientId = getClientId(request);
  const limit = ingestLimiter(clientId);
  if (!limit.success) return rateLimitResponse(limit.reset);

  try {
    const formData = await request.formData();
    const file = formData.get("file") as File | null;
    const tier = (formData.get("tier") as string) || undefined;
    const sourceType = (formData.get("source_type") as string) || undefined;
    const title = (formData.get("title") as string) || undefined;
    const description = (formData.get("description") as string) || undefined;

    if (!file) {
      return NextResponse.json({ error: "No file provided" }, { status: 400 });
    }

    if (file.size > MAX_FILE_SIZE) {
      return NextResponse.json({ error: "File exceeds 50 MB limit" }, { status: 400 });
    }

    const ext = file.name.split(".").pop()?.toLowerCase() || "";
    if (!ALLOWED_EXTENSIONS.includes(ext)) {
      return NextResponse.json(
        { error: `Unsupported file type: .${ext}. Allowed: ${ALLOWED_EXTENSIONS.join(", ")}` },
        { status: 400 }
      );
    }

    const buffer = Buffer.from(await file.arrayBuffer());

    const result = await ingestFile({
      filename: file.name,
      buffer,
      title,
      tier,
      sourceType,
      description,
    });

    return NextResponse.json(result, {
      status: result.status === "success" ? 200 : 500,
    });
  } catch (error) {
    console.error("Upload ingest error:", error);
    return NextResponse.json({ error: "Failed to process uploaded file" }, { status: 500 });
  }
}
