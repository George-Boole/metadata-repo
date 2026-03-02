"use client";

import { useEffect, useState } from "react";

interface Source {
  id: string;
  url: string;
  title: string;
  source_type: string;
  tier: string | null;
  status: string;
  chunk_count: number;
  error_message: string | null;
  created_at: string;
}

export default function SourcesPage() {
  const [sources, setSources] = useState<Source[]>([]);
  const [loading, setLoading] = useState(true);
  const [showIngest, setShowIngest] = useState(false);
  const [ingestUrl, setIngestUrl] = useState("");
  const [ingestTier, setIngestTier] = useState("");
  const [ingestType, setIngestType] = useState("webpage");
  const [ingesting, setIngesting] = useState(false);
  const [ingestResult, setIngestResult] = useState<string | null>(null);

  async function loadSources() {
    const res = await fetch("/api/admin/sources");
    const data = await res.json();
    setSources(data.sources || []);
    setLoading(false);
  }

  useEffect(() => {
    loadSources();
  }, []);

  async function handleIngest(e: React.FormEvent) {
    e.preventDefault();
    setIngesting(true);
    setIngestResult(null);

    try {
      const res = await fetch("/api/ingest", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          url: ingestUrl,
          tier: ingestTier || undefined,
          source_type: ingestType,
        }),
      });

      const result = await res.json();
      if (result.status === "success") {
        setIngestResult(
          `Ingested "${result.title}" — ${result.chunkCount} chunks`
        );
        setIngestUrl("");
        loadSources();
      } else {
        setIngestResult(`Error: ${result.error}`);
      }
    } catch (err) {
      setIngestResult(`Error: ${err}`);
    } finally {
      setIngesting(false);
    }
  }

  async function handleDelete(id: string) {
    const res = await fetch(`/api/admin/sources/${id}`, { method: "DELETE" });
    if (res.ok) loadSources();
  }

  const statusColors: Record<string, string> = {
    active: "bg-green-100 text-green-700",
    pending: "bg-yellow-100 text-yellow-700",
    error: "bg-red-100 text-red-700",
  };

  return (
    <div className="space-y-6">
      {/* Add Source */}
      <div className="rounded-lg border border-gray-200 bg-white shadow-sm">
        <button
          onClick={() => setShowIngest(!showIngest)}
          className="flex w-full items-center justify-between p-4 text-left"
        >
          <span className="font-medium text-daf-dark-gray">
            Add Source by URL
          </span>
          <svg
            className={`h-5 w-5 text-gray-400 transition ${showIngest ? "rotate-180" : ""}`}
            fill="none"
            viewBox="0 0 24 24"
            strokeWidth={2}
            stroke="currentColor"
          >
            <path strokeLinecap="round" strokeLinejoin="round" d="M19.5 8.25l-7.5 7.5-7.5-7.5" />
          </svg>
        </button>

        {showIngest && (
          <form onSubmit={handleIngest} className="border-t border-gray-200 p-4 space-y-3">
            <div>
              <label className="block text-sm font-medium text-gray-700">URL</label>
              <input
                type="url"
                value={ingestUrl}
                onChange={(e) => setIngestUrl(e.target.value)}
                placeholder="https://example.com/spec-page"
                required
                className="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-daf-blue focus:outline-none focus:ring-1 focus:ring-daf-blue"
              />
            </div>
            <div className="grid gap-3 sm:grid-cols-2">
              <div>
                <label className="block text-sm font-medium text-gray-700">Tier</label>
                <select
                  value={ingestTier}
                  onChange={(e) => setIngestTier(e.target.value)}
                  className="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-daf-blue focus:outline-none focus:ring-1 focus:ring-daf-blue"
                >
                  <option value="">None</option>
                  <option value="tier-1">Tier 1 — Guidance</option>
                  <option value="tier-2a">Tier 2A — Specs</option>
                  <option value="tier-2b">Tier 2B — Profiles</option>
                  <option value="tier-3">Tier 3 — Tools</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">Type</label>
                <select
                  value={ingestType}
                  onChange={(e) => setIngestType(e.target.value)}
                  className="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-daf-blue focus:outline-none focus:ring-1 focus:ring-daf-blue"
                >
                  <option value="webpage">Webpage</option>
                  <option value="spec">Specification</option>
                  <option value="guidance">Guidance Document</option>
                  <option value="profile">Domain Profile</option>
                  <option value="tool">Tool Documentation</option>
                </select>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <button
                type="submit"
                disabled={ingesting || !ingestUrl}
                className="rounded-lg bg-daf-navy px-4 py-2 text-sm font-medium text-white hover:bg-daf-blue disabled:opacity-50"
              >
                {ingesting ? "Ingesting..." : "Ingest URL"}
              </button>
              {ingestResult && (
                <p
                  className={`text-sm ${ingestResult.startsWith("Error") ? "text-red-600" : "text-green-600"}`}
                >
                  {ingestResult}
                </p>
              )}
            </div>
          </form>
        )}
      </div>

      {/* Sources Table */}
      <div className="rounded-lg border border-gray-200 bg-white shadow-sm overflow-hidden">
        {loading ? (
          <div className="p-8 text-center text-gray-400">Loading sources...</div>
        ) : sources.length === 0 ? (
          <div className="p-8 text-center text-gray-400">
            No sources yet. Add one using the form above.
          </div>
        ) : (
          <table className="w-full text-sm">
            <thead className="bg-gray-50 text-left text-xs font-medium uppercase text-gray-500">
              <tr>
                <th className="px-4 py-3">Title</th>
                <th className="px-4 py-3">Tier</th>
                <th className="px-4 py-3">Status</th>
                <th className="px-4 py-3 text-right">Chunks</th>
                <th className="px-4 py-3" />
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {sources.map((source) => (
                <tr key={source.id} className="hover:bg-gray-50">
                  <td className="px-4 py-3">
                    <div className="font-medium text-daf-dark-gray">
                      {source.title}
                    </div>
                    <div className="text-xs text-gray-400 truncate max-w-xs">
                      {source.url}
                    </div>
                    {source.error_message && (
                      <div className="mt-1 text-xs text-red-500 truncate max-w-xs">
                        {source.error_message}
                      </div>
                    )}
                  </td>
                  <td className="px-4 py-3 text-gray-500">
                    {source.tier || "—"}
                  </td>
                  <td className="px-4 py-3">
                    <span
                      className={`rounded-full px-2 py-0.5 text-xs font-medium ${statusColors[source.status] || "bg-gray-100 text-gray-600"}`}
                    >
                      {source.status}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-right text-gray-500">
                    {source.chunk_count}
                  </td>
                  <td className="px-4 py-3 text-right">
                    <button
                      onClick={() => handleDelete(source.id)}
                      className="text-xs text-red-500 hover:text-red-700"
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}
