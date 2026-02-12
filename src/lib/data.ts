import type {
  GuidanceDocument,
  TechnicalSpec,
  DomainProfile,
  TaggingTool,
  Artifact,
} from "@/types";

import guidanceData from "@/data/guidance.json";
import specsData from "@/data/specs.json";
import profilesData from "@/data/profiles.json";
import toolsData from "@/data/tools.json";

/* ── Typed getters for each tier ────────────────────────────── */

export function getGuidance(): GuidanceDocument[] {
  return guidanceData as GuidanceDocument[];
}

export function getSpecs(): TechnicalSpec[] {
  return specsData as TechnicalSpec[];
}

export function getProfiles(): DomainProfile[] {
  return profilesData as DomainProfile[];
}

export function getTools(): TaggingTool[] {
  return toolsData as TaggingTool[];
}

/* ── Single-item lookups by ID ──────────────────────────────── */

export function getGuidanceById(id: string): GuidanceDocument | undefined {
  return getGuidance().find((g) => g.id === id);
}

export function getSpecById(id: string): TechnicalSpec | undefined {
  return getSpecs().find((s) => s.id === id);
}

export function getProfileById(id: string): DomainProfile | undefined {
  return getProfiles().find((p) => p.id === id);
}

export function getToolById(id: string): TaggingTool | undefined {
  return getTools().find((t) => t.id === id);
}

/* ── Cross-reference lookups ────────────────────────────────── */

export function getRelatedSpecs(guidanceId: string): TechnicalSpec[] {
  return getSpecs().filter((s) =>
    s.relatedGuidanceIds.includes(guidanceId)
  );
}

export function getRelatedGuidance(specId: string): GuidanceDocument[] {
  const spec = getSpecById(specId);
  if (!spec) return [];
  return spec.relatedGuidanceIds
    .map((id) => getGuidanceById(id))
    .filter((g): g is GuidanceDocument => g !== undefined);
}

export function getRelatedProfiles(specId: string): DomainProfile[] {
  return getProfiles().filter((p) =>
    p.incorporatedSpecs.some((s) => s.specId === specId)
  );
}

export function getSpecsForProfile(profileId: string): TechnicalSpec[] {
  const profile = getProfileById(profileId);
  if (!profile) return [];
  return profile.incorporatedSpecs
    .map((s) => getSpecById(s.specId))
    .filter((s): s is TechnicalSpec => s !== undefined);
}

export function getToolsForSpec(specId: string): TaggingTool[] {
  return getTools().filter((t) => t.supportedSpecIds.includes(specId));
}

export function getSubSpecs(parentSpecId: string): TechnicalSpec[] {
  return getSpecs().filter((s) => s.parentSpecId === parentSpecId);
}

/* ── Union of all artifacts (for global search) ─────────────── */

export function getAllArtifacts(): Artifact[] {
  return [
    ...getGuidance(),
    ...getSpecs(),
    ...getProfiles(),
    ...getTools(),
  ];
}
