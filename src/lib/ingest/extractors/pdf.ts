export async function extractPdfText(buffer: Buffer): Promise<string> {
  // Import the lib directly to skip index.js which tries to load a test
  // fixture via fs.readFileSync (fails in Vercel serverless)
  // eslint-disable-next-line @typescript-eslint/no-require-imports
  const pdfParse = require("pdf-parse/lib/pdf-parse");
  const data = await pdfParse(buffer);
  return data.text;
}
