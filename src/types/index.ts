/** Hosting type for artifacts — stored locally or linked to external source */
export type HostingType = "stored" | "linked";

/** Base fields shared by all artifacts across tiers */
export interface BaseArtifact {
  id: string;
  title: string;
  description: string;
  status: "active" | "superseded" | "draft";
  hostingType: HostingType;
  externalUrl?: string; // present when hostingType is "linked"
  keywords: string[];
}

/** Tier 1 — Authoritative Guidance (DoDIs, memos, directives) */
export interface GuidanceDocument extends BaseArtifact {
  tier: "1";
  documentNumber: string; // e.g., "DoDI 8320.07"
  issuingAuthority: string; // e.g., "DoD CIO"
  issueDate: string;
  summary: string;
  relatedSpecIds: string[]; // links to Tier 2A
}

/** Tier 2A — Technical Specifications */
export interface TechnicalSpec extends BaseArtifact {
  tier: "2A";
  version: string;
  managingOrganization: string;
  category: string; // e.g., "Information Security Marking", "Data Exchange"
  elements?: string[]; // summary of key elements (for stored specs)
  relatedGuidanceIds: string[]; // links to Tier 1
  relatedProfileIds: string[]; // links to Tier 2B
  parentSpecId?: string; // for sub-specs (e.g., NIEM sub-specs → NIEM)
}

/** Tier 2B — Domain Profiles */
export interface DomainProfile extends BaseArtifact {
  tier: "2B";
  owningOrganization: string;
  domain: string; // e.g., "Intelligence Sharing", "Logistics"
  version: string;
  incorporatedSpecs: {
    specId: string;
    specName: string;
    elementsUsed: string[];
  }[];
}

/** Tier 3 — Tagging/Labeling Tools */
export interface TaggingTool extends BaseArtifact {
  tier: "3";
  vendor: string;
  capabilities: string[];
  supportedSpecIds: string[]; // links to Tier 2A
  licenseType: string;
  maturityLevel: "production" | "emerging" | "experimental";
  integrationNotes?: string;
}

/** Union type for any artifact */
export type Artifact = GuidanceDocument | TechnicalSpec | DomainProfile | TaggingTool;

/** Tier labels for display */
export const TIER_LABELS = {
  "1": "Authoritative Guidance",
  "2A": "Technical Specifications",
  "2B": "Domain Profiles",
  "3": "Tagging & Labeling Tools",
} as const;

export type TierId = keyof typeof TIER_LABELS;
