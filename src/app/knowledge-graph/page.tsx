"use client";

import dynamic from "next/dynamic";
import { useEffect, useState, useCallback } from "react";
import { useRouter } from "next/navigation";

// Dynamic import for Sigma.js (needs DOM/WebGL)
const GraphVisualization = dynamic(
  () => import("@/components/GraphVisualization"),
  {
    ssr: false,
    loading: () => (
      <div className="flex items-center justify-center h-[550px] text-gray-400">
        Loading graph visualization...
      </div>
    ),
  },
);

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

interface GraphNode {
  id: string;
  type: string;
  sourceIds?: string[];
}

interface GraphLink {
  source: string;
  target: string;
  type: string;
}

interface GraphData {
  nodes: GraphNode[];
  links: GraphLink[];
}

interface QueryResult {
  results: Record<string, string>[];
  reasoning?: boolean;
  explain?: string;
}

const TYPE_COLORS: Record<string, string> = {
  Standard: "#3b82f6",
  Guidance: "#ef4444",
  Tool: "#f59e0b",
  Profile: "#8b5cf6",
  Ontology: "#10b981",
  Organization: "#6366f1",
  Entity: "#9ca3af",
};

const STARDOG_STUDIO_URL = "https://cloud.stardog.com/u/0/studio";

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
  {
    label: "Multi-hop paths (NIEM)",
    sparql: `PREFIX daf: <https://daf-metadata.mil/ontology/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT ?startName ?rel1 ?midName ?rel2 ?endName WHERE {
  ?start skos:prefLabel ?startName .
  FILTER(CONTAINS(LCASE(?startName), "niem"))
  ?start ?r1 ?mid .
  FILTER(STRSTARTS(STR(?r1), "https://daf-metadata.mil/ontology/rel/"))
  BIND(REPLACE(STR(?r1), "https://daf-metadata.mil/ontology/rel/", "") AS ?rel1)
  ?mid skos:prefLabel ?midName .
  ?mid ?r2 ?end .
  FILTER(STRSTARTS(STR(?r2), "https://daf-metadata.mil/ontology/rel/"))
  BIND(REPLACE(STR(?r2), "https://daf-metadata.mil/ontology/rel/", "") AS ?rel2)
  ?end skos:prefLabel ?endName .
  FILTER(?start != ?end)
} LIMIT 20`,
  },
  {
    label: "Hub entities (most connected)",
    sparql: `PREFIX daf: <https://daf-metadata.mil/ontology/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT ?name ?type (COUNT(*) AS ?connections) WHERE {
  {
    ?entity ?relIri ?other .
    FILTER(STRSTARTS(STR(?relIri), "https://daf-metadata.mil/ontology/rel/"))
  } UNION {
    ?other ?relIri ?entity .
    FILTER(STRSTARTS(STR(?relIri), "https://daf-metadata.mil/ontology/rel/"))
  }
  ?entity skos:prefLabel ?name .
  ?entity a ?typeIri .
  FILTER(STRSTARTS(STR(?typeIri), STR(daf:)))
  BIND(REPLACE(STR(?typeIri), STR(daf:), "") AS ?type)
} GROUP BY ?name ?type ORDER BY DESC(?connections) LIMIT 15`,
  },
];

type TabId = "graph" | "comparison" | "sparql" | "pathfinder" | "neo4j";

export default function KnowledgeGraphPage() {
  const [activeTab, setActiveTab] = useState<TabId>("graph");
  const [stardogStats, setStardogStats] = useState<StardogStats | null>(null);
  const [neo4jStats, setNeo4jStats] = useState<Neo4jStats | null>(null);
  const [loading, setLoading] = useState(true);
  const [showStardog, setShowStardog] = useState(true);

  // SPARQL tab state
  const [sparql, setSparql] = useState(EXAMPLE_QUERIES[0].sparql);
  const [queryResults, setQueryResults] = useState<QueryResult | null>(null);
  const [queryLoading, setQueryLoading] = useState(false);
  const [queryError, setQueryError] = useState<string | null>(null);
  const [reasoning, setReasoning] = useState(false);

  // Fetch public settings for Stardog visibility
  useEffect(() => {
    fetch("/api/settings")
      .then((r) => r.json())
      .then((data) => {
        if (data.show_stardog !== undefined) {
          setShowStardog(data.show_stardog);
        }
      })
      .catch(() => {});
  }, []);

  useEffect(() => {
    Promise.all([
      fetch("/api/graph/stardog").then((r) => r.json()).catch(() => ({ connected: false, triples: 0, entities: 0, sources: 0, relationships: 0 })),
      fetch("/api/graph/neo4j").then((r) => r.json()).catch(() => null),
    ])
      .then(([sd, neo]) => {
        setStardogStats(sd);
        if (neo && !neo.error) {
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

  async function runQuery(opts?: { explain?: boolean }) {
    setQueryLoading(true);
    setQueryError(null);
    try {
      const res = await fetch("/api/graph/stardog/query", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ sparql, reasoning, explain: opts?.explain }),
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

  // Reset to graph tab if current tab is Stardog-only and Stardog is hidden
  useEffect(() => {
    if (!showStardog && (activeTab === "comparison" || activeTab === "sparql" || activeTab === "pathfinder")) {
      setActiveTab("graph");
    }
  }, [showStardog, activeTab]);

  const allTabs: { id: TabId; label: string; stardogOnly?: boolean }[] = [
    { id: "graph", label: "Graph Visualization" },
    { id: "pathfinder", label: "Path Finder", stardogOnly: true },
    { id: "comparison", label: "Platform Comparison", stardogOnly: true },
    { id: "sparql", label: "SPARQL Explorer", stardogOnly: true },
    { id: "neo4j", label: "Statistics" },
  ];
  const tabs = allTabs.filter((tab) => showStardog || !tab.stardogOnly);

  return (
    <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-8 flex items-start justify-between">
        <div>
          <h1 className="text-3xl font-bold text-daf-dark-gray">
            Knowledge Graph Explorer
          </h1>
          <p className="mt-2 text-gray-600">
            {showStardog
              ? "Compare graph backends: Neo4j AuraDB (current) vs Stardog Cloud (evaluation)"
              : "Explore the DAF metadata knowledge graph powered by Neo4j AuraDB"}
          </p>
        </div>
        {showStardog && (
          <a
            href={STARDOG_STUDIO_URL}
            target="_blank"
            rel="noopener noreferrer"
            className="shrink-0 flex items-center gap-2 rounded-lg border border-blue-300 bg-blue-50 px-4 py-2 text-sm font-medium text-blue-700 hover:bg-blue-100 transition-colors"
          >
            <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" d="M13.5 6H5.25A2.25 2.25 0 003 8.25v10.5A2.25 2.25 0 005.25 21h10.5A2.25 2.25 0 0018 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25" />
            </svg>
            Open Stardog Studio
          </a>
        )}
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

      {loading && activeTab !== "graph" ? (
        <div className="flex items-center justify-center py-20 text-gray-400">
          Loading graph statistics...
        </div>
      ) : (
        <>
          {activeTab === "graph" && <GraphTab showStardog={showStardog} />}
          {activeTab === "pathfinder" && <PathFinderTab />}
          {activeTab === "comparison" && (
            <ComparisonTab stardogStats={stardogStats} neo4jStats={neo4jStats} />
          )}
          {activeTab === "sparql" && (
            <SparqlTab
              sparql={sparql}
              setSparql={setSparql}
              queryResults={queryResults}
              queryLoading={queryLoading}
              queryError={queryError}
              runQuery={runQuery}
              reasoning={reasoning}
              setReasoning={setReasoning}
            />
          )}
          {activeTab === "neo4j" && <StatsTab neo4jStats={neo4jStats} stardogStats={stardogStats} showStardog={showStardog} />}
        </>
      )}
    </div>
  );
}

/* ── Graph Visualization Tab ─────────────────────────────── */

function GraphTab({ showStardog }: { showStardog: boolean }) {
  const [graphSource, setGraphSource] = useState<"neo4j" | "stardog">("neo4j");
  const [graphData, setGraphData] = useState<GraphData | null>(null);
  const [graphLoading, setGraphLoading] = useState(false);
  const [graphError, setGraphError] = useState<string | null>(null);
  const [filterType, setFilterType] = useState<string | null>(null);
  const router = useRouter();

  const loadGraph = useCallback(async (source: "neo4j" | "stardog") => {
    setGraphLoading(true);
    setGraphError(null);
    try {
      const url = source === "neo4j" ? "/api/graph/neo4j/data" : "/api/graph/stardog/data";
      const res = await fetch(url);
      if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        setGraphError(err.error || `Failed to load ${source} graph`);
        return;
      }
      const data = await res.json();
      setGraphData(data);
    } catch {
      setGraphError(`Failed to connect to ${source}`);
    } finally {
      setGraphLoading(false);
    }
  }, []);

  useEffect(() => {
    loadGraph(graphSource);
  }, [graphSource, loadGraph]);

  // Apply type filter
  const filteredData = graphData && filterType
    ? (() => {
        const filteredNodes = new Set(graphData.nodes.filter((n) => n.type === filterType).map((n) => n.id));
        return {
          nodes: graphData.nodes.filter((n) => filteredNodes.has(n.id)),
          links: graphData.links.filter(
            (l) => filteredNodes.has(typeof l.source === "string" ? l.source : l.source) &&
                   filteredNodes.has(typeof l.target === "string" ? l.target : l.target),
          ),
        };
      })()
    : graphData;

  // Compute type counts for filter buttons
  const typeCounts = graphData
    ? graphData.nodes.reduce<Record<string, number>>((acc, n) => {
        acc[n.type] = (acc[n.type] || 0) + 1;
        return acc;
      }, {})
    : {};

  const handleNodeClick = useCallback((node: GraphNode) => {
    if (node.sourceIds && node.sourceIds.length === 1) {
      router.push(`/sources/${node.sourceIds[0]}`);
    } else if (node.sourceIds && node.sourceIds.length > 1) {
      // For multiple sources, navigate to the first one (could add a picker later)
      router.push(`/sources/${node.sourceIds[0]}`);
    }
  }, [router]);

  return (
    <div>
      {/* Controls row */}
      <div className="mb-4 flex flex-wrap items-center justify-between gap-4">
        <div className="flex items-center gap-2">
          {showStardog ? (
            <>
              <span className="text-sm text-gray-500">Data source:</span>
              <button
                onClick={() => setGraphSource("neo4j")}
                className={`rounded-md px-3 py-1.5 text-sm font-medium transition-colors ${
                  graphSource === "neo4j"
                    ? "bg-green-600 text-white"
                    : "border border-gray-300 text-gray-600 hover:bg-gray-100"
                }`}
              >
                Neo4j
              </button>
              <button
                onClick={() => setGraphSource("stardog")}
                className={`rounded-md px-3 py-1.5 text-sm font-medium transition-colors ${
                  graphSource === "stardog"
                    ? "bg-blue-600 text-white"
                    : "border border-gray-300 text-gray-600 hover:bg-gray-100"
                }`}
              >
                Stardog
              </button>
            </>
          ) : (
            <span className="text-sm text-gray-500">Data source: Neo4j</span>
          )}
        </div>

        {/* Type filter buttons */}
        <div className="flex flex-wrap gap-2">
          <button
            onClick={() => setFilterType(null)}
            className={`rounded-full px-2.5 py-1 text-xs transition-colors ${
              filterType === null
                ? "bg-gray-800 text-white"
                : "border border-gray-300 text-gray-500 hover:bg-gray-100"
            }`}
          >
            All ({graphData?.nodes.length ?? 0})
          </button>
          {Object.entries(TYPE_COLORS).map(([type, color]) => {
            const count = typeCounts[type] || 0;
            if (count === 0) return null;
            return (
              <button
                key={type}
                onClick={() => setFilterType(filterType === type ? null : type)}
                className={`flex items-center gap-1.5 rounded-full px-2.5 py-1 text-xs transition-colors ${
                  filterType === type
                    ? "text-white"
                    : "border border-gray-300 text-gray-500 hover:bg-gray-100"
                }`}
                style={filterType === type ? { backgroundColor: color } : undefined}
              >
                <span
                  className="h-2 w-2 rounded-full"
                  style={{ backgroundColor: color }}
                />
                {type} ({count})
              </button>
            );
          })}
        </div>
      </div>

      {/* Graph container */}
      <div className="rounded-lg border border-gray-200 overflow-hidden" style={{ backgroundColor: "#f8fafc" }}>
        {graphLoading && (
          <div className="flex items-center justify-center h-[550px] text-gray-400">
            Loading {graphSource} graph...
          </div>
        )}
        {graphError && (
          <div className="flex items-center justify-center h-[550px] text-red-500 text-sm">
            {graphError}
          </div>
        )}
        {!graphLoading && !graphError && filteredData && filteredData.nodes.length > 0 && (
          <GraphVisualization
            data={filteredData}
            height={550}
            onNodeClick={handleNodeClick}
          />
        )}
        {!graphLoading && !graphError && filteredData && filteredData.nodes.length === 0 && (
          <div className="flex items-center justify-center h-[550px] text-gray-400 text-sm">
            No graph data available from {graphSource}
          </div>
        )}
      </div>

      {/* Stats bar */}
      {filteredData && filteredData.nodes.length > 0 && (
        <div className="mt-2 flex gap-6 px-2 text-sm text-gray-500">
          <span>{filteredData.nodes.length} nodes</span>
          <span>{filteredData.links.length} relationships</span>
          <span className="text-gray-400">Hover to highlight neighbors. Click nodes with linked sources to navigate.</span>
        </div>
      )}
    </div>
  );
}

/* ── Path Finder Tab ─────────────────────────────────────── */

function PathFinderTab() {
  const [startEntity, setStartEntity] = useState("");
  const [endEntity, setEndEntity] = useState("");
  const [maxHops, setMaxHops] = useState(3);
  const [paths, setPaths] = useState<Record<string, string>[] | null>(null);
  const [pathLoading, setPathLoading] = useState(false);
  const [pathError, setPathError] = useState<string | null>(null);

  async function findPaths() {
    if (!startEntity.trim() || !endEntity.trim()) return;
    setPathLoading(true);
    setPathError(null);
    setPaths(null);

    const sparql = `PREFIX daf: <https://daf-metadata.mil/ontology/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT ?startName ?path ?endName WHERE {
  ?start skos:prefLabel ?startName .
  FILTER(CONTAINS(LCASE(?startName), LCASE("${startEntity.replace(/"/g, '\\"')}")))
  ?start (<https://daf-metadata.mil/ontology/rel/RELATES_TO>){1,${maxHops}} ?end .
  ?end skos:prefLabel ?endName .
  FILTER(CONTAINS(LCASE(?endName), LCASE("${endEntity.replace(/"/g, '\\"')}")))
  BIND("RELATES_TO" AS ?path)
} LIMIT 20`;

    try {
      const res = await fetch("/api/graph/stardog/query", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ sparql }),
      });
      if (!res.ok) {
        const err = await res.json();
        setPathError(err.error || "Path query failed");
        return;
      }
      const data = await res.json();
      setPaths(data.results);
    } catch {
      setPathError("Failed to execute path query");
    } finally {
      setPathLoading(false);
    }
  }

  return (
    <div>
      <p className="mb-4 text-sm text-gray-600">
        Find how two entities are connected through the knowledge graph using SPARQL property paths.
        This leverages Stardog&apos;s SPARQL 1.1 property path support for multi-hop traversal.
      </p>

      <div className="grid gap-4 sm:grid-cols-3 mb-4">
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Start entity (partial name)</label>
          <input
            type="text"
            value={startEntity}
            onChange={(e) => setStartEntity(e.target.value)}
            placeholder="e.g., NIEM"
            className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:outline-none"
          />
        </div>
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">End entity (partial name)</label>
          <input
            type="text"
            value={endEntity}
            onChange={(e) => setEndEntity(e.target.value)}
            placeholder="e.g., IC-ISM"
            className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:outline-none"
          />
        </div>
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Max hops</label>
          <div className="flex items-center gap-2">
            <select
              value={maxHops}
              onChange={(e) => setMaxHops(Number(e.target.value))}
              className="rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:outline-none"
            >
              {[1, 2, 3, 4, 5].map((n) => (
                <option key={n} value={n}>{n}</option>
              ))}
            </select>
            <button
              onClick={findPaths}
              disabled={pathLoading || !startEntity.trim() || !endEntity.trim()}
              className="rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 disabled:opacity-50 transition-colors"
            >
              {pathLoading ? "Searching..." : "Find Paths"}
            </button>
          </div>
        </div>
      </div>

      {pathError && (
        <div className="rounded-lg border border-red-200 bg-red-50 p-4 text-sm text-red-700">
          {pathError}
        </div>
      )}

      {paths && paths.length > 0 && (
        <div className="overflow-x-auto rounded-lg border border-gray-200">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">From</th>
                <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Relationship</th>
                <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">To</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200 bg-white">
              {paths.map((row, i) => (
                <tr key={i}>
                  <td className="px-4 py-2 text-sm text-gray-800 font-medium">{row.startName}</td>
                  <td className="px-4 py-2 text-sm text-gray-500">
                    <span className="rounded bg-gray-100 px-2 py-0.5 text-xs font-mono">{row.path}</span>
                    <span className="ml-1 text-xs text-gray-400">(up to {maxHops} hops)</span>
                  </td>
                  <td className="px-4 py-2 text-sm text-gray-800 font-medium">{row.endName}</td>
                </tr>
              ))}
            </tbody>
          </table>
          <div className="px-4 py-2 text-xs text-gray-400 bg-gray-50">
            {paths.length} path{paths.length !== 1 ? "s" : ""} found
          </div>
        </div>
      )}

      {paths && paths.length === 0 && (
        <div className="text-center py-8 text-gray-400 text-sm">
          No paths found between these entities within {maxHops} hops
        </div>
      )}

      <div className="mt-6 rounded-lg border border-blue-200 bg-blue-50 p-4">
        <h3 className="text-sm font-semibold text-blue-800">About Property Paths</h3>
        <p className="mt-1 text-sm text-blue-700">
          SPARQL 1.1 property paths let you traverse relationships transitively.
          The <code className="rounded bg-blue-100 px-1">+</code> operator means &quot;one or more hops&quot;
          and <code className="rounded bg-blue-100 px-1">*</code> means &quot;zero or more hops&quot;.
          This is a key Stardog capability that Neo4j&apos;s Cypher handles differently with variable-length patterns.
        </p>
      </div>
    </div>
  );
}

/* ── Platform Comparison Tab ─────────────────────────────── */

function ComparisonTab({
  stardogStats,
  neo4jStats,
}: {
  stardogStats: StardogStats | null;
  neo4jStats: Neo4jStats | null;
}) {
  const rows = [
    { metric: "Connection Status", neo4j: neo4jStats ? "Connected" : "Unavailable", stardog: stardogStats?.connected ? "Connected" : "Unavailable" },
    { metric: "Platform", neo4j: "Neo4j AuraDB Free", stardog: "Stardog Cloud Free" },
    { metric: "Query Language", neo4j: "Cypher", stardog: "SPARQL 1.1" },
    { metric: "Data Model", neo4j: "Labeled Property Graph", stardog: "RDF / OWL" },
    { metric: "Entities", neo4j: neo4jStats?.entities.toLocaleString() ?? "\u2014", stardog: stardogStats?.entities.toLocaleString() ?? "\u2014" },
    { metric: "Sources", neo4j: neo4jStats?.sources.toLocaleString() ?? "\u2014", stardog: stardogStats?.sources.toLocaleString() ?? "\u2014" },
    { metric: "Relationships", neo4j: neo4jStats ? (neo4jStats.relatesToCount + neo4jStats.mentionsCount).toLocaleString() : "\u2014", stardog: stardogStats?.relationships.toLocaleString() ?? "\u2014" },
    { metric: "Total Triples / Edges", neo4j: neo4jStats ? (neo4jStats.relatesToCount + neo4jStats.mentionsCount).toLocaleString() : "\u2014", stardog: stardogStats?.triples.toLocaleString() ?? "\u2014" },
    { metric: "Standards Support", neo4j: "Custom schema", stardog: "W3C RDF/OWL/SKOS" },
    { metric: "Inference / Reasoning", neo4j: "None (manual traversal)", stardog: "OWL 2 RL reasoning engine" },
    { metric: "Property Paths", neo4j: "Variable-length patterns", stardog: "SPARQL 1.1 property paths (+, *, ?)" },
    { metric: "Query Explain", neo4j: "EXPLAIN / PROFILE", stardog: "query.explain() with cost analysis" },
    { metric: "Free Tier Limits", neo4j: "50K nodes / 175K rels", stardog: "25 queries/hour, ~1M triples" },
  ];

  return (
    <div>
      <div className="rounded-lg border border-gray-200 overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Metric</th>
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
                <td className="px-6 py-3 text-sm font-medium text-gray-900">{row.metric}</td>
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
            <li>SPARQL 1.1 property paths for multi-hop traversal</li>
            <li>Query explain with cost analysis</li>
            <li>Enterprise knowledge graph features</li>
          </ul>
        </div>
      </div>
    </div>
  );
}

/* ── SPARQL Explorer Tab ─────────────────────────────────── */

function SparqlTab({
  sparql,
  setSparql,
  queryResults,
  queryLoading,
  queryError,
  runQuery,
  reasoning,
  setReasoning,
}: {
  sparql: string;
  setSparql: (s: string) => void;
  queryResults: QueryResult | null;
  queryLoading: boolean;
  queryError: string | null;
  runQuery: (opts?: { explain?: boolean }) => void;
  reasoning: boolean;
  setReasoning: (r: boolean) => void;
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
        <div className="mt-3 flex flex-wrap items-center gap-3">
          <button
            onClick={() => runQuery()}
            disabled={queryLoading || !sparql.trim()}
            className="rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 disabled:opacity-50 transition-colors"
          >
            {queryLoading ? "Executing..." : "Run Query"}
          </button>
          <button
            onClick={() => runQuery({ explain: true })}
            disabled={queryLoading || !sparql.trim()}
            className="rounded-md border border-gray-300 px-4 py-2 text-sm font-medium text-gray-600 hover:bg-gray-100 disabled:opacity-50 transition-colors"
          >
            Explain Plan
          </button>

          <div className="flex items-center gap-2 ml-2">
            <label className="flex items-center gap-1.5 cursor-pointer">
              <input
                type="checkbox"
                checked={reasoning}
                onChange={(e) => setReasoning(e.target.checked)}
                className="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
              />
              <span className="text-sm text-gray-600">Enable Reasoning</span>
            </label>
            <span className="text-xs text-gray-400" title="Stardog OWL 2 RL reasoning infers additional triples at query time">
              (OWL 2 RL)
            </span>
          </div>

          {queryResults && !queryResults.explain && (
            <span className="text-sm text-gray-500">
              {queryResults.results.length} result{queryResults.results.length !== 1 ? "s" : ""}
              {queryResults.reasoning && <span className="ml-1 text-blue-500 text-xs">[reasoning enabled]</span>}
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

      {/* Explain plan */}
      {queryResults?.explain && (
        <div className="mt-4 rounded-lg border border-amber-200 bg-amber-50 p-4">
          <h3 className="text-sm font-semibold text-amber-800 mb-2">Query Explain Plan</h3>
          <pre className="whitespace-pre-wrap text-xs text-amber-900 font-mono max-h-96 overflow-y-auto">
            {queryResults.explain}
          </pre>
        </div>
      )}

      {/* Results table */}
      {queryResults && !queryResults.explain && queryResults.results.length > 0 && (
        <div className="mt-4 overflow-x-auto rounded-lg border border-gray-200">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                {Object.keys(queryResults.results[0]).map((col) => (
                  <th key={col} className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">
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

      {queryResults && !queryResults.explain && queryResults.results.length === 0 && (
        <div className="mt-4 text-center py-8 text-gray-400 text-sm">
          No results returned
        </div>
      )}
    </div>
  );
}

/* ── Statistics Tab (combined Neo4j + Stardog) ───────────── */

function StatsTab({
  neo4jStats,
  stardogStats,
  showStardog,
}: {
  neo4jStats: Neo4jStats | null;
  stardogStats: StardogStats | null;
  showStardog: boolean;
}) {
  const [hubEntities, setHubEntities] = useState<Record<string, string>[] | null>(null);
  const [hubLoading, setHubLoading] = useState(false);

  async function loadHubs() {
    setHubLoading(true);
    try {
      const sparql = `PREFIX daf: <https://daf-metadata.mil/ontology/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
SELECT ?name ?type (COUNT(*) AS ?connections) WHERE {
  { ?entity ?r ?other . FILTER(STRSTARTS(STR(?r), "https://daf-metadata.mil/ontology/rel/")) }
  UNION
  { ?other ?r ?entity . FILTER(STRSTARTS(STR(?r), "https://daf-metadata.mil/ontology/rel/")) }
  ?entity skos:prefLabel ?name .
  ?entity a ?typeIri .
  FILTER(STRSTARTS(STR(?typeIri), STR(daf:)))
  BIND(REPLACE(STR(?typeIri), STR(daf:), "") AS ?type)
} GROUP BY ?name ?type ORDER BY DESC(?connections) LIMIT 15`;

      const res = await fetch("/api/graph/stardog/query", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ sparql }),
      });
      if (res.ok) {
        const data = await res.json();
        setHubEntities(data.results);
      }
    } catch {
      // Non-fatal
    } finally {
      setHubLoading(false);
    }
  }

  useEffect(() => {
    if (showStardog) loadHubs();
  }, [showStardog]); // eslint-disable-line react-hooks/exhaustive-deps

  return (
    <div className="space-y-8">
      {/* Neo4j Stats */}
      <div>
        <h2 className="text-lg font-semibold text-gray-800 mb-4">Neo4j AuraDB</h2>
        {neo4jStats ? (
          <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            {[
              { label: "Entities", value: neo4jStats.entities, color: "bg-green-500" },
              { label: "Sources", value: neo4jStats.sources, color: "bg-emerald-500" },
              { label: "RELATES_TO", value: neo4jStats.relatesToCount, color: "bg-teal-500" },
              { label: "MENTIONS", value: neo4jStats.mentionsCount, color: "bg-cyan-500" },
            ].map((card) => (
              <div key={card.label} className="rounded-lg border border-gray-200 bg-white p-5 shadow-sm">
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
        ) : (
          <div className="text-gray-400 text-sm">Neo4j statistics unavailable</div>
        )}
      </div>

      {/* Stardog Stats */}
      {showStardog && stardogStats && (
        <div>
          <h2 className="text-lg font-semibold text-gray-800 mb-4">Stardog Cloud</h2>
          <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            {[
              { label: "Triples", value: stardogStats.triples, color: "bg-blue-500" },
              { label: "Entities", value: stardogStats.entities, color: "bg-indigo-500" },
              { label: "Sources", value: stardogStats.sources, color: "bg-violet-500" },
              { label: "Relationships", value: stardogStats.relationships, color: "bg-purple-500" },
            ].map((card) => (
              <div key={card.label} className="rounded-lg border border-gray-200 bg-white p-5 shadow-sm">
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
        </div>
      )}

      {/* Hub Entities */}
      {showStardog && (
        <div>
          <h2 className="text-lg font-semibold text-gray-800 mb-4">
            Most Connected Entities (Hubs)
          </h2>
          {hubLoading && <div className="text-gray-400 text-sm">Loading hub analysis...</div>}
          {hubEntities && hubEntities.length > 0 && (
            <div className="overflow-x-auto rounded-lg border border-gray-200">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Rank</th>
                    <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Entity</th>
                    <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Type</th>
                    <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Connections</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-200 bg-white">
                  {hubEntities.map((hub, i) => (
                    <tr key={i}>
                      <td className="px-4 py-2 text-sm text-gray-400">{i + 1}</td>
                      <td className="px-4 py-2 text-sm font-medium text-gray-800">{hub.name}</td>
                      <td className="px-4 py-2 text-sm">
                        <span
                          className="inline-block rounded-full px-2 py-0.5 text-xs text-white"
                          style={{ backgroundColor: TYPE_COLORS[hub.type] || TYPE_COLORS.Entity }}
                        >
                          {hub.type}
                        </span>
                      </td>
                      <td className="px-4 py-2 text-sm text-gray-600">{hub.connections}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
