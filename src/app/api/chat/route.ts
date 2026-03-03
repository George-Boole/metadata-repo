import { streamText, convertToModelMessages, type UIMessage } from "ai";
import { hybridRetrieve } from "@/lib/rag/hybrid-retriever";
import { resolveActiveModel } from "@/lib/rag/model-resolver";
import { getSystemPrompt, buildHybridContextPrompt } from "@/lib/rag/prompt-builder";
import { chatLimiter, getClientId, rateLimitResponse } from "@/lib/rate-limit";

export const maxDuration = 60;

export async function POST(request: Request) {
  const clientId = getClientId(request);
  const limit = chatLimiter(clientId);
  if (!limit.success) return rateLimitResponse(limit.reset);

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

    // Parallel: resolve model + get system prompt + hybrid retrieve (vector + graph)
    const [{ model }, systemPrompt, { chunks, graphContext }] = await Promise.all([
      resolveActiveModel(),
      getSystemPrompt(),
      hybridRetrieve(queryText),
    ]);

    // Build the context-enhanced system prompt with graph relationships
    const fullSystemPrompt = buildHybridContextPrompt(systemPrompt, chunks, graphContext);

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
      JSON.stringify({ error: "Failed to process chat message" }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
}
