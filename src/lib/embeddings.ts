const EMBEDDING_MODEL = "text-embedding-3-small";
const EMBEDDING_DIMENSIONS = 512;
const BATCH_SIZE = 100;

interface EmbeddingResponse {
  data: { embedding: number[]; index: number }[];
  usage: { prompt_tokens: number; total_tokens: number };
}

async function callOpenAIEmbeddings(
  input: string | string[]
): Promise<number[][]> {
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) throw new Error("Missing OPENAI_API_KEY");

  const response = await fetch("https://api.openai.com/v1/embeddings", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: EMBEDDING_MODEL,
      input,
      dimensions: EMBEDDING_DIMENSIONS,
    }),
  });

  if (!response.ok) {
    const err = await response.text();
    throw new Error(`OpenAI Embeddings API error (${response.status}): ${err}`);
  }

  const result: EmbeddingResponse = await response.json();
  // Sort by index to ensure correct ordering
  return result.data
    .sort((a, b) => a.index - b.index)
    .map((d) => d.embedding);
}

export async function embedText(text: string): Promise<number[]> {
  const [embedding] = await callOpenAIEmbeddings(text);
  return embedding;
}

export async function embedTexts(texts: string[]): Promise<number[][]> {
  if (texts.length === 0) return [];

  const results: number[][] = [];
  for (let i = 0; i < texts.length; i += BATCH_SIZE) {
    const batch = texts.slice(i, i + BATCH_SIZE);
    const embeddings = await callOpenAIEmbeddings(batch);
    results.push(...embeddings);
  }
  return results;
}
