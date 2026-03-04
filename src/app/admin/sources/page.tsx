"use client";

import { useEffect, useState, useRef, useCallback } from "react";

async function extractPdfTextClientSide(arrayBuffer: ArrayBuffer): Promise<string> {
  const pdfjsLib = await import("pdfjs-dist");
  const pdfjsVersion = pdfjsLib.version;
  pdfjsLib.GlobalWorkerOptions.workerSrc = `https://cdnjs.cloudflare.com/ajax/libs/pdf.js/${pdfjsVersion}/pdf.worker.min.mjs`;

  const pdf = await pdfjsLib.getDocument({ data: arrayBuffer }).promise;
  const pages: string[] = [];
  for (let i = 1; i <= pdf.numPages; i++) {
    const page = await pdf.getPage(i);
    const content = await page.getTextContent();
    const text = content.items
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      .map((item: any) => item.str || "")
      .join(" ");
    pages.push(text);
  }
  return pages.join("\n\n");
}

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

interface UploadFileEntry {
  id: string;
  name: string;
  size: number;
  status: "queued" | "extracting" | "uploading" | "success" | "error" | "cancelled";
  error?: string;
  chunkCount?: number;
}

const TIER_OPTIONS = [
  { value: "", label: "None" },
  { value: "1", label: "Tier 1 \u2014 Guidance" },
  { value: "2a", label: "Tier 2A \u2014 Specs" },
  { value: "2b", label: "Tier 2B \u2014 Profiles" },
  { value: "3", label: "Tier 3 \u2014 Tools" },
  { value: "ontology", label: "Ontology" },
];

const TYPE_OPTIONS = [
  { value: "webpage", label: "Webpage" },
  { value: "spec", label: "Specification" },
  { value: "guidance", label: "Guidance Document" },
  { value: "profile", label: "Domain Profile" },
  { value: "tool", label: "Tool Documentation" },
  { value: "document", label: "Uploaded Document" },
];

export default function SourcesPage() {
  const [sources, setSources] = useState<Source[]>([]);
  const [loading, setLoading] = useState(true);
  const [showIngest, setShowIngest] = useState(false);
  const [showUpload, setShowUpload] = useState(false);
  const [ingestUrl, setIngestUrl] = useState("");
  const [ingestTier, setIngestTier] = useState("");
  const [ingestType, setIngestType] = useState("webpage");
  const [ingesting, setIngesting] = useState(false);
  const [ingestResult, setIngestResult] = useState<string | null>(null);

  // File upload state
  const [uploadTier, setUploadTier] = useState("");
  const [uploadType, setUploadType] = useState("document");
  const [dragOver, setDragOver] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [uploadQueue, setUploadQueue] = useState<UploadFileEntry[]>([]);
  const [showUploadPanel, setShowUploadPanel] = useState(false);
  const cancelRef = useRef(false);
  const isUploading = uploadQueue.some(
    (e) => e.status === "extracting" || e.status === "uploading" || e.status === "queued"
  );

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
          `Ingested "${result.title}" \u2014 ${result.chunkCount} chunks`
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

  const updateEntry = useCallback((id: string, updates: Partial<UploadFileEntry>) => {
    setUploadQueue((prev) => prev.map((e) => (e.id === id ? { ...e, ...updates } : e)));
  }, []);

  const handleFiles = useCallback(async (files: File[]) => {
    const MAX_UPLOAD_SIZE = 4.5 * 1024 * 1024;
    cancelRef.current = false;

    const entries: UploadFileEntry[] = files.map((f) => ({
      id: crypto.randomUUID(),
      name: f.name,
      size: f.size,
      status: "queued" as const,
    }));
    setUploadQueue(entries);
    setShowUploadPanel(true);

    for (let idx = 0; idx < files.length; idx++) {
      const file = files[idx];
      const entry = entries[idx];

      if (cancelRef.current) {
        for (let j = idx; j < files.length; j++) {
          updateEntry(entries[j].id, { status: "cancelled" });
        }
        break;
      }

      try {
        let uploadFile: File | Blob = file;
        let uploadName = file.name;
        const isPdf = file.name.toLowerCase().endsWith(".pdf");

        if (isPdf && file.size > MAX_UPLOAD_SIZE) {
          updateEntry(entry.id, { status: "extracting" });
          const arrayBuffer = await file.arrayBuffer();
          if (cancelRef.current) { updateEntry(entry.id, { status: "cancelled" }); continue; }
          const text = await extractPdfTextClientSide(arrayBuffer);
          if (!text || text.trim().length < 50) {
            updateEntry(entry.id, { status: "error", error: "No readable text extracted" });
            continue;
          }
          uploadFile = new Blob([text], { type: "text/plain" });
          uploadName = file.name.replace(/\.pdf$/i, ".txt");
        } else if (file.size > MAX_UPLOAD_SIZE) {
          updateEntry(entry.id, {
            status: "error",
            error: `${(file.size / (1024 * 1024)).toFixed(1)} MB exceeds 4.5 MB limit`,
          });
          continue;
        }

        if (cancelRef.current) { updateEntry(entry.id, { status: "cancelled" }); continue; }
        updateEntry(entry.id, { status: "uploading" });

        const formData = new FormData();
        formData.append("file", uploadFile, uploadName);
        if (isPdf && uploadName !== file.name) {
          formData.append("title", file.name.replace(/\.pdf$/i, ""));
        }
        if (uploadTier) formData.append("tier", uploadTier);
        formData.append("source_type", uploadType);

        const res = await fetch("/api/ingest/upload", { method: "POST", body: formData });

        if (!res.ok) {
          const text = await res.text();
          updateEntry(entry.id, {
            status: "error",
            error: res.status === 413 ? "Too large for server" : text || res.statusText,
          });
          continue;
        }

        const result = await res.json();
        if (result.status === "success") {
          updateEntry(entry.id, { status: "success", chunkCount: result.chunkCount });
        } else {
          updateEntry(entry.id, { status: "error", error: result.error });
        }
      } catch (err) {
        updateEntry(entry.id, { status: "error", error: String(err) });
      }
    }

    loadSources();
  }, [uploadTier, uploadType, updateEntry]);

  function handleDrop(e: React.DragEvent) {
    e.preventDefault();
    setDragOver(false);
    const files = Array.from(e.dataTransfer.files);
    if (files.length > 0) handleFiles(files);
  }

  function handleDragOver(e: React.DragEvent) {
    e.preventDefault();
    setDragOver(true);
  }

  function handleDragLeave(e: React.DragEvent) {
    e.preventDefault();
    setDragOver(false);
  }

  function handleFileSelect(e: React.ChangeEvent<HTMLInputElement>) {
    const files = Array.from(e.target.files || []);
    if (files.length > 0) handleFiles(files);
    if (fileInputRef.current) fileInputRef.current.value = "";
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
      {/* Add Source by URL */}
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
                  {TIER_OPTIONS.map((o) => (
                    <option key={o.value} value={o.value}>{o.label}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">Type</label>
                <select
                  value={ingestType}
                  onChange={(e) => setIngestType(e.target.value)}
                  className="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-daf-blue focus:outline-none focus:ring-1 focus:ring-daf-blue"
                >
                  {TYPE_OPTIONS.map((o) => (
                    <option key={o.value} value={o.value}>{o.label}</option>
                  ))}
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

      {/* Upload Document */}
      <div className="rounded-lg border border-gray-200 bg-white shadow-sm">
        <button
          onClick={() => setShowUpload(!showUpload)}
          className="flex w-full items-center justify-between p-4 text-left"
        >
          <span className="font-medium text-daf-dark-gray">
            Upload Document
          </span>
          <svg
            className={`h-5 w-5 text-gray-400 transition ${showUpload ? "rotate-180" : ""}`}
            fill="none"
            viewBox="0 0 24 24"
            strokeWidth={2}
            stroke="currentColor"
          >
            <path strokeLinecap="round" strokeLinejoin="round" d="M19.5 8.25l-7.5 7.5-7.5-7.5" />
          </svg>
        </button>

        {showUpload && (
          <div className="border-t border-gray-200 p-4 space-y-3">
            <div className="grid gap-3 sm:grid-cols-2">
              <div>
                <label className="block text-sm font-medium text-gray-700">Tier</label>
                <select
                  value={uploadTier}
                  onChange={(e) => setUploadTier(e.target.value)}
                  className="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-daf-blue focus:outline-none focus:ring-1 focus:ring-daf-blue"
                >
                  {TIER_OPTIONS.map((o) => (
                    <option key={o.value} value={o.value}>{o.label}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">Type</label>
                <select
                  value={uploadType}
                  onChange={(e) => setUploadType(e.target.value)}
                  className="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-daf-blue focus:outline-none focus:ring-1 focus:ring-daf-blue"
                >
                  {TYPE_OPTIONS.map((o) => (
                    <option key={o.value} value={o.value}>{o.label}</option>
                  ))}
                </select>
              </div>
            </div>

            {/* Drop zone */}
            <div
              onDrop={handleDrop}
              onDragOver={handleDragOver}
              onDragLeave={handleDragLeave}
              onClick={() => !isUploading && fileInputRef.current?.click()}
              className={`relative flex flex-col items-center justify-center rounded-lg border-2 border-dashed p-8 cursor-pointer transition ${
                dragOver
                  ? "border-daf-blue bg-blue-50"
                  : "border-gray-300 hover:border-gray-400 hover:bg-gray-50"
              } ${isUploading ? "pointer-events-none opacity-60" : ""}`}
            >
              <input
                ref={fileInputRef}
                type="file"
                accept=".pdf,.txt,.md,.csv,.xml,.xsd,.sch,.json"
                multiple
                onChange={handleFileSelect}
                className="hidden"
              />
              <svg className="h-10 w-10 text-gray-400 mb-3" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M3 16.5v2.25A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75V16.5m-13.5-9L12 3m0 0l4.5 4.5M12 3v13.5" />
              </svg>
              <p className="text-sm font-medium text-gray-700">
                Drop files here or click to browse
              </p>
              <p className="mt-1 text-xs text-gray-500">
                PDF (any size), TXT, MD, CSV, XML, XSD, JSON
              </p>
            </div>

            {/* Upload queue panel */}
            {showUploadPanel && uploadQueue.length > 0 && (
              <div className="rounded-lg border border-gray-200 bg-gray-50 overflow-hidden">
                {/* Panel header */}
                <div className="flex items-center justify-between px-4 py-2.5 bg-gray-100 border-b border-gray-200">
                  <span className="text-sm font-medium text-gray-700">
                    Upload Progress
                  </span>
                  <div className="flex items-center gap-2">
                    {isUploading && (
                      <button
                        onClick={() => { cancelRef.current = true; }}
                        className="rounded px-2.5 py-1 text-xs font-medium text-red-600 hover:bg-red-50 border border-red-200"
                      >
                        Cancel
                      </button>
                    )}
                    <button
                      onClick={() => { setShowUploadPanel(false); setUploadQueue([]); }}
                      className="rounded p-1 text-gray-400 hover:text-gray-600 hover:bg-gray-200"
                      title="Close"
                    >
                      <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
                      </svg>
                    </button>
                  </div>
                </div>
                {/* File list */}
                <ul className="divide-y divide-gray-200">
                  {uploadQueue.map((entry) => (
                    <li key={entry.id} className="flex items-center gap-3 px-4 py-2.5">
                      {/* Status icon */}
                      <span className="flex-shrink-0 w-5 text-center">
                        {entry.status === "queued" && (
                          <span className="inline-block h-2.5 w-2.5 rounded-full bg-gray-300" />
                        )}
                        {(entry.status === "extracting" || entry.status === "uploading") && (
                          <svg className="h-4 w-4 animate-spin text-daf-blue" fill="none" viewBox="0 0 24 24">
                            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                            <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                          </svg>
                        )}
                        {entry.status === "success" && (
                          <svg className="h-4 w-4 text-green-500" fill="none" viewBox="0 0 24 24" strokeWidth={2.5} stroke="currentColor">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M4.5 12.75l6 6 9-13.5" />
                          </svg>
                        )}
                        {entry.status === "error" && (
                          <svg className="h-4 w-4 text-red-500" fill="none" viewBox="0 0 24 24" strokeWidth={2.5} stroke="currentColor">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
                          </svg>
                        )}
                        {entry.status === "cancelled" && (
                          <svg className="h-4 w-4 text-gray-400" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" />
                          </svg>
                        )}
                      </span>
                      {/* Filename */}
                      <span className="flex-1 min-w-0 text-sm text-gray-800 truncate" title={entry.name}>
                        {entry.name}
                      </span>
                      {/* Status text */}
                      <span className={`flex-shrink-0 text-xs font-medium ${
                        entry.status === "success" ? "text-green-600" :
                        entry.status === "error" ? "text-red-600" :
                        entry.status === "extracting" || entry.status === "uploading" ? "text-daf-blue" :
                        "text-gray-400"
                      }`}>
                        {entry.status === "queued" && "Queued"}
                        {entry.status === "extracting" && "Extracting text..."}
                        {entry.status === "uploading" && "Uploading..."}
                        {entry.status === "success" && `Success \u00B7 ${entry.chunkCount} chunks`}
                        {entry.status === "cancelled" && "Cancelled"}
                      </span>
                      {/* Error on its own line */}
                      {entry.status === "error" && entry.error && (
                        <span className="flex-shrink-0 text-xs text-red-600 max-w-[260px] truncate" title={entry.error}>
                          {entry.error}
                        </span>
                      )}
                    </li>
                  ))}
                </ul>
              </div>
            )}
          </div>
        )}
      </div>

      {/* Sources Table */}
      <div className="rounded-lg border border-gray-200 bg-white shadow-sm overflow-hidden">
        {loading ? (
          <div className="p-8 text-center text-gray-400">Loading sources...</div>
        ) : sources.length === 0 ? (
          <div className="p-8 text-center text-gray-400">
            No sources yet. Add one using the forms above.
          </div>
        ) : (
          <div className="overflow-x-auto">
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
                      <div className="hidden sm:block text-xs text-gray-400 truncate max-w-xs">
                        {source.url}
                      </div>
                      {source.error_message && (
                        <div className="mt-1 text-xs text-red-500 truncate max-w-xs">
                          {source.error_message}
                        </div>
                      )}
                    </td>
                    <td className="px-4 py-3 text-gray-500 whitespace-nowrap">
                      {source.tier || "\u2014"}
                    </td>
                    <td className="px-4 py-3">
                      <span
                        className={`rounded-full px-2 py-0.5 text-xs font-medium whitespace-nowrap ${statusColors[source.status] || "bg-gray-100 text-gray-600"}`}
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
                        className="text-xs text-red-500 hover:text-red-700 whitespace-nowrap"
                      >
                        Delete
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
