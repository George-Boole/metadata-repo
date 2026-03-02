"use client";

import { useEffect, useState } from "react";

interface ModelConfig {
  label: string;
  model_id: string;
  provider: string;
}

export default function SettingsPage() {
  const [activeModel, setActiveModel] = useState("");
  const [models, setModels] = useState<Record<string, ModelConfig>>({});
  const [systemPrompt, setSystemPrompt] = useState("");
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState<string | null>(null);

  useEffect(() => {
    fetch("/api/admin/settings")
      .then((r) => r.json())
      .then((data) => {
        setActiveModel(data.active_model || "");
        setModels(data.models || {});
        setSystemPrompt(data.system_prompt || "");
      })
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  async function handleSave() {
    setSaving(true);
    setMessage(null);

    try {
      const res = await fetch("/api/admin/settings", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          active_model: activeModel,
          system_prompt: systemPrompt,
        }),
      });

      if (res.ok) {
        setMessage("Settings saved");
      } else {
        const data = await res.json();
        setMessage(`Error: ${data.error}`);
      }
    } catch (err) {
      setMessage(`Error: ${err}`);
    } finally {
      setSaving(false);
    }
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center py-20 text-gray-400">
        Loading settings...
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Model Selector */}
      <div className="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
        <h2 className="mb-4 text-lg font-semibold text-daf-dark-gray">
          AI Model
        </h2>
        <p className="mb-3 text-sm text-gray-500">
          Select which LLM powers the Standards Brain chat.
        </p>
        <div className="grid gap-3 sm:grid-cols-3">
          {Object.entries(models).map(([key, config]) => (
            <button
              key={key}
              onClick={() => setActiveModel(key)}
              className={`rounded-lg border p-4 text-left transition ${
                activeModel === key
                  ? "border-daf-navy bg-daf-navy/5 ring-1 ring-daf-navy"
                  : "border-gray-200 hover:border-gray-300"
              }`}
            >
              <p className="font-medium text-daf-dark-gray">{config.label}</p>
              <p className="mt-1 text-xs text-gray-400">
                {config.provider} / {config.model_id}
              </p>
            </button>
          ))}
        </div>
      </div>

      {/* System Prompt */}
      <div className="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
        <h2 className="mb-4 text-lg font-semibold text-daf-dark-gray">
          System Prompt
        </h2>
        <p className="mb-3 text-sm text-gray-500">
          Instructions given to the LLM before each conversation. Controls tone,
          citation format, and behavior.
        </p>
        <textarea
          value={systemPrompt}
          onChange={(e) => setSystemPrompt(e.target.value)}
          rows={6}
          className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm font-mono focus:border-daf-blue focus:outline-none focus:ring-1 focus:ring-daf-blue"
        />
      </div>

      {/* Save */}
      <div className="flex items-center gap-3">
        <button
          onClick={handleSave}
          disabled={saving}
          className="rounded-lg bg-daf-navy px-6 py-2.5 text-sm font-medium text-white hover:bg-daf-blue disabled:opacity-50"
        >
          {saving ? "Saving..." : "Save Settings"}
        </button>
        {message && (
          <p
            className={`text-sm ${message.startsWith("Error") ? "text-red-600" : "text-green-600"}`}
          >
            {message}
          </p>
        )}
      </div>
    </div>
  );
}
