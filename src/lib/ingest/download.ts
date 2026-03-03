import JSZip from "jszip";

export interface ExtractedFile {
  filename: string;
  extension: string;
  path: string;
  content: Buffer;
}

const PROCESSABLE_EXTENSIONS = new Set(["pdf", "xsd", "sch", "json", "xml"]);

export async function downloadAndExtractZip(url: string): Promise<ExtractedFile[]> {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`Failed to download ZIP: ${response.status} ${response.statusText}`);
  }

  const arrayBuffer = await response.arrayBuffer();
  const zip = await JSZip.loadAsync(arrayBuffer);
  const files: ExtractedFile[] = [];

  for (const [path, entry] of Object.entries(zip.files)) {
    if (entry.dir) continue;

    const extension = path.split(".").pop()?.toLowerCase() || "";
    if (!PROCESSABLE_EXTENSIONS.has(extension)) continue;

    const content = await entry.async("nodebuffer");
    const filename = path.split("/").pop() || path;

    files.push({ filename, extension, path, content });
  }

  return files;
}
