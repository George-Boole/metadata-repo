"use client";

import { useEffect, useMemo, useState, useRef, useCallback } from "react";
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
  connections: number;
}

export default function GraphVisualization({
  data,
  height = 550,
  onNodeClick,
}: GraphVisualizationProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const containerRef = useRef<HTMLDivElement>(null);
  const [hoveredNode, setHoveredNode] = useState<string | null>(null);
  const [dims, setDims] = useState({ width: 900, height });
  const router = useRouter();

  // Camera state for zoom/pan
  const cameraRef = useRef({ x: 0, y: 0, zoom: 1 });
  const dragRef = useRef<{ dragging: boolean; lastX: number; lastY: number }>({
    dragging: false,
    lastX: 0,
    lastY: 0,
  });
  // Track render trigger
  const [renderTick, setRenderTick] = useState(0);
  const requestRender = useCallback(() => setRenderTick((t) => t + 1), []);

  // Measure container
  useEffect(() => {
    const el = containerRef.current;
    if (!el) return;
    const ro = new ResizeObserver((entries) => {
      const { width } = entries[0].contentRect;
      setDims({ width, height });
    });
    ro.observe(el);
    return () => ro.disconnect();
  }, [height]);

  // Compute layout (only when data changes)
  const { layoutNodes, layoutLinks, neighborMap, connectionCounts, nodeById } = useMemo(() => {
    if (data.nodes.length === 0) {
      return {
        layoutNodes: [] as LayoutNode[],
        layoutLinks: data.links,
        neighborMap: new Map<string, Set<string>>(),
        connectionCounts: new Map<string, number>(),
        nodeById: new Map<string, LayoutNode>(),
      };
    }

    // Count connections and neighbors
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

    // Separate connected and isolated nodes
    const connectedNodes = data.nodes.filter((n) => (counts.get(n.id) || 0) > 0);
    const isolatedNodes = data.nodes.filter((n) => (counts.get(n.id) || 0) === 0);

    // Force-directed layout for connected nodes
    const W = 2000;
    const H = 1400;
    const k = Math.sqrt((W * H) / Math.max(connectedNodes.length, 1)) * 0.6;
    const nodePositions = new Map<string, { x: number; y: number }>();

    // Initialize connected nodes in a circle
    connectedNodes.forEach((node, i) => {
      const angle = (2 * Math.PI * i) / connectedNodes.length;
      const r = Math.min(W, H) * 0.3;
      nodePositions.set(node.id, {
        x: W / 2 + r * Math.cos(angle) + (Math.random() - 0.5) * 40,
        y: H / 2 + r * Math.sin(angle) + (Math.random() - 0.5) * 40,
      });
    });

    // Run force simulation
    const iterations = 120;
    for (let iter = 0; iter < iterations; iter++) {
      const temp = k * (1 - iter / iterations) * 0.4;

      const disp = new Map<string, { dx: number; dy: number }>();
      connectedNodes.forEach((n) => disp.set(n.id, { dx: 0, dy: 0 }));

      // Repulsive forces
      for (let i = 0; i < connectedNodes.length; i++) {
        const pi = nodePositions.get(connectedNodes[i].id)!;
        for (let j = i + 1; j < connectedNodes.length; j++) {
          const pj = nodePositions.get(connectedNodes[j].id)!;
          const dx = pi.x - pj.x;
          const dy = pi.y - pj.y;
          const dist = Math.max(Math.sqrt(dx * dx + dy * dy), 1);
          if (dist > k * 8) continue;
          const force = (k * k) / dist;
          const fx = (dx / dist) * force;
          const fy = (dy / dist) * force;
          disp.get(connectedNodes[i].id)!.dx += fx;
          disp.get(connectedNodes[i].id)!.dy += fy;
          disp.get(connectedNodes[j].id)!.dx -= fx;
          disp.get(connectedNodes[j].id)!.dy -= fy;
        }
      }

      // Attractive forces
      for (const link of data.links) {
        const ps = nodePositions.get(link.source);
        const pt = nodePositions.get(link.target);
        if (!ps || !pt) continue;
        const dx = ps.x - pt.x;
        const dy = ps.y - pt.y;
        const dist = Math.max(Math.sqrt(dx * dx + dy * dy), 1);
        const force = (dist * dist) / k * 0.5;
        const fx = (dx / dist) * force;
        const fy = (dy / dist) * force;
        const ds = disp.get(link.source);
        const dt = disp.get(link.target);
        if (ds) { ds.dx -= fx; ds.dy -= fy; }
        if (dt) { dt.dx += fx; dt.dy += fy; }
      }

      // Gravity
      connectedNodes.forEach((n) => {
        const p = nodePositions.get(n.id)!;
        const d = disp.get(n.id)!;
        d.dx += (W / 2 - p.x) * 0.005;
        d.dy += (H / 2 - p.y) * 0.005;
      });

      // Apply
      connectedNodes.forEach((n) => {
        const p = nodePositions.get(n.id)!;
        const d = disp.get(n.id)!;
        const dist = Math.max(Math.sqrt(d.dx * d.dx + d.dy * d.dy), 0.1);
        const scale = Math.min(dist, temp) / dist;
        p.x += d.dx * scale;
        p.y += d.dy * scale;
      });
    }

    // Place isolated nodes in a ring around the outside
    const cx = W / 2, cy = H / 2;
    const outerR = Math.min(W, H) * 0.6;
    isolatedNodes.forEach((node, i) => {
      const angle = (2 * Math.PI * i) / Math.max(isolatedNodes.length, 1);
      nodePositions.set(node.id, {
        x: cx + outerR * Math.cos(angle),
        y: cy + outerR * Math.sin(angle),
      });
    });

    const nodes: LayoutNode[] = data.nodes.map((n) => {
      const pos = nodePositions.get(n.id) || { x: W / 2, y: H / 2 };
      const conn = counts.get(n.id) || 0;
      return {
        id: n.id,
        type: n.type,
        x: pos.x,
        y: pos.y,
        size: 3 + (conn / maxConn) * 14,
        color: TYPE_COLORS[n.type] || TYPE_COLORS.Entity,
        sourceIds: n.sourceIds,
        connections: conn,
      };
    });

    const byId = new Map<string, LayoutNode>();
    nodes.forEach((n) => byId.set(n.id, n));

    return {
      layoutNodes: nodes,
      layoutLinks: data.links,
      neighborMap: neighbors,
      connectionCounts: counts,
      nodeById: byId,
    };
  }, [data]);

  // Reset camera when data changes
  useEffect(() => {
    cameraRef.current = { x: 0, y: 0, zoom: 1 };
    requestRender();
  }, [data, requestRender]);

  // Canvas rendering
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas || layoutNodes.length === 0) return;
    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    const dpr = window.devicePixelRatio || 1;
    canvas.width = dims.width * dpr;
    canvas.height = dims.height * dpr;
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);

    const cam = cameraRef.current;

    // Clear
    ctx.fillStyle = "#f8fafc";
    ctx.fillRect(0, 0, dims.width, dims.height);

    // Apply camera transform
    ctx.save();
    ctx.translate(dims.width / 2, dims.height / 2);
    ctx.scale(cam.zoom, cam.zoom);
    ctx.translate(cam.x - 1000, cam.y - 700); // Center on layout center (2000/2, 1400/2)

    const hoveredNeighbors = hoveredNode ? neighborMap.get(hoveredNode) : null;

    // Draw edges
    for (const link of layoutLinks) {
      const s = nodeById.get(link.source);
      const t = nodeById.get(link.target);
      if (!s || !t) continue;

      const isConnected = hoveredNode
        ? hoveredNode === link.source || hoveredNode === link.target
        : false;
      const isDimmed = hoveredNode !== null && !isConnected;

      ctx.beginPath();
      ctx.moveTo(s.x, s.y);
      ctx.lineTo(t.x, t.y);
      ctx.strokeStyle = isDimmed ? "rgba(209,213,219,0.07)" : isConnected ? "#475569" : "rgba(180,190,200,0.35)";
      ctx.lineWidth = isDimmed ? 0.2 : isConnected ? 2.5 / cam.zoom : 0.8 / cam.zoom;
      ctx.stroke();

      // Arrow for connected edges
      if (isConnected) {
        const dx = t.x - s.x;
        const dy = t.y - s.y;
        const len = Math.sqrt(dx * dx + dy * dy);
        if (len > 0) {
          const aLen = 6 / cam.zoom;
          const ex = t.x - (dx / len) * (t.size + 3);
          const ey = t.y - (dy / len) * (t.size + 3);
          const angle = Math.atan2(dy, dx);
          ctx.beginPath();
          ctx.moveTo(ex, ey);
          ctx.lineTo(ex - aLen * Math.cos(angle - 0.5), ey - aLen * Math.sin(angle - 0.5));
          ctx.lineTo(ex - aLen * Math.cos(angle + 0.5), ey - aLen * Math.sin(angle + 0.5));
          ctx.closePath();
          ctx.fillStyle = "#475569";
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

      const r = isHovered ? node.size * 1.5 : node.size;

      // Node circle
      ctx.beginPath();
      ctx.arc(node.x, node.y, r, 0, 2 * Math.PI);
      ctx.fillStyle = isDimmed ? `${node.color}20` : node.color;
      ctx.fill();

      if (isHovered) {
        ctx.strokeStyle = "#0f172a";
        ctx.lineWidth = 2.5 / cam.zoom;
        ctx.stroke();
      } else if (isNeighbor) {
        ctx.strokeStyle = node.color;
        ctx.lineWidth = 1.5 / cam.zoom;
        ctx.stroke();
      } else if (hasSource && !isDimmed) {
        ctx.strokeStyle = `${node.color}80`;
        ctx.lineWidth = 1 / cam.zoom;
        ctx.stroke();
      }

      // Labels — show based on zoom level and connection count
      const labelThreshold = cam.zoom > 2 ? 0 : cam.zoom > 1 ? 2 : cam.zoom > 0.6 ? 5 : 8;
      const showLabel = isHovered || isNeighbor || node.connections >= labelThreshold;
      if (showLabel && !isDimmed) {
        const fontSize = Math.max(8, Math.min(14, 11 / cam.zoom));
        ctx.font = `${isHovered ? "bold " : ""}${fontSize}px Inter, system-ui, sans-serif`;
        ctx.textAlign = "center";
        ctx.textBaseline = "top";
        ctx.fillStyle = isHovered ? "#0f172a" : "#374151";

        // Text background for readability
        const text = node.id.length > 25 ? node.id.slice(0, 23) + "..." : node.id;
        const textWidth = ctx.measureText(text).width;
        const ty = node.y + r + 3;
        ctx.fillStyle = "rgba(248,250,252,0.85)";
        ctx.fillRect(node.x - textWidth / 2 - 2, ty - 1, textWidth + 4, fontSize + 2);
        ctx.fillStyle = isHovered ? "#0f172a" : "#374151";
        ctx.fillText(text, node.x, ty);
      }
    }

    ctx.restore();

    // Zoom level indicator
    const zoomPct = Math.round(cam.zoom * 100);
    ctx.font = "11px system-ui, sans-serif";
    ctx.fillStyle = "#94a3b8";
    ctx.textAlign = "right";
    ctx.fillText(`${zoomPct}%`, dims.width - 8, 16);
  }, [layoutNodes, layoutLinks, hoveredNode, neighborMap, nodeById, dims, renderTick]);

  // Mouse interactions: zoom, pan, hover, click
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const cam = cameraRef.current;
    const drag = dragRef.current;

    function screenToWorld(sx: number, sy: number) {
      const rect = canvas!.getBoundingClientRect();
      const cx = sx - rect.left;
      const cy = sy - rect.top;
      const wx = (cx - dims.width / 2) / cam.zoom - cam.x + 1000;
      const wy = (cy - dims.height / 2) / cam.zoom - cam.y + 700;
      return { wx, wy };
    }

    function findNodeAt(sx: number, sy: number): LayoutNode | null {
      const { wx, wy } = screenToWorld(sx, sy);
      // Check in reverse (top nodes first)
      for (let i = layoutNodes.length - 1; i >= 0; i--) {
        const n = layoutNodes[i];
        const dx = wx - n.x;
        const dy = wy - n.y;
        const hitR = n.size + 4 / cam.zoom;
        if (dx * dx + dy * dy <= hitR * hitR) return n;
      }
      return null;
    }

    function onWheel(e: WheelEvent) {
      e.preventDefault();
      const factor = e.deltaY > 0 ? 0.9 : 1.1;
      cam.zoom = Math.max(0.15, Math.min(8, cam.zoom * factor));
      requestRender();
    }

    function onMouseDown(e: MouseEvent) {
      if (e.button === 0) {
        drag.dragging = true;
        drag.lastX = e.clientX;
        drag.lastY = e.clientY;
        canvas!.style.cursor = "grabbing";
      }
    }

    function onMouseUp() {
      drag.dragging = false;
      canvas!.style.cursor = "default";
    }

    function onMouseMove(e: MouseEvent) {
      if (drag.dragging) {
        const dx = (e.clientX - drag.lastX) / cam.zoom;
        const dy = (e.clientY - drag.lastY) / cam.zoom;
        cam.x += dx;
        cam.y += dy;
        drag.lastX = e.clientX;
        drag.lastY = e.clientY;
        requestRender();
        return;
      }

      const node = findNodeAt(e.clientX, e.clientY);
      const newHovered = node ? node.id : null;
      setHoveredNode((prev) => (prev !== newHovered ? newHovered : prev));
      canvas!.style.cursor = node
        ? node.sourceIds?.length
          ? "pointer"
          : "grab"
        : "grab";
    }

    function onClick(e: MouseEvent) {
      if (drag.dragging) return;
      const node = findNodeAt(e.clientX, e.clientY);
      if (node) {
        if (onNodeClick) {
          onNodeClick(node);
        } else if (node.sourceIds && node.sourceIds.length > 0) {
          router.push(`/sources/${node.sourceIds[0]}`);
        }
      }
    }

    canvas.addEventListener("wheel", onWheel, { passive: false });
    canvas.addEventListener("mousedown", onMouseDown);
    canvas.addEventListener("mousemove", onMouseMove);
    canvas.addEventListener("mouseup", onMouseUp);
    canvas.addEventListener("mouseleave", onMouseUp);
    canvas.addEventListener("click", onClick);

    return () => {
      canvas.removeEventListener("wheel", onWheel);
      canvas.removeEventListener("mousedown", onMouseDown);
      canvas.removeEventListener("mousemove", onMouseMove);
      canvas.removeEventListener("mouseup", onMouseUp);
      canvas.removeEventListener("mouseleave", onMouseUp);
      canvas.removeEventListener("click", onClick);
    };
  }, [layoutNodes, dims, onNodeClick, router, requestRender]);

  const hoveredInfo = hoveredNode ? nodeById.get(hoveredNode) : null;

  return (
    <div ref={containerRef} style={{ height }} className="relative">
      <canvas
        ref={canvasRef}
        style={{ width: "100%", height: "100%", touchAction: "none" }}
      />
      {/* Controls hint */}
      <div className="absolute top-2 left-2 rounded bg-white/80 backdrop-blur-sm px-2 py-1 text-xs text-gray-400 border border-gray-200">
        Scroll to zoom. Drag to pan.
      </div>
      {/* Stats bar */}
      <div className="absolute bottom-0 left-0 right-0 flex gap-6 px-4 py-2 text-sm text-gray-600 bg-white/90 backdrop-blur-sm border-t border-gray-200">
        <span className="font-medium">{layoutNodes.length} nodes</span>
        <span className="font-medium">{layoutLinks.length} relationships</span>
        {hoveredInfo && (
          <span className="text-gray-800 font-semibold">
            {hoveredInfo.id} ({hoveredInfo.type}) &mdash; {hoveredInfo.connections} connections
            {hoveredInfo.sourceIds?.length ? " [click to view source]" : ""}
          </span>
        )}
      </div>
    </div>
  );
}
