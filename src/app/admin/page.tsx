"use client";

import { useEffect, useState } from "react";

interface Stats {
  sources: { total: number; active: number; pending: number; error: number };
  chunks: number;
  users: number;
}

interface StardogStats {
  connected: boolean;
  triples: number;
  entities: number;
  sources: number;
  relationships: number;
  error?: string;
}

export default function AdminDashboard() {
  const [stats, setStats] = useState<Stats | null>(null);
  const [stardogStats, setStardogStats] = useState<StardogStats | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all([
      fetch("/api/admin/stats").then((r) => r.json()),
      fetch("/api/admin/stardog").then((r) => r.json()).catch(() => null),
    ])
      .then(([s, sd]) => {
        setStats(s);
        setStardogStats(sd);
      })
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  if (loading) {
    return (
      <div className="flex items-center justify-center py-20 text-gray-400">
        Loading stats...
      </div>
    );
  }

  const cards = [
    {
      label: "Total Sources",
      value: stats?.sources.total ?? 0,
      color: "bg-blue-500",
    },
    {
      label: "Active Sources",
      value: stats?.sources.active ?? 0,
      color: "bg-green-500",
    },
    {
      label: "Total Chunks",
      value: stats?.chunks ?? 0,
      color: "bg-indigo-500",
    },
    {
      label: "Users",
      value: stats?.users ?? 0,
      color: "bg-amber-500",
    },
  ];

  return (
    <div>
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {cards.map((card) => (
          <div
            key={card.label}
            className="rounded-lg border border-gray-200 bg-white p-5 shadow-sm"
          >
            <div className="flex items-center gap-3">
              <div className={`h-3 w-3 rounded-full ${card.color}`} />
              <p className="text-sm text-gray-500">{card.label}</p>
            </div>
            <p className="mt-2 text-3xl font-bold text-daf-dark-gray">
              {card.value.toLocaleString()}
            </p>
          </div>
        ))}
      </div>

      {stats?.sources.error ? (
        <div className="mt-6 rounded-lg border border-red-200 bg-red-50 p-4">
          <p className="text-sm font-medium text-red-800">
            {stats.sources.error} source{stats.sources.error !== 1 ? "s" : ""}{" "}
            with errors
          </p>
          <p className="mt-1 text-sm text-red-600">
            Check the Sources tab for details.
          </p>
        </div>
      ) : null}

      {/* Stardog Integration Status */}
      <div className="mt-8">
        <h2 className="text-lg font-semibold text-daf-dark-gray mb-4">
          Stardog Cloud Integration
        </h2>
        {stardogStats ? (
          <div className="rounded-lg border border-gray-200 bg-white p-5 shadow-sm">
            <div className="flex items-center gap-2 mb-4">
              <span
                className={`h-3 w-3 rounded-full ${
                  stardogStats.connected ? "bg-green-500" : "bg-red-500"
                }`}
              />
              <span className="text-sm font-medium text-gray-700">
                {stardogStats.connected ? "Connected" : "Disconnected"}
              </span>
              {stardogStats.error && (
                <span className="text-sm text-red-500 ml-2">
                  {stardogStats.error}
                </span>
              )}
            </div>
            {stardogStats.connected && (
              <div className="grid gap-4 sm:grid-cols-4">
                <div>
                  <p className="text-xs text-gray-500">Total Triples</p>
                  <p className="text-xl font-bold text-daf-dark-gray">
                    {stardogStats.triples.toLocaleString()}
                  </p>
                </div>
                <div>
                  <p className="text-xs text-gray-500">Entities</p>
                  <p className="text-xl font-bold text-daf-dark-gray">
                    {stardogStats.entities.toLocaleString()}
                  </p>
                </div>
                <div>
                  <p className="text-xs text-gray-500">Sources</p>
                  <p className="text-xl font-bold text-daf-dark-gray">
                    {stardogStats.sources.toLocaleString()}
                  </p>
                </div>
                <div>
                  <p className="text-xs text-gray-500">Relationships</p>
                  <p className="text-xl font-bold text-daf-dark-gray">
                    {stardogStats.relationships.toLocaleString()}
                  </p>
                </div>
              </div>
            )}
          </div>
        ) : (
          <div className="rounded-lg border border-gray-200 bg-gray-50 p-5 text-sm text-gray-400">
            Stardog status unavailable
          </div>
        )}
      </div>
    </div>
  );
}
