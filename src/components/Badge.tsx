import type { HostingType, TierId } from "@/types";
import { TIER_LABELS } from "@/types";

/* ── Tier Badge ─────────────────────────────────────────────── */

const TIER_STYLES: Record<TierId, string> = {
  "1":  "bg-tier-1-bg text-tier-1",
  "2A": "bg-tier-2a-bg text-tier-2a",
  "2B": "bg-tier-2b-bg text-tier-2b",
  "3":  "bg-tier-3-bg text-tier-3",
};

export function TierBadge({ tier }: { tier: TierId }) {
  return (
    <span
      className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold ${TIER_STYLES[tier]}`}
    >
      Tier {tier} — {TIER_LABELS[tier]}
    </span>
  );
}

/* ── Hosting Badge ──────────────────────────────────────────── */

export function HostingBadge({ type }: { type: HostingType }) {
  if (type === "stored") {
    return (
      <span className="inline-flex items-center gap-1 rounded-full bg-blue-100 px-2.5 py-0.5 text-xs font-medium text-blue-800">
        <svg className="h-3 w-3" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5M10 11.25h4M3.375 7.5h17.25c.621 0 1.125-.504 1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125z" />
        </svg>
        Stored
      </span>
    );
  }

  return (
    <span className="inline-flex items-center gap-1 rounded-full bg-amber-100 px-2.5 py-0.5 text-xs font-medium text-amber-800">
      <svg className="h-3 w-3" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
        <path strokeLinecap="round" strokeLinejoin="round" d="M13.5 6H5.25A2.25 2.25 0 003 8.25v10.5A2.25 2.25 0 005.25 21h10.5A2.25 2.25 0 0018 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25" />
      </svg>
      Linked
    </span>
  );
}

/* ── Status Badge ───────────────────────────────────────────── */

const STATUS_STYLES: Record<string, string> = {
  active:     "bg-green-100 text-green-800",
  draft:      "bg-gray-100 text-gray-600",
  superseded: "bg-red-100 text-red-700",
};

export function StatusBadge({ status }: { status: "active" | "draft" | "superseded" }) {
  return (
    <span
      className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium capitalize ${STATUS_STYLES[status]}`}
    >
      {status}
    </span>
  );
}
