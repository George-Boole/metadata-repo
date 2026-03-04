"use client";

import { useChat } from "@ai-sdk/react";
import { useState, useRef, useEffect, useCallback } from "react";
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

interface Conversation {
  id: string;
  title: string;
  updated_at: string;
}

interface SavedMessage {
  id: string;
  role: "user" | "assistant";
  content: string;
  created_at: string;
}

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

function getMessageText(parts: { type: string; text?: string }[]): string {
  return parts
    .filter((p) => p.type === "text" && p.text)
    .map((p) => p.text!)
    .join("");
}

const WELCOME_MESSAGE = {
  id: "welcome",
  role: "assistant" as const,
  parts: [
    {
      type: "text" as const,
      text: "Hello! I'm the Standards Brain \u2014 an AI assistant trained on the DAF Metadata Repository. Ask me about any standard, guidance document, specification, or tool, and I'll provide contextual answers with source citations.\n\nTry one of the suggested questions, or type your own!",
    },
  ],
};

export default function StandardsBrainPage() {
  const [input, setInput] = useState("");
  const [conversationId, setConversationId] = useState<string | null>(null);
  const [conversations, setConversations] = useState<Conversation[]>([]);
  const [historyOpen, setHistoryOpen] = useState(false);
  const [historyLoading, setHistoryLoading] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const conversationIdRef = useRef<string | null>(null);
  conversationIdRef.current = conversationId;

  const { messages, sendMessage, status, setMessages } = useChat({
    id: "standards-brain",
    messages: [WELCOME_MESSAGE],
  });

  const isLoading = status === "submitted" || status === "streaming";

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  const loadConversations = useCallback(async () => {
    setHistoryLoading(true);
    try {
      const res = await fetch("/api/conversations");
      const data = await res.json();
      setConversations(data.conversations || []);
    } catch {
      // Tables may not exist yet
    } finally {
      setHistoryLoading(false);
    }
  }, []);

  useEffect(() => {
    loadConversations();
  }, [loadConversations]);

  async function startNewConversation() {
    try {
      const res = await fetch("/api/conversations", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ title: "New conversation" }),
      });
      const data = await res.json();
      if (data.id) {
        setConversationId(data.id);
        setMessages([WELCOME_MESSAGE]);
        setHistoryOpen(false);
        loadConversations();
      }
    } catch {
      // If tables don't exist, just reset locally
      setConversationId(null);
      setMessages([WELCOME_MESSAGE]);
    }
  }

  async function loadConversation(conv: Conversation) {
    setConversationId(conv.id);
    setHistoryOpen(false);

    try {
      const res = await fetch(`/api/conversations/${conv.id}/messages`);
      const data = await res.json();
      const saved: SavedMessage[] = data.messages || [];

      if (saved.length === 0) {
        setMessages([WELCOME_MESSAGE]);
        return;
      }

      const loaded = saved.map((m) => ({
        id: m.id,
        role: m.role,
        parts: [{ type: "text" as const, text: m.content }],
      }));

      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      setMessages([WELCOME_MESSAGE, ...loaded] as any);
    } catch {
      setMessages([WELCOME_MESSAGE]);
    }
  }

  async function deleteConversation(id: string, e: React.MouseEvent) {
    e.stopPropagation();
    if (!confirm("Delete this conversation?")) return;

    await fetch(`/api/conversations/${id}`, { method: "DELETE" });
    if (conversationId === id) {
      setConversationId(null);
      setMessages([WELCOME_MESSAGE]);
    }
    loadConversations();
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!input.trim() || isLoading) return;

    // Auto-create conversation on first message if none active
    if (!conversationId) {
      try {
        const res = await fetch("/api/conversations", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ title: "New conversation" }),
        });
        const data = await res.json();
        if (data.id) {
          setConversationId(data.id);
        }
      } catch {
        // Continue without persistence
      }
    }

    sendMessage({ text: input }, { body: { conversationId: conversationIdRef.current } });
    setInput("");
  }

  function handleSuggestedQuestion(question: string) {
    if (isLoading) return;

    // Auto-create conversation
    if (!conversationId) {
      fetch("/api/conversations", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ title: "New conversation" }),
      })
        .then((r) => r.json())
        .then((data) => {
          if (data.id) setConversationId(data.id);
        })
        .catch(() => {});
    }

    sendMessage({ text: question }, { body: { conversationId: conversationIdRef.current } });
  }

  return (
    <div className="min-h-screen bg-daf-light-gray">
      <div className="mx-auto max-w-7xl px-4 py-4 sm:px-6 sm:py-6 lg:px-8">
        {/* Page Header */}
        <div className="mb-4 sm:mb-6 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-brain text-white shrink-0">
              <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M9.813 15.904L9 18.75l-.813-2.846a4.5 4.5 0 00-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 003.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 003.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 00-3.09 3.09zM18.259 8.715L18 9.75l-.259-1.035a3.375 3.375 0 00-2.455-2.456L14.25 6l1.036-.259a3.375 3.375 0 002.455-2.456L18 2.25l.259 1.035a3.375 3.375 0 002.455 2.456L21.75 6l-1.036.259a3.375 3.375 0 00-2.455 2.456z" />
              </svg>
            </div>
            <div>
              <h1 className="text-xl sm:text-2xl font-bold text-daf-dark-gray">Standards Brain</h1>
              <p className="text-xs sm:text-sm text-gray-500">AI-powered standards assistant</p>
            </div>
          </div>
          <div className="flex items-center gap-2">
            <button
              onClick={() => { setHistoryOpen(!historyOpen); if (!historyOpen) loadConversations(); }}
              className="rounded-lg border border-gray-300 bg-white px-3 py-1.5 text-xs font-medium text-gray-700 hover:bg-gray-50 flex items-center gap-1.5"
            >
              <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              History
            </button>
            <button
              onClick={startNewConversation}
              className="rounded-lg bg-brain px-3 py-1.5 text-xs font-medium text-white hover:bg-brain/90 flex items-center gap-1.5"
            >
              <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
              </svg>
              New Chat
            </button>
            <span className="rounded-full bg-green-100 px-3 py-1 text-xs font-semibold text-green-700">
              Live
            </span>
          </div>
        </div>

        {/* History Panel (slides down) */}
        {historyOpen && (
          <div className="mb-4 rounded-lg border border-gray-200 bg-white shadow-sm overflow-hidden">
            <div className="p-3 border-b border-gray-100 bg-gray-50">
              <h3 className="text-sm font-medium text-gray-700">Conversation History</h3>
            </div>
            <div className="max-h-64 overflow-y-auto">
              {historyLoading ? (
                <div className="p-4 text-center text-sm text-gray-400">Loading...</div>
              ) : conversations.length === 0 ? (
                <div className="p-4 text-center text-sm text-gray-400">
                  No conversations yet. Start chatting to create one.
                </div>
              ) : (
                <div className="divide-y divide-gray-100">
                  {conversations.map((conv) => (
                    <button
                      key={conv.id}
                      onClick={() => loadConversation(conv)}
                      className={`w-full flex items-center justify-between px-4 py-3 text-left hover:bg-gray-50 transition ${
                        conversationId === conv.id ? "bg-brain-bg" : ""
                      }`}
                    >
                      <div className="min-w-0 flex-1">
                        <div className="text-sm font-medium text-gray-800 truncate">
                          {conv.title}
                        </div>
                        <div className="text-xs text-gray-400">
                          {new Date(conv.updated_at).toLocaleDateString(undefined, {
                            month: "short",
                            day: "numeric",
                            hour: "2-digit",
                            minute: "2-digit",
                          })}
                        </div>
                      </div>
                      <button
                        onClick={(e) => deleteConversation(conv.id, e)}
                        className="ml-2 shrink-0 text-gray-300 hover:text-red-500 p-1"
                        title="Delete conversation"
                      >
                        <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
                          <path strokeLinecap="round" strokeLinejoin="round" d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0" />
                        </svg>
                      </button>
                    </button>
                  ))}
                </div>
              )}
            </div>
          </div>
        )}

        <div className="grid gap-4 sm:gap-6 lg:grid-cols-[280px_1fr]">
          {/* Sidebar — hidden on mobile, shown on lg+ */}
          <div className="hidden lg:block space-y-4">
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
            <div className="flex-1 overflow-y-auto p-3 sm:p-4 space-y-3 sm:space-y-4 h-[calc(100vh-280px)] sm:h-auto sm:min-h-[400px] sm:max-h-[600px]">
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
                      className={`max-w-[90%] sm:max-w-[85%] rounded-xl px-3 py-2 sm:px-4 sm:py-3 ${
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
            <div className="border-t border-gray-200 p-3 sm:p-4">
              <form onSubmit={handleSubmit} className="flex gap-2 sm:gap-3">
                <input
                  type="text"
                  value={input}
                  onChange={(e) => setInput(e.target.value)}
                  placeholder="Ask about any standard..."
                  disabled={isLoading}
                  className="flex-1 min-w-0 rounded-lg border border-gray-300 px-3 py-2.5 sm:px-4 text-sm text-gray-900 placeholder-gray-400 focus:border-brain focus:outline-none focus:ring-1 focus:ring-brain disabled:opacity-50"
                />
                <button
                  type="submit"
                  disabled={!input.trim() || isLoading}
                  className="shrink-0 rounded-lg bg-brain px-3 py-2.5 sm:px-4 text-sm font-medium text-white hover:bg-brain/90 disabled:opacity-50 disabled:hover:bg-brain"
                >
                  <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M6 12L3.269 3.126A59.768 59.768 0 0121.485 12 59.77 59.77 0 013.27 20.876L5.999 12zm0 0h7.5" />
                  </svg>
                </button>
              </form>
            </div>
          </div>
        </div>

        {/* Mobile Suggested Questions — visible below chat on small screens */}
        <div className="mt-4 rounded-lg border border-gray-200 bg-white p-4 shadow-sm lg:hidden">
          <h2 className="mb-3 text-sm font-semibold text-daf-dark-gray">
            Suggested Questions
          </h2>
          <div className="flex flex-wrap gap-2">
            {SUGGESTED_QUESTIONS.map((q) => (
              <button
                key={q}
                onClick={() => handleSuggestedQuestion(q)}
                disabled={isLoading}
                className="rounded-full border border-gray-200 px-3 py-1.5 text-xs text-gray-700 transition hover:border-brain/40 hover:bg-brain-bg hover:text-brain disabled:opacity-50"
              >
                {q}
              </button>
            ))}
          </div>
        </div>

        {/* How It Works Section */}
        <div className="mt-6 sm:mt-8 rounded-lg border border-gray-200 bg-white p-4 sm:p-8 shadow-sm">
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
