"use client";

import { useChat } from "@ai-sdk/react";
import { useState, useRef, useEffect } from "react";
import Link from "next/link";

const SUGGESTED_QUESTIONS = [
  "What metadata standard should I use for security markings?",
  "How do NIEM domain profiles work?",
  "What's the difference between stored and linked artifacts?",
  "Which tools support IC-ISM tagging?",
  "What guidance covers data sharing?",
];

const CAPABILITIES = [
  "Answer questions about any standard in the repository",
  "Explain relationships between guidance, specs, and tools",
  "Recommend the right standard for a given use case",
  "Compare metadata specifications across domains",
  "Trace compliance requirements from policy to implementation",
  "Identify which tools support specific standards",
];

function formatMessageContent(content: string) {
  const parts = content.split(/(\[.*?\]\(.*?\)|\*\*.*?\*\*)/g);
  return parts.map((part, i) => {
    const linkMatch = part.match(/^\[(.*?)\]\((.*?)\)$/);
    if (linkMatch) {
      return (
        <Link
          key={i}
          href={linkMatch[2]}
          className="font-medium text-brain underline decoration-brain/30 hover:decoration-brain"
          target={linkMatch[2].startsWith("http") ? "_blank" : undefined}
          rel={linkMatch[2].startsWith("http") ? "noopener noreferrer" : undefined}
        >
          {linkMatch[1]}
        </Link>
      );
    }
    const boldMatch = part.match(/^\*\*(.*?)\*\*$/);
    if (boldMatch) {
      return <strong key={i}>{boldMatch[1]}</strong>;
    }
    return part;
  });
}

/** Extract plain text from UIMessage parts */
function getMessageText(parts: { type: string; text?: string }[]): string {
  return parts
    .filter((p) => p.type === "text" && p.text)
    .map((p) => p.text!)
    .join("");
}

export default function StandardsBrainPage() {
  const [input, setInput] = useState("");
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const { messages, sendMessage, status } = useChat({
    id: "standards-brain",
    messages: [
      {
        id: "welcome",
        role: "assistant",
        parts: [
          {
            type: "text" as const,
            text: "Hello! I'm the Standards Brain — an AI assistant trained on the DAF Metadata Repository. Ask me about any standard, guidance document, specification, or tool, and I'll provide contextual answers with source citations.\n\nTry one of the suggested questions, or type your own!",
          },
        ],
      },
    ],
  });

  const isLoading = status === "submitted" || status === "streaming";

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!input.trim() || isLoading) return;
    sendMessage({ text: input });
    setInput("");
  }

  function handleSuggestedQuestion(question: string) {
    if (isLoading) return;
    sendMessage({ text: question });
  }

  return (
    <div className="min-h-screen bg-daf-light-gray">
      <div className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
        {/* Page Header */}
        <div className="mb-6 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-brain text-white">
              <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M9.813 15.904L9 18.75l-.813-2.846a4.5 4.5 0 00-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 003.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 003.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 00-3.09 3.09zM18.259 8.715L18 9.75l-.259-1.035a3.375 3.375 0 00-2.455-2.456L14.25 6l1.036-.259a3.375 3.375 0 002.455-2.456L18 2.25l.259 1.035a3.375 3.375 0 002.455 2.456L21.75 6l-1.036.259a3.375 3.375 0 00-2.455 2.456z" />
              </svg>
            </div>
            <div>
              <h1 className="text-2xl font-bold text-daf-dark-gray">Standards Brain</h1>
              <p className="text-sm text-gray-500">AI-powered standards assistant</p>
            </div>
          </div>
          <span className="rounded-full bg-green-100 px-3 py-1 text-xs font-semibold text-green-700">
            Live
          </span>
        </div>

        <div className="grid gap-6 lg:grid-cols-[280px_1fr]">
          {/* Sidebar */}
          <div className="space-y-4">
            {/* Capabilities Card */}
            <div className="rounded-lg bg-slate-900 p-5 text-white shadow-lg">
              <div className="mb-3 flex items-center gap-2">
                <svg className="h-5 w-5 text-brain" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" d="M9.813 15.904L9 18.75l-.813-2.846a4.5 4.5 0 00-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 003.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 003.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 00-3.09 3.09zM18.259 8.715L18 9.75l-.259-1.035a3.375 3.375 0 00-2.455-2.456L14.25 6l1.036-.259a3.375 3.375 0 002.455-2.456L18 2.25l.259 1.035a3.375 3.375 0 002.455 2.456L21.75 6l-1.036.259a3.375 3.375 0 00-2.455 2.456z" />
                </svg>
                <h2 className="text-sm font-semibold">Capabilities</h2>
              </div>
              <ul className="space-y-2">
                {CAPABILITIES.map((cap) => (
                  <li key={cap} className="flex items-start gap-2 text-xs text-slate-300">
                    <svg className="mt-0.5 h-3 w-3 shrink-0 text-brain" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                    </svg>
                    {cap}
                  </li>
                ))}
              </ul>
            </div>

            {/* Suggested Questions */}
            <div className="rounded-lg border border-gray-200 bg-white p-5 shadow-sm">
              <h2 className="mb-3 text-sm font-semibold text-daf-dark-gray">
                Suggested Questions
              </h2>
              <div className="space-y-2">
                {SUGGESTED_QUESTIONS.map((q) => (
                  <button
                    key={q}
                    onClick={() => handleSuggestedQuestion(q)}
                    disabled={isLoading}
                    className="w-full rounded-lg border border-gray-200 px-3 py-2 text-left text-xs text-gray-700 transition hover:border-brain/40 hover:bg-brain-bg hover:text-brain disabled:opacity-50"
                  >
                    {q}
                  </button>
                ))}
              </div>
            </div>
          </div>

          {/* Chat Area */}
          <div className="flex flex-col rounded-lg border border-gray-200 bg-white shadow-sm">
            {/* Messages */}
            <div className="flex-1 overflow-y-auto p-4 space-y-4" style={{ minHeight: "400px", maxHeight: "600px" }}>
              {messages.map((msg) => {
                const text = getMessageText(msg.parts as { type: string; text?: string }[]);
                if (!text) return null;
                const isUser = (msg.role as string) === "user";

                return (
                  <div
                    key={msg.id}
                    className={`flex ${isUser ? "justify-end" : "justify-start"}`}
                  >
                    <div
                      className={`max-w-[85%] rounded-xl px-4 py-3 ${
                        isUser
                          ? "bg-brain text-white"
                          : "border border-gray-200 bg-gray-50 text-gray-800"
                      }`}
                    >
                      {!isUser && (
                        <div className="mb-1 flex items-center gap-1.5">
                          <svg className="h-3.5 w-3.5 text-brain" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M9.813 15.904L9 18.75l-.813-2.846a4.5 4.5 0 00-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 003.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 003.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 00-3.09 3.09z" />
                          </svg>
                          <span className="text-xs font-medium text-brain">Standards Brain</span>
                        </div>
                      )}
                      <div className="text-sm leading-relaxed whitespace-pre-line">
                        {formatMessageContent(text)}
                      </div>
                    </div>
                  </div>
                );
              })}

              {/* Typing indicator */}
              {isLoading && (
                <div className="flex justify-start">
                  <div className="rounded-xl border border-gray-200 bg-gray-50 px-4 py-3">
                    <div className="flex items-center gap-1.5">
                      <svg className="h-3.5 w-3.5 text-brain" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" d="M9.813 15.904L9 18.75l-.813-2.846a4.5 4.5 0 00-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 003.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 003.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 00-3.09 3.09z" />
                      </svg>
                      <span className="text-xs font-medium text-brain">Thinking...</span>
                    </div>
                    <div className="mt-2 flex gap-1">
                      <span className="h-2 w-2 animate-bounce rounded-full bg-brain/60" style={{ animationDelay: "0ms" }} />
                      <span className="h-2 w-2 animate-bounce rounded-full bg-brain/60" style={{ animationDelay: "150ms" }} />
                      <span className="h-2 w-2 animate-bounce rounded-full bg-brain/60" style={{ animationDelay: "300ms" }} />
                    </div>
                  </div>
                </div>
              )}

              <div ref={messagesEndRef} />
            </div>

            {/* Input */}
            <div className="border-t border-gray-200 p-4">
              <form onSubmit={handleSubmit} className="flex gap-3">
                <input
                  type="text"
                  value={input}
                  onChange={(e) => setInput(e.target.value)}
                  placeholder="Ask about any standard, guidance, or tool..."
                  disabled={isLoading}
                  className="flex-1 rounded-lg border border-gray-300 px-4 py-2.5 text-sm text-gray-900 placeholder-gray-400 focus:border-brain focus:outline-none focus:ring-1 focus:ring-brain disabled:opacity-50"
                />
                <button
                  type="submit"
                  disabled={!input.trim() || isLoading}
                  className="rounded-lg bg-brain px-4 py-2.5 text-sm font-medium text-white hover:bg-brain/90 disabled:opacity-50 disabled:hover:bg-brain"
                >
                  <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M6 12L3.269 3.126A59.768 59.768 0 0121.485 12 59.77 59.77 0 013.27 20.876L5.999 12zm0 0h7.5" />
                  </svg>
                </button>
              </form>
            </div>
          </div>
        </div>

        {/* How It Works Section */}
        <div className="mt-8 rounded-lg border border-gray-200 bg-white p-8 shadow-sm">
          <h2 className="mb-4 text-xl font-bold text-daf-dark-gray">
            How It Works
          </h2>
          <p className="mb-6 text-sm text-gray-600 max-w-3xl">
            Standards Brain uses Retrieval-Augmented Generation (RAG) to provide
            grounded, accurate answers about any standard in the repository.
          </p>
          <div className="grid gap-6 sm:grid-cols-3">
            <div className="rounded-lg border border-brain/20 bg-brain-bg/50 p-5">
              <div className="mb-3 flex h-10 w-10 items-center justify-center rounded-lg bg-brain/10 text-brain">
                <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m2.25 0H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z" />
                </svg>
              </div>
              <h3 className="mb-1 font-semibold text-daf-dark-gray">1. Ingest</h3>
              <p className="text-sm text-gray-600">
                Guidance documents, specifications, and tools are crawled from
                authoritative sources, chunked, and embedded into a vector
                database.
              </p>
            </div>
            <div className="rounded-lg border border-brain/20 bg-brain-bg/50 p-5">
              <div className="mb-3 flex h-10 w-10 items-center justify-center rounded-lg bg-brain/10 text-brain">
                <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z" />
                </svg>
              </div>
              <h3 className="mb-1 font-semibold text-daf-dark-gray">2. Retrieve</h3>
              <p className="text-sm text-gray-600">
                Your question is embedded and matched against the knowledge
                base using semantic similarity search to find the most relevant
                passages.
              </p>
            </div>
            <div className="rounded-lg border border-brain/20 bg-brain-bg/50 p-5">
              <div className="mb-3 flex h-10 w-10 items-center justify-center rounded-lg bg-brain/10 text-brain">
                <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" d="M9.813 15.904L9 18.75l-.813-2.846a4.5 4.5 0 00-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 003.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 003.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 00-3.09 3.09z" />
                </svg>
              </div>
              <h3 className="mb-1 font-semibold text-daf-dark-gray">3. Synthesize</h3>
              <p className="text-sm text-gray-600">
                An LLM generates a natural-language response grounded in the
                retrieved content, with inline citations and links back to
                source documents.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
