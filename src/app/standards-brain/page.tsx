"use client";

import { useState, useRef, useEffect } from "react";
import Link from "next/link";

interface Message {
  id: string;
  role: "user" | "assistant";
  content: string;
  timestamp: Date;
}

interface QAPair {
  question: string;
  answer: string;
}

const SCRIPTED_QA: QAPair[] = [
  {
    question: "What metadata standard should I use for security markings?",
    answer: `The primary standard for security markings is **IC-ISM (Intelligence Community Information Security Marking)**, managed by ODNI. IC-ISM v13.0 defines XML-based attributes for marking classified and CUI data — including classification level, owner/producer, dissemination controls, and declassification dates.

**Key connections:**
- IC-ISM is mandated by [DoDI 8330.01](/guidance/guid-8330-01) (Interoperability of IT and NSS)
- It works alongside [IC-EDH](/specs/spec-ic-edh) (Enterprise Data Header) for complete security metadata
- Tools that support IC-ISM tagging include [DCAMPS-C](/tools/tool-dcamps-c) and [Boldon James Classifier](/tools/tool-boldon-james)

For a complete view of the specification and its elements, see the [IC-ISM detail page](/specs/spec-ic-ism).`,
  },
  {
    question: "How do NIEM domain profiles work?",
    answer: `NIEM uses a layered approach that maps directly to our repository's tier structure:

**Tier 2A — The Base Specs:**
[NIEM](/specs/spec-niem) provides the core framework (v6.0), including [NIEM Core](/specs/spec-niem-core) universal data types and domain-specific models like the [Justice Domain](/specs/spec-niem-justice) and [Military Operations Domain](/specs/spec-niem-mil-ops).

**Tier 2B — Domain Profiles:**
Organizations create profiles that select specific NIEM elements for their mission area. For example:
- The **AF ISR Metadata Profile** uses NIEM Core + IC-ISM for intelligence data exchange
- The **Space Force C2 Profile** combines NIEM MilOps + NIEM Core for space domain awareness

Each profile documents which spec elements it incorporates and how they're constrained for the domain. Browse all profiles on the [Domain Profiles page](/profiles).`,
  },
  {
    question: "What's the difference between stored and linked artifacts?",
    answer: `The repository uses a **dual hosting model** to balance control with currency:

**Stored Artifacts** — Full content is maintained in this repository. The DAF actively manages versioning, element listings, and detailed documentation. Best for standards the DAF controls or has adopted locally. Examples: [NIEM](/specs/spec-niem), [DDMS](/specs/spec-ddms), [Dublin Core](/specs/spec-dublin-core).

**Linked Artifacts** — The repository stores metadata *about* the standard (description, relationships, keywords) but links to the authoritative external source for the full specification. Used for externally managed standards where the canonical source should be the single point of truth. Examples: [IC-ISM](/specs/spec-ic-ism) (links to ODNI), [DCAT](/specs/spec-dcat) (links to W3C), [ISO 11179](/specs/spec-iso-11179) (links to ISO).

Both types participate equally in search, cross-referencing, and the tier hierarchy — the hosting model only affects where the full content lives.`,
  },
  {
    question: "Which tools support IC-ISM tagging?",
    answer: `Based on the repository's Tier 3 tools catalog, the following tools support IC-ISM security marking:

1. **[DCAMPS-C](/tools/tool-dcamps-c)** (DISA) — Purpose-built for DoD metadata tagging with native IC-ISM support. It provides automated classification marking, CUI tagging, and DDMS metadata generation. Production maturity, Government license.

2. **[Boldon James Classifier](/tools/tool-boldon-james)** (Boldon James / Everfox) — Enterprise classification and labeling platform with IC-ISM attribute support. Integrates with Microsoft Office, email clients, and file systems. Production maturity, Commercial license.

Both tools also support related standards like [IC-EDH](/specs/spec-ic-edh) and [DDMS](/specs/spec-ddms). For the full tools catalog, visit the [Tools page](/tools).`,
  },
  {
    question: "What guidance covers data sharing?",
    answer: `The primary guidance for data sharing across the DoD enterprise is:

**[DoDI 8320.02](/guidance/guid-8320-02) — Sharing Data, Information, and Technology (IT) Services in the DoD**
This is the foundational directive establishing the requirement for data sharing and the use of metadata standards. It mandates the use of net-centric data sharing approaches and metadata tagging for discoverability.

**Related guidance:**
- [DoDI 8320.07](/guidance/guid-8320-07) — Implements data standards for NIEM-based exchanges
- [DoDI 8310.01](/guidance/guid-8310-01) — IT Standards in the DoD, which covers the broader standards governance framework
- [DoDI 8330.01](/guidance/guid-8330-01) — Interoperability requirements including security marking for shared data

**Supporting specs mandated by this guidance:**
- [NIEM](/specs/spec-niem) — The primary data exchange framework
- [Dublin Core](/specs/spec-dublin-core) — Descriptive metadata for resource discovery
- [DDMS](/specs/spec-ddms) — DoD-specific discovery metadata

Browse all guidance on the [Authoritative Guidance page](/guidance).`,
  },
];

const FALLBACK_RESPONSE = `That's a great question! In a production implementation of Standards Brain, I would use **Retrieval-Augmented Generation (RAG)** to answer it:

1. **Embed your question** using a vector model to capture semantic meaning
2. **Search the knowledge base** of all standards documents, guidance, specs, and tool documentation in the repository
3. **Retrieve the most relevant passages** from across all tiers
4. **Synthesize a response** grounded in the actual content, with citations and links

This prototype demonstrates the concept with pre-scripted responses for common questions. Try one of the suggested questions in the sidebar to see an example of a fully-grounded answer with cross-references.`;

const CAPABILITIES = [
  "Answer questions about any standard in the repository",
  "Explain relationships between guidance, specs, and tools",
  "Recommend the right standard for a given use case",
  "Compare metadata specifications across domains",
  "Trace compliance requirements from policy to implementation",
  "Identify which tools support specific standards",
];

function formatMessageContent(content: string) {
  // Convert markdown-style links [text](/path) to actual links
  // Convert **bold** to <strong>
  const parts = content.split(/(\[.*?\]\(.*?\)|\*\*.*?\*\*)/g);
  return parts.map((part, i) => {
    const linkMatch = part.match(/^\[(.*?)\]\((.*?)\)$/);
    if (linkMatch) {
      return (
        <Link
          key={i}
          href={linkMatch[2]}
          className="font-medium text-brain underline decoration-brain/30 hover:decoration-brain"
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

export default function StandardsBrainPage() {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: "welcome",
      role: "assistant",
      content:
        "Hello! I'm the Standards Brain — an AI assistant trained on the entire DAF Metadata Repository. Ask me about any standard, guidance document, specification, or tool, and I'll provide contextual answers with direct links to relevant artifacts.\n\nTry one of the suggested questions, or type your own!",
      timestamp: new Date(),
    },
  ]);
  const [input, setInput] = useState("");
  const [isTyping, setIsTyping] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  function findAnswer(question: string): string {
    const q = question.toLowerCase().trim();
    for (const qa of SCRIPTED_QA) {
      const keywords = qa.question.toLowerCase();
      // Check if the question is similar enough
      const questionWords = q.split(/\s+/);
      const matchCount = questionWords.filter((w) =>
        keywords.includes(w)
      ).length;
      if (matchCount >= 3 || q === keywords) {
        return qa.answer;
      }
    }
    return FALLBACK_RESPONSE;
  }

  async function handleSend(text?: string) {
    const question = (text ?? input).trim();
    if (!question || isTyping) return;

    const userMsg: Message = {
      id: `user-${Date.now()}`,
      role: "user",
      content: question,
      timestamp: new Date(),
    };

    setMessages((prev) => [...prev, userMsg]);
    setInput("");
    setIsTyping(true);

    // Simulate thinking delay
    await new Promise((resolve) => setTimeout(resolve, 800 + Math.random() * 1200));

    const answer = findAnswer(question);
    const assistantMsg: Message = {
      id: `assistant-${Date.now()}`,
      role: "assistant",
      content: answer,
      timestamp: new Date(),
    };

    setIsTyping(false);
    setMessages((prev) => [...prev, assistantMsg]);
  }

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    handleSend();
  }

  function handleSuggestedQuestion(question: string) {
    handleSend(question);
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
          <span className="rounded-full bg-brain-bg px-3 py-1 text-xs font-semibold text-brain">
            Concept Demo
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
                {SCRIPTED_QA.map((qa) => (
                  <button
                    key={qa.question}
                    onClick={() => handleSuggestedQuestion(qa.question)}
                    disabled={isTyping}
                    className="w-full rounded-lg border border-gray-200 px-3 py-2 text-left text-xs text-gray-700 transition hover:border-brain/40 hover:bg-brain-bg hover:text-brain disabled:opacity-50"
                  >
                    {qa.question}
                  </button>
                ))}
              </div>
            </div>
          </div>

          {/* Chat Area */}
          <div className="flex flex-col rounded-lg border border-gray-200 bg-white shadow-sm">
            {/* Messages */}
            <div className="flex-1 overflow-y-auto p-4 space-y-4" style={{ minHeight: "400px", maxHeight: "600px" }}>
              {messages.map((msg) => (
                <div
                  key={msg.id}
                  className={`flex ${msg.role === "user" ? "justify-end" : "justify-start"}`}
                >
                  <div
                    className={`max-w-[85%] rounded-xl px-4 py-3 ${
                      msg.role === "user"
                        ? "bg-brain text-white"
                        : "border border-gray-200 bg-gray-50 text-gray-800"
                    }`}
                  >
                    {msg.role === "assistant" && (
                      <div className="mb-1 flex items-center gap-1.5">
                        <svg className="h-3.5 w-3.5 text-brain" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
                          <path strokeLinecap="round" strokeLinejoin="round" d="M9.813 15.904L9 18.75l-.813-2.846a4.5 4.5 0 00-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 003.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 003.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 00-3.09 3.09z" />
                        </svg>
                        <span className="text-xs font-medium text-brain">Standards Brain</span>
                      </div>
                    )}
                    <div className="text-sm leading-relaxed whitespace-pre-line">
                      {formatMessageContent(msg.content)}
                    </div>
                    <p
                      className={`mt-1.5 text-xs ${
                        msg.role === "user" ? "text-white/60" : "text-gray-400"
                      }`}
                    >
                      {msg.timestamp.toLocaleTimeString([], {
                        hour: "2-digit",
                        minute: "2-digit",
                      })}
                    </p>
                  </div>
                </div>
              ))}

              {/* Typing indicator */}
              {isTyping && (
                <div className="flex justify-start">
                  <div className="rounded-xl border border-gray-200 bg-gray-50 px-4 py-3">
                    <div className="flex items-center gap-1.5">
                      <svg className="h-3.5 w-3.5 text-brain" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" d="M9.813 15.904L9 18.75l-.813-2.846a4.5 4.5 0 00-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 003.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 003.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 00-3.09 3.09z" />
                      </svg>
                      <span className="text-xs font-medium text-brain">Standards Brain</span>
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
                  ref={inputRef}
                  type="text"
                  value={input}
                  onChange={(e) => setInput(e.target.value)}
                  placeholder="Ask about any standard, guidance, or tool..."
                  disabled={isTyping}
                  className="flex-1 rounded-lg border border-gray-300 px-4 py-2.5 text-sm text-gray-900 placeholder-gray-400 focus:border-brain focus:outline-none focus:ring-1 focus:ring-brain disabled:opacity-50"
                />
                <button
                  type="submit"
                  disabled={!input.trim() || isTyping}
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
            In a production deployment, the Standards Brain would use Retrieval-Augmented
            Generation (RAG) to provide grounded, accurate answers about any standard
            in the repository.
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
                All guidance documents, specifications, profiles, tools, and
                ontologies are processed and chunked into a vector database with
                semantic embeddings.
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
                When you ask a question, semantic search finds the most relevant
                passages from across all tiers. Cross-references and relationships
                are resolved automatically.
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
                retrieved content, with inline citations and links back to the
                source artifacts in the repository.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
