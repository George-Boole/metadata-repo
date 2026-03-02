import { streamText, convertToModelMessages, type UIMessage } from "ai";
import { vectorSearch } from "@/lib/rag/vector-search";
import { resolveActiveModel } from "@/lib/rag/model-resolver";
import { getSystemPrompt, buildContextPrompt } from "@/lib/rag/prompt-builder";

export const maxDuration = 60;

export async function POST(request: Request) {
  try {
    const { messages } = (await request.json()) as {
      messages: UIMessage[];
    };

    if (!messages || !Array.isArray(messages) || messages.length === 0) {
      return new Response(JSON.stringify({ error: "No messages provided" }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    }

    // Extract the latest user message text for RAG retrieval
    const lastUserMessage = [...messages]
      .reverse()
      .find((m) => m.role === "user");

    if (!lastUserMessage) {
      return new Response(
        JSON.stringify({ error: "No user message found" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // Get text from the message parts
    const queryText = lastUserMessage.parts
      .filter((p): p is { type: "text"; text: string } => p.type === "text")
      .map((p) => p.text)
      .join(" ");

    if (!queryText.trim()) {
      return new Response(
        JSON.stringify({ error: "Empty user message" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // Parallel: resolve model + get system prompt + vector search
    const [{ model }, systemPrompt, chunks] = await Promise.all([
      resolveActiveModel(),
      getSystemPrompt(),
      vectorSearch({
        query: queryText,
        matchCount: 8,
        matchThreshold: 0.3,
      }),
    ]);

    // Build the context-enhanced system prompt
    const fullSystemPrompt = buildContextPrompt(systemPrompt, chunks);

    // Convert UI messages to model messages
    const modelMessages = await convertToModelMessages(messages);

    // Stream the response
    const result = streamText({
      model,
      system: fullSystemPrompt,
      messages: modelMessages,
    });

    return result.toUIMessageStreamResponse();
  } catch (error) {
    console.error("Chat API error:", error);
    return new Response(
      JSON.stringify({
        error: error instanceof Error ? error.message : "Chat failed",
      }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
}
