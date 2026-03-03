export async function extractPdfText(buffer: Buffer): Promise<string> {
  // pdf-parse v1 exports a single function as module.exports
  // eslint-disable-next-line @typescript-eslint/no-require-imports
  const pdfParse = require("pdf-parse");
  const data = await pdfParse(buffer);
  return data.text;
}
