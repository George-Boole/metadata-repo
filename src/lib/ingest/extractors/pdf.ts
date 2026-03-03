export async function extractPdfText(buffer: Buffer): Promise<string> {
  // Dynamic import to avoid issues with pdf-parse in edge environments
  // pdf-parse uses `export =` so the module itself is the function
  const mod = await import("pdf-parse");
  const pdfParse = (mod as unknown as { default: typeof mod }).default ?? mod;
  const data = await (pdfParse as unknown as (buf: Buffer) => Promise<{ text: string }>)(buffer);
  return data.text;
}
