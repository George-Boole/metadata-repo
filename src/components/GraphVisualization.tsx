"use client";

import { useEffect, useMemo, useState, useCallback } from "react";
import { useRouter } from "next/navigation";

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

interface LayoutNode {
  id: string;
  type: string;
  x: number;
  y: number;
  size: number;
  color: string;
  sourceIds?: string[];
}

/**
 * Canvas-based graph visualization with force-directed layout.
 * Replaces react-force-graph-2d with a custom lightweight implementation
 * using HTML5 Canvas for reliable rendering without WebGL dependencies.
 */
export default function GraphVisualization({
  data,
  height = 550,
  onNodeClick,
}: GraphVisualizationProps) {
  const canvasRef = useCallback((canvas: HTMLCanvasElement | null) => {
    if (canvas) canvasNodeRef.current = canvas;
  }, []);
  const canvasNodeRef = { current: null as HTMLCanvasElement | null };
  const [hoveredNode, setHoveredNode] = useState<string | null>(null);
  const [dimensions, setDimensions] = useState({ width: 900, height });
  const containerRef = useCallback((el: HTMLDivElement | null) => {
    if (el) {
      setDimensions({ width: el.clientWidth, height });
    }
  }, [height]);
  const router = useRouter();

  // Layout nodes with force-directed positions
  const { layoutNodes, layoutLinks, neighborMap, connectionCounts } = useMemo(() => {
    if (data.nodes.length === 0) {
      return {
        layoutNodes: [] as LayoutNode[],
        layoutLinks: [] as { source: string; target: string; type: string }[],
        neighborMap: new Map<string, Set<string>>(),
        connectionCounts: new Map<string, number>(),
      };
    }

    // Count connections
    const counts = new Map<string, number>();
    const neighbors = new Map<string, Set<string>>();
    for (const link of data.links) {
      counts.set(link.source, (counts.get(link.source) || 0) + 1);
      counts.set(link.target, (counts.get(link.target) || 0) + 1);
      if (!neighbors.has(link.source)) neighbors.set(link.source, new Set());
      if (!neighbors.has(link.target)) neighbors.set(link.target, new Set());
      neighbors.get(link.source)!.add(link.target);
      neighbors.get(link.target)!.add(link.source);
    }

    const maxConn = Math.max(1, ...counts.values());

    // Simple force-directed layout (Fruchterman-Reingold style)
    const nodePositions = new Map<string, { x: number; y: number }>();
    const W = 800;
    const H = 500;
    const area = W * H;
    const k = Math.sqrt(area / Math.max(data.nodes.length, 1)) * 0.8;

    // Initialize positions in a circle
    data.nodes.forEach((node, i) => {
      const angle = (2 * Math.PI * i) / data.nodes.length;
      const r = Math.min(W, H) * 0.35;
      nodePositions.set(node.id, {
        x: W / 2 + r * Math.cos(angle) + (Math.random() - 0.5) * 20,
        y: H / 2 + r * Math.sin(angle) + (Math.random() - 0.5) * 20,
      });
    });

    // Run iterations
    const iterations = 80;
    for (let iter = 0; iter < iterations; iter++) {
      const temp = k * (1 - iter / iterations) * 0.5;
      const disp = new Map<string, { dx: number; dy: number }>();
      data.nodes.forEach((n) => disp.set(n.id, { dx: 0, dy: 0 }));

      // Repulsive forces between all pairs (Barnes-Hut simplified: skip distant pairs)
      for (let i = 0; i < data.nodes.length; i++) {
        const pi = nodePositions.get(data.nodes[i].id)!;
        for (let j = i + 1; j < data.nodes.length; j++) {
          const pj = nodePositions.get(data.nodes[j].id)!;
          const dx = pi.x - pj.x;
          const dy = pi.y - pj.y;
          const dist = Math.max(Math.sqrt(dx * dx + dy * dy), 0.1);
          if (dist > k * 6) continue; // Skip distant pairs
          const force = (k * k) / dist;
          const fx = (dx / dist) * force;
          const fy = (dy / dist) * force;
          const di = disp.get(data.nodes[i].id)!;
          const dj = disp.get(data.nodes[j].id)!;
          di.dx += fx;
          di.dy += fy;
          dj.dx -= fx;
          dj.dy -= fy;
        }
      }

      // Attractive forces along edges
      for (const link of data.links) {
        const ps = nodePositions.get(link.source);
        const pt = nodePositions.get(link.target);
        if (!ps || !pt) continue;
        const dx = ps.x - pt.x;
        const dy = ps.y - pt.y;
        const dist = Math.max(Math.sqrt(dx * dx + dy * dy), 0.1);
        const force = (dist * dist) / k;
        const fx = (dx / dist) * force;
        const fy = (dy / dist) * force;
        const ds = disp.get(link.source)!;
        const dt = disp.get(link.target)!;
        ds.dx -= fx;
        ds.dy -= fy;
        dt.dx += fx;
        dt.dy += fy;
      }

      // Gravity toward center
      data.nodes.forEach((n) => {
        const p = nodePositions.get(n.id)!;
        const d = disp.get(n.id)!;
        const dx = W / 2 - p.x;
        const dy = H / 2 - p.y;
        d.dx += dx * 0.01;
        d.dy += dy * 0.01;
      });

      // Apply
      data.nodes.forEach((n) => {
        const p = nodePositions.get(n.id)!;
        const d = disp.get(n.id)!;
        const dist = Math.max(Math.sqrt(d.dx * d.dx + d.dy * d.dy), 0.1);
        const scale = Math.min(dist, temp) / dist;
        p.x = Math.max(30, Math.min(W - 30, p.x + d.dx * scale));
        p.y = Math.max(30, Math.min(H - 30, p.y + d.dy * scale));
      });
    }

    const nodes: LayoutNode[] = data.nodes.map((n) => {
      const pos = nodePositions.get(n.id)!;
      const conn = counts.get(n.id) || 0;
      return {
        id: n.id,
        type: n.type,
        x: pos.x,
        y: pos.y,
        size: 3 + (conn / maxConn) * 10,
        color: TYPE_COLORS[n.type] || TYPE_COLORS.Entity,
        sourceIds: n.sourceIds,
      };
    });

    return {
      layoutNodes: nodes,
      layoutLinks: data.links,
      neighborMap: neighbors,
      connectionCounts: counts,
    };
  }, [data]);

  // Canvas rendering
  useEffect(() => {
    const canvas = document.getElementById("graph-canvas") as HTMLCanvasElement | null;
    if (!canvas || layoutNodes.length === 0) return;
    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    const dpr = window.devicePixelRatio || 1;
    canvas.width = dimensions.width * dpr;
    canvas.height = dimensions.height * dpr;
    ctx.scale(dpr, dpr);

    // Clear
    ctx.fillStyle = "#f8fafc";
    ctx.fillRect(0, 0, dimensions.width, dimensions.height);

    // Scale factor to map layout coords to canvas
    const scaleX = dimensions.width / 800;
    const scaleY = dimensions.height / 500;

    const nodeById = new Map<string, LayoutNode>();
    layoutNodes.forEach((n) => nodeById.set(n.id, n));

    const hoveredNeighbors = hoveredNode ? neighborMap.get(hoveredNode) : null;

    // Draw edges
    for (const link of layoutLinks) {
      const s = nodeById.get(link.source);
      const t = nodeById.get(link.target);
      if (!s || !t) continue;

      const isConnectedToHover = hoveredNode
        ? hoveredNode === link.source || hoveredNode === link.target
        : false;
      const isDimmed = hoveredNode !== null && !isConnectedToHover;

      ctx.beginPath();
      ctx.moveTo(s.x * scaleX, s.y * scaleY);
      ctx.lineTo(t.x * scaleX, t.y * scaleY);
      ctx.strokeStyle = isDimmed ? "rgba(209,213,219,0.1)" : isConnectedToHover ? "#64748b" : "rgba(209,213,219,0.5)";
      ctx.lineWidth = isDimmed ? 0.3 : isConnectedToHover ? 2 : 0.7;
      ctx.stroke();

      // Arrow
      if (!isDimmed) {
        const dx = t.x * scaleX - s.x * scaleX;
        const dy = t.y * scaleY - s.y * scaleY;
        const len = Math.sqrt(dx * dx + dy * dy);
        if (len > 0) {
          const arrowLen = 4;
          const endX = t.x * scaleX - (dx / len) * (t.size + 2);
          const endY = t.y * scaleY - (dy / len) * (t.size + 2);
          const angle = Math.atan2(dy, dx);
          ctx.beginPath();
          ctx.moveTo(endX, endY);
          ctx.lineTo(endX - arrowLen * Math.cos(angle - Math.PI / 6), endY - arrowLen * Math.sin(angle - Math.PI / 6));
          ctx.lineTo(endX - arrowLen * Math.cos(angle + Math.PI / 6), endY - arrowLen * Math.sin(angle + Math.PI / 6));
          ctx.closePath();
          ctx.fillStyle = isConnectedToHover ? "#64748b" : "rgba(209,213,219,0.5)";
          ctx.fill();
        }
      }
    }

    // Draw nodes
    for (const node of layoutNodes) {
      const isHovered = hoveredNode === node.id;
      const isNeighbor = hoveredNode ? hoveredNeighbors?.has(node.id) : false;
      const isDimmed = hoveredNode !== null && !isHovered && !isNeighbor;
      const hasSource = node.sourceIds && node.sourceIds.length > 0;

      const x = node.x * scaleX;
      const y = node.y * scaleY;
      const r = isHovered ? node.size * 1.4 : node.size;

      // Node circle
      ctx.beginPath();
      ctx.arc(x, y, r, 0, 2 * Math.PI);
      ctx.fillStyle = isDimmed ? `${node.color}25` : node.color;
      ctx.fill();

      // Border for hovered/neighbor
      if (isHovered) {
        ctx.strokeStyle = "#1e293b";
        ctx.lineWidth = 2;
        ctx.stroke();
      } else if (isNeighbor) {
        ctx.strokeStyle = node.color;
        ctx.lineWidth = 1.5;
        ctx.stroke();
      } else if (hasSource && !isDimmed) {
        // Subtle ring for clickable nodes
        ctx.strokeStyle = `${node.color}60`;
        ctx.lineWidth = 0.5;
        ctx.stroke();
      }

      // Label
      const conn = connectionCounts.get(node.id) || 0;
      const showLabel = isHovered || isNeighbor || conn >= 4;
      if (showLabel && !isDimmed) {
        ctx.font = `${isHovered ? "bold " : ""}${isHovered ? 11 : 9}px Inter, system-ui, sans-serif`;
        ctx.textAlign = "center";
        ctx.textBaseline = "top";
        ctx.fillStyle = isHovered ? "#1e293b" : isDimmed ? "#9ca3af40" : "#374151";
        ctx.fillText(node.id, x, y + r + 3, 120);
      }
    }
  }, [layoutNodes, layoutLinks, hoveredNode, neighborMap, connectionCounts, dimensions]);

  // Mouse interaction
  useEffect(() => {
    const canvas = document.getElementById("graph-canvas") as HTMLCanvasElement | null;
    if (!canvas) return;

    const scaleX = dimensions.width / 800;
    const scaleY = dimensions.height / 500;

    function findNode(mx: number, my: number): LayoutNode | null {
      const rect = canvas!.getBoundingClientRect();
      const x = mx - rect.left;
      const y = my - rect.top;
      for (let i = layoutNodes.length - 1; i >= 0; i--) {
        const n = layoutNodes[i];
        const nx = n.x * scaleX;
        const ny = n.y * scaleY;
        const dist = Math.sqrt((x - nx) ** 2 + (y - ny) ** 2);
        if (dist <= n.size + 3) return n;
      }
      return null;
    }

    function onMouseMove(e: MouseEvent) {
      const node = findNode(e.clientX, e.clientY);
      setHoveredNode(node ? node.id : null);
      canvas!.style.cursor = node ? (node.sourceIds?.length ? "pointer" : "default") : "default";
    }

    function onClick(e: MouseEvent) {
      const node = findNode(e.clientX, e.clientY);
      if (node) {
        if (onNodeClick) {
          onNodeClick(node);
        } else if (node.sourceIds && node.sourceIds.length > 0) {
          router.push(`/sources/${node.sourceIds[0]}`);
        }
      }
    }

    canvas.addEventListener("mousemove", onMouseMove);
    canvas.addEventListener("click", onClick);
    return () => {
      canvas.removeEventListener("mousemove", onMouseMove);
      canvas.removeEventListener("click", onClick);
    };
  }, [layoutNodes, dimensions, onNodeClick, router]);

  // Node info for hovered node
  const hoveredInfo = hoveredNode ? layoutNodes.find((n) => n.id === hoveredNode) : null;

  return (
    <div ref={containerRef} style={{ height }} className="relative">
      <canvas
        id="graph-canvas"
        style={{ width: "100%", height: "100%" }}
      />
      {/* Stats overlay */}
      <div className="absolute bottom-0 left-0 right-0 flex gap-6 px-4 py-2 text-sm text-gray-600 bg-white/90 backdrop-blur-sm border-t border-gray-200">
        <span className="font-medium">{layoutNodes.length} nodes</span>
        <span className="font-medium">{layoutLinks.length} relationships</span>
        {hoveredInfo && (
          <span className="text-gray-800 font-semibold">
            {hoveredInfo.id} ({hoveredInfo.type}) &mdash; {connectionCounts.get(hoveredInfo.id) || 0} connections
            {hoveredInfo.sourceIds?.length ? " [click to view source]" : ""}
          </span>
        )}
      </div>
    </div>
  );
}
