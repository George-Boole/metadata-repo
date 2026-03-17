"use client";

import { useEffect, useCallback, useState, useMemo } from "react";
import Graph from "graphology";
import { SigmaContainer, useRegisterEvents, useLoadGraph, useSigma, useSetSettings } from "@react-sigma/core";
import { useRouter } from "next/navigation";
import forceAtlas2 from "graphology-layout-forceatlas2";
import "@react-sigma/core/lib/style.css";

const TYPE_COLORS: Record<string, string> = {
  Standard: "#3b82f6",
  Guidance: "#ef4444",
  Tool: "#f59e0b",
  Profile: "#8b5cf6",
  Ontology: "#10b981",
  Organization: "#6366f1",
  Entity: "#9ca3af",
};

export interface GraphNode {
  id: string;
  type: string;
  sourceIds?: string[];
}

export interface GraphLink {
  source: string;
  target: string;
  type: string;
}

export interface GraphData {
  nodes: GraphNode[];
  links: GraphLink[];
}

interface GraphVisualizationProps {
  data: GraphData;
  height?: number;
  onNodeClick?: (node: GraphNode) => void;
}

/** Inner component that has access to Sigma hooks */
function GraphEvents({
  nodeMap,
  onNodeClick,
}: {
  nodeMap: Map<string, GraphNode>;
  onNodeClick?: (node: GraphNode) => void;
}) {
  const registerEvents = useRegisterEvents();
  const sigma = useSigma();
  const setSettings = useSetSettings();
  const [hoveredNode, setHoveredNode] = useState<string | null>(null);
  const router = useRouter();

  // Compute neighbor sets
  const neighborMap = useMemo(() => {
    const graph = sigma.getGraph();
    const map = new Map<string, Set<string>>();
    graph.forEachNode((node) => {
      const neighbors = new Set<string>();
      graph.forEachNeighbor(node, (neighbor) => neighbors.add(neighbor));
      map.set(node, neighbors);
    });
    return map;
  }, [sigma]);

  useEffect(() => {
    registerEvents({
      enterNode: (event) => setHoveredNode(event.node),
      leaveNode: () => setHoveredNode(null),
      clickNode: (event) => {
        const node = nodeMap.get(event.node);
        if (node) {
          if (onNodeClick) {
            onNodeClick(node);
          } else if (node.sourceIds && node.sourceIds.length === 1) {
            router.push(`/sources/${node.sourceIds[0]}`);
          }
        }
      },
    });
  }, [registerEvents, nodeMap, onNodeClick, router]);

  // Update node/edge rendering based on hover state
  useEffect(() => {
    const hoveredNeighbors = hoveredNode ? neighborMap.get(hoveredNode) : null;

    setSettings({
      nodeReducer: (node, data) => {
        const res = { ...data };
        if (hoveredNode) {
          if (node === hoveredNode) {
            res.highlighted = true;
            res.zIndex = 2;
          } else if (hoveredNeighbors?.has(node)) {
            res.zIndex = 1;
          } else {
            res.color = `${res.color}30`;
            res.label = "";
            res.zIndex = 0;
          }
        }
        return res;
      },
      edgeReducer: (edge, data) => {
        const res = { ...data };
        if (hoveredNode) {
          const graph = sigma.getGraph();
          const source = graph.source(edge);
          const target = graph.target(edge);
          if (source === hoveredNode || target === hoveredNode) {
            res.color = "#64748b";
            res.size = 2;
            res.zIndex = 1;
          } else {
            res.color = "#e2e8f020";
            res.hidden = true;
          }
        }
        return res;
      },
    });
  }, [hoveredNode, neighborMap, setSettings, sigma]);

  return null;
}

/** Inner component that loads the graph data into Sigma */
function GraphLoader({ data }: { data: GraphData }) {
  const loadGraph = useLoadGraph();

  useEffect(() => {
    const graph = new Graph();

    // Compute connection counts first for node sizing
    const connectionCounts = new Map<string, number>();
    for (const link of data.links) {
      connectionCounts.set(link.source, (connectionCounts.get(link.source) || 0) + 1);
      connectionCounts.set(link.target, (connectionCounts.get(link.target) || 0) + 1);
    }

    const maxConnections = Math.max(1, ...connectionCounts.values());

    // Add nodes
    for (const node of data.nodes) {
      const connections = connectionCounts.get(node.id) || 0;
      // Size: min 3, max 15, scaled by connection count
      const size = 3 + (connections / maxConnections) * 12;
      const color = TYPE_COLORS[node.type] || TYPE_COLORS.Entity;

      graph.addNode(node.id, {
        label: node.id,
        size,
        color,
        x: Math.random() * 100,
        y: Math.random() * 100,
        type: node.type,
      });
    }

    // Add edges (skip duplicates)
    const edgeSet = new Set<string>();
    for (const link of data.links) {
      const key = `${link.source}->${link.target}`;
      if (edgeSet.has(key)) continue;
      edgeSet.add(key);
      if (graph.hasNode(link.source) && graph.hasNode(link.target)) {
        graph.addEdge(link.source, link.target, {
          label: link.type,
          color: "#d1d5db",
          size: 0.5,
        });
      }
    }

    // Apply ForceAtlas2 layout (synchronous, fast for <1000 nodes)
    if (graph.order > 0) {
      forceAtlas2.assign(graph, {
        iterations: 100,
        settings: {
          gravity: 1,
          scalingRatio: 10,
          barnesHutOptimize: graph.order > 500,
          strongGravityMode: true,
        },
      });
    }

    loadGraph(graph);
  }, [data, loadGraph]);

  return null;
}

export default function GraphVisualization({
  data,
  height = 550,
  onNodeClick,
}: GraphVisualizationProps) {
  // Build a lookup map from node id to GraphNode (for click handling)
  const nodeMap = useMemo(() => {
    const map = new Map<string, GraphNode>();
    for (const node of data.nodes) {
      map.set(node.id, node);
    }
    return map;
  }, [data]);

  // Node has linked sources?
  const hasClickableNodes = useMemo(
    () => data.nodes.some((n) => n.sourceIds && n.sourceIds.length > 0),
    [data],
  );

  return (
    <div style={{ height }} className="relative">
      <SigmaContainer
        style={{ height: "100%", width: "100%" }}
        settings={{
          renderLabels: true,
          labelDensity: 0.3,
          labelGridCellSize: 100,
          labelRenderedSizeThreshold: 6,
          labelSize: 12,
          labelColor: { color: "#374151" },
          labelFont: "Inter, system-ui, sans-serif",
          defaultEdgeColor: "#d1d5db",
          defaultEdgeType: "arrow",
          minEdgeThickness: 0.5,
          zIndex: true,
          hideEdgesOnMove: true,
          hideLabelsOnMove: false,
          antiAliasingFeather: 0.5,
        }}
      >
        <GraphLoader data={data} />
        <GraphEvents nodeMap={nodeMap} onNodeClick={onNodeClick} />
      </SigmaContainer>
      {hasClickableNodes && (
        <div className="absolute top-2 right-2 rounded bg-white/80 backdrop-blur-sm px-2 py-1 text-xs text-gray-500 border border-gray-200">
          Click nodes to view source details
        </div>
      )}
    </div>
  );
}
