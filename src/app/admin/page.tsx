"use client";

import { useEffect, useState } from "react";

interface Stats {
  sources: { total: number; active: number; pending: number; error: number };
  chunks: number;
  users: number;
}

export default function AdminDashboard() {
  const [stats, setStats] = useState<Stats | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch("/api/admin/stats")
      .then((r) => r.json())
      .then(setStats)
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
    </div>
  );
}
