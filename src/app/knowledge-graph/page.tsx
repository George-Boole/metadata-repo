"use client";

import { useEffect, useState } from "react";

interface StardogStats {
  connected: boolean;
  triples: number;
  entities: number;
  sources: number;
  relationships: number;
  error?: string;
}

interface Neo4jStats {
  entities: number;
  sources: number;
  relatesToCount: number;
  mentionsCount: number;
}

interface QueryResult {
  results: Record<string, string>[];
}

const EXAMPLE_QUERIES = [
  {
    label: "All entity types",
    sparql: `SELECT DISTINCT ?type (COUNT(?e) AS ?count) WHERE {
  ?e a ?type .
  FILTER(STRSTARTS(STR(?type), "https://daf-metadata.mil/ontology/"))
} GROUP BY ?type ORDER BY DESC(?count)`,
  },
  {
    label: "Top 20 entities with most aliases",
    sparql: `SELECT ?name (COUNT(?alias) AS ?aliasCount) WHERE {
  ?e <http://www.w3.org/2004/02/skos/core#prefLabel> ?name .
  ?e <http://www.w3.org/2004/02/skos/core#altLabel> ?alias .
} GROUP BY ?name ORDER BY DESC(?aliasCount) LIMIT 20`,
  },
  {
    label: "All relationship types",
    sparql: `SELECT ?relType (COUNT(*) AS ?count) WHERE {
  ?from ?rel ?to .
  FILTER(STRSTARTS(STR(?rel), "https://daf-metadata.mil/ontology/rel/"))
  BIND(REPLACE(STR(?rel), "https://daf-metadata.mil/ontology/rel/", "") AS ?relType)
} GROUP BY ?relType ORDER BY DESC(?count)`,
  },
  {
    label: "Sources with most entity references",
    sparql: `SELECT ?title (COUNT(?entity) AS ?refs) WHERE {
  ?source a <https://daf-metadata.mil/ontology/Source> .
  ?source <https://daf-metadata.mil/ontology/title> ?title .
  ?source <http://purl.org/dc/terms/references> ?entity .
} GROUP BY ?title ORDER BY DESC(?refs) LIMIT 20`,
  },
];

export default function KnowledgeGraphPage() {
  const [activeTab, setActiveTab] = useState<"comparison" | "sparql" | "neo4j">("comparison");
  const [stardogStats, setStardogStats] = useState<StardogStats | null>(null);
  const [neo4jStats, setNeo4jStats] = useState<Neo4jStats | null>(null);
  const [loading, setLoading] = useState(true);

  // SPARQL tab state
  const [sparql, setSparql] = useState(EXAMPLE_QUERIES[0].sparql);
  const [queryResults, setQueryResults] = useState<QueryResult | null>(null);
  const [queryLoading, setQueryLoading] = useState(false);
  const [queryError, setQueryError] = useState<string | null>(null);

  useEffect(() => {
    Promise.all([
      fetch("/api/admin/stardog").then((r) => r.json()),
      fetch("/api/setup/neo4j").then((r) => r.json()).catch(() => null),
    ])
      .then(([sd, neo]) => {
        setStardogStats(sd);
        if (neo) {
          setNeo4jStats({
            entities: neo.entities ?? 0,
            sources: neo.sources ?? 0,
            relatesToCount: neo.relatesToCount ?? 0,
            mentionsCount: neo.mentionsCount ?? 0,
          });
        }
      })
      .finally(() => setLoading(false));
  }, []);

  async function runQuery() {
    setQueryLoading(true);
    setQueryError(null);
    try {
      const res = await fetch("/api/admin/stardog/query", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ sparql }),
      });
      if (!res.ok) {
        const err = await res.json();
        setQueryError(err.error || "Query failed");
        return;
      }
      const data = await res.json();
      setQueryResults(data);
    } catch {
      setQueryError("Failed to execute query");
    } finally {
      setQueryLoading(false);
    }
  }

  const tabs = [
    { id: "comparison" as const, label: "Platform Comparison" },
    { id: "sparql" as const, label: "SPARQL Explorer" },
    { id: "neo4j" as const, label: "Neo4j Stats" },
  ];

  return (
    <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-daf-dark-gray">
          Knowledge Graph Explorer
        </h1>
        <p className="mt-2 text-gray-600">
          Compare graph backends: Neo4j AuraDB (current) vs Stardog Cloud (evaluation)
        </p>
      </div>

      {/* Tabs */}
      <div className="mb-6 border-b border-gray-200">
        <div className="flex gap-4">
          {tabs.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`pb-3 text-sm font-medium transition-colors ${
                activeTab === tab.id
                  ? "border-b-2 border-blue-600 text-blue-600"
                  : "text-gray-500 hover:text-gray-700"
              }`}
            >
              {tab.label}
            </button>
          ))}
        </div>
      </div>

      {loading ? (
        <div className="flex items-center justify-center py-20 text-gray-400">
          Loading graph statistics...
        </div>
      ) : (
        <>
          {/* Comparison Tab */}
          {activeTab === "comparison" && (
            <ComparisonTab stardogStats={stardogStats} neo4jStats={neo4jStats} />
          )}

          {/* SPARQL Explorer Tab */}
          {activeTab === "sparql" && (
            <SparqlTab
              sparql={sparql}
              setSparql={setSparql}
              queryResults={queryResults}
              queryLoading={queryLoading}
              queryError={queryError}
              runQuery={runQuery}
            />
          )}

          {/* Neo4j Tab */}
          {activeTab === "neo4j" && (
            <Neo4jTab stats={neo4jStats} />
          )}
        </>
      )}
    </div>
  );
}

function ComparisonTab({
  stardogStats,
  neo4jStats,
}: {
  stardogStats: StardogStats | null;
  neo4jStats: Neo4jStats | null;
}) {
  const rows = [
    {
      metric: "Connection Status",
      neo4j: neo4jStats ? "Connected" : "Unavailable",
      stardog: stardogStats?.connected ? "Connected" : "Unavailable",
    },
    {
      metric: "Platform",
      neo4j: "Neo4j AuraDB Free",
      stardog: "Stardog Cloud Free",
    },
    {
      metric: "Query Language",
      neo4j: "Cypher",
      stardog: "SPARQL 1.1",
    },
    {
      metric: "Data Model",
      neo4j: "Labeled Property Graph",
      stardog: "RDF / OWL",
    },
    {
      metric: "Entities",
      neo4j: neo4jStats?.entities.toLocaleString() ?? "—",
      stardog: stardogStats?.entities.toLocaleString() ?? "—",
    },
    {
      metric: "Sources",
      neo4j: neo4jStats?.sources.toLocaleString() ?? "—",
      stardog: stardogStats?.sources.toLocaleString() ?? "—",
    },
    {
      metric: "Relationships",
      neo4j: neo4jStats
        ? (neo4jStats.relatesToCount + neo4jStats.mentionsCount).toLocaleString()
        : "—",
      stardog: stardogStats?.relationships.toLocaleString() ?? "—",
    },
    {
      metric: "Total Triples / Edges",
      neo4j: neo4jStats
        ? (neo4jStats.relatesToCount + neo4jStats.mentionsCount).toLocaleString()
        : "—",
      stardog: stardogStats?.triples.toLocaleString() ?? "—",
    },
    {
      metric: "Standards Support",
      neo4j: "Custom schema",
      stardog: "W3C RDF/OWL/SKOS",
    },
    {
      metric: "Inference / Reasoning",
      neo4j: "None (manual traversal)",
      stardog: "OWL 2 RL reasoning engine",
    },
    {
      metric: "Free Tier Limits",
      neo4j: "50K nodes / 175K rels",
      stardog: "25 queries/hour, 10K triples",
    },
  ];

  return (
    <div>
      <div className="rounded-lg border border-gray-200 overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                Metric
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                <div className="flex items-center gap-2">
                  <span className="h-2.5 w-2.5 rounded-full bg-green-500" />
                  Neo4j AuraDB
                </div>
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                <div className="flex items-center gap-2">
                  <span className="h-2.5 w-2.5 rounded-full bg-blue-500" />
                  Stardog Cloud
                </div>
              </th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-200 bg-white">
            {rows.map((row) => (
              <tr key={row.metric}>
                <td className="px-6 py-3 text-sm font-medium text-gray-900">
                  {row.metric}
                </td>
                <td className="px-6 py-3 text-sm text-gray-600">{row.neo4j}</td>
                <td className="px-6 py-3 text-sm text-gray-600">{row.stardog}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <div className="mt-6 grid gap-4 sm:grid-cols-2">
        <div className="rounded-lg border border-green-200 bg-green-50 p-5">
          <h3 className="text-sm font-semibold text-green-800">Neo4j Strengths</h3>
          <ul className="mt-2 space-y-1 text-sm text-green-700">
            <li>Intuitive Cypher query language</li>
            <li>Fast traversal for relationship-heavy queries</li>
            <li>Rich visualization ecosystem</li>
            <li>Generous free tier (50K nodes)</li>
          </ul>
        </div>
        <div className="rounded-lg border border-blue-200 bg-blue-50 p-5">
          <h3 className="text-sm font-semibold text-blue-800">Stardog Strengths</h3>
          <ul className="mt-2 space-y-1 text-sm text-blue-700">
            <li>W3C standards (RDF/OWL/SPARQL)</li>
            <li>Built-in OWL 2 reasoning engine</li>
            <li>Enterprise knowledge graph features</li>
            <li>Virtual graph / data fabric capabilities</li>
          </ul>
        </div>
      </div>
    </div>
  );
}

function SparqlTab({
  sparql,
  setSparql,
  queryResults,
  queryLoading,
  queryError,
  runQuery,
}: {
  sparql: string;
  setSparql: (s: string) => void;
  queryResults: QueryResult | null;
  queryLoading: boolean;
  queryError: string | null;
  runQuery: () => void;
}) {
  return (
    <div>
      {/* Example query buttons */}
      <div className="mb-4 flex flex-wrap gap-2">
        <span className="text-xs text-gray-500 self-center mr-1">Examples:</span>
        {EXAMPLE_QUERIES.map((eq) => (
          <button
            key={eq.label}
            onClick={() => setSparql(eq.sparql)}
            className="rounded-full border border-gray-300 px-3 py-1 text-xs text-gray-600 hover:bg-gray-100 transition-colors"
          >
            {eq.label}
          </button>
        ))}
      </div>

      {/* Query editor */}
      <div className="rounded-lg border border-gray-200 bg-gray-50 p-4">
        <textarea
          value={sparql}
          onChange={(e) => setSparql(e.target.value)}
          rows={8}
          className="w-full rounded-md border border-gray-300 bg-white p-3 font-mono text-sm focus:border-blue-500 focus:outline-none"
          placeholder="Enter SPARQL query..."
        />
        <div className="mt-3 flex items-center gap-3">
          <button
            onClick={runQuery}
            disabled={queryLoading || !sparql.trim()}
            className="rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 disabled:opacity-50 transition-colors"
          >
            {queryLoading ? "Executing..." : "Run Query"}
          </button>
          {queryResults && (
            <span className="text-sm text-gray-500">
              {queryResults.results.length} result{queryResults.results.length !== 1 ? "s" : ""}
            </span>
          )}
        </div>
      </div>

      {/* Error */}
      {queryError && (
        <div className="mt-4 rounded-lg border border-red-200 bg-red-50 p-4 text-sm text-red-700">
          {queryError}
        </div>
      )}

      {/* Results table */}
      {queryResults && queryResults.results.length > 0 && (
        <div className="mt-4 overflow-x-auto rounded-lg border border-gray-200">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                {Object.keys(queryResults.results[0]).map((col) => (
                  <th
                    key={col}
                    className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase"
                  >
                    {col}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200 bg-white">
              {queryResults.results.map((row, i) => (
                <tr key={i}>
                  {Object.values(row).map((val, j) => (
                    <td key={j} className="px-4 py-2 text-sm text-gray-600 max-w-xs truncate">
                      {String(val)}
                    </td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {queryResults && queryResults.results.length === 0 && (
        <div className="mt-4 text-center py-8 text-gray-400 text-sm">
          No results returned
        </div>
      )}
    </div>
  );
}

function Neo4jTab({ stats }: { stats: Neo4jStats | null }) {
  if (!stats) {
    return (
      <div className="text-center py-12 text-gray-400">
        Neo4j statistics unavailable
      </div>
    );
  }

  const cards = [
    { label: "Entities", value: stats.entities, color: "bg-green-500" },
    { label: "Sources", value: stats.sources, color: "bg-emerald-500" },
    { label: "RELATES_TO", value: stats.relatesToCount, color: "bg-teal-500" },
    { label: "MENTIONS", value: stats.mentionsCount, color: "bg-cyan-500" },
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
      <p className="mt-4 text-sm text-gray-500">
        Neo4j data is queried via Cypher. See the Platform Comparison tab for a side-by-side view with Stardog.
      </p>
    </div>
  );
}
