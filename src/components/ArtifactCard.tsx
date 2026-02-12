import Link from "next/link";
import type { TierId, HostingType } from "@/types";
import { TierBadge, HostingBadge, StatusBadge } from "@/components/Badge";

const TIER_BORDER: Record<TierId, string> = {
  "1":  "border-l-tier-1",
  "2A": "border-l-tier-2a",
  "2B": "border-l-tier-2b",
  "3":  "border-l-tier-3",
};

interface ArtifactCardProps {
  title: string;
  description: string;
  tier: TierId;
  hostingType: HostingType;
  status: "active" | "draft" | "superseded";
  href: string;
  metadata?: { label: string; value: string }[];
}

export default function ArtifactCard({
  title,
  description,
  tier,
  hostingType,
  status,
  href,
  metadata,
}: ArtifactCardProps) {
  return (
    <Link
      href={href}
      className={`block rounded-lg border border-gray-200 border-l-4 ${TIER_BORDER[tier]} bg-white p-5 shadow-sm transition-shadow hover:shadow-md`}
    >
      <div className="flex flex-wrap items-start justify-between gap-2 mb-2">
        <h3 className="text-lg font-semibold text-daf-dark-gray">{title}</h3>
        <div className="flex items-center gap-2">
          <StatusBadge status={status} />
          <HostingBadge type={hostingType} />
        </div>
      </div>

      <p className="mb-3 text-sm text-gray-600 line-clamp-2">{description}</p>

      <div className="flex flex-wrap items-center gap-3">
        <TierBadge tier={tier} />
        {metadata?.map((m) => (
          <span
            key={m.label}
            className="text-xs text-gray-500"
          >
            <span className="font-medium text-gray-600">{m.label}:</span>{" "}
            {m.value}
          </span>
        ))}
      </div>
    </Link>
  );
}
