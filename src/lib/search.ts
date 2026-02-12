import type { Artifact, GuidanceDocument, TechnicalSpec, DomainProfile, TaggingTool } from "@/types";
import { getAllArtifacts } from "@/lib/data";

export interface SearchResult {
  artifact: Artifact;
  score: number;
  matchedFields: string[];
}

/**
 * Search all artifacts across tiers. Returns results sorted by score descending.
 * Scoring: exact title match (100), title contains (60), documentNumber/vendor exact (50),
 * keyword exact (40), description contains (20), other fields (10).
 */
export function searchArtifacts(query: string): SearchResult[] {
  const q = query.toLowerCase().trim();
  if (!q) return [];

  const artifacts = getAllArtifacts();
  const results: SearchResult[] = [];

  for (const artifact of artifacts) {
    let score = 0;
    const matchedFields: string[] = [];
    const titleLower = artifact.title.toLowerCase();

    // Exact title match (highest)
    if (titleLower === q) {
      score += 100;
      matchedFields.push("title");
    } else if (titleLower.includes(q)) {
      score += 60;
      matchedFields.push("title");
    }

    // Description contains
    if (artifact.description.toLowerCase().includes(q)) {
      score += 20;
      if (!matchedFields.includes("description")) matchedFields.push("description");
    }

    // Keywords — exact keyword match
    for (const kw of artifact.keywords) {
      if (kw.toLowerCase() === q) {
        score += 40;
        if (!matchedFields.includes("keywords")) matchedFields.push("keywords");
        break;
      } else if (kw.toLowerCase().includes(q)) {
        score += 25;
        if (!matchedFields.includes("keywords")) matchedFields.push("keywords");
        break;
      }
    }

    // Type-specific fields
    switch (artifact.tier) {
      case "1": {
        const g = artifact as GuidanceDocument;
        if (g.documentNumber.toLowerCase().includes(q)) {
          score += 50;
          matchedFields.push("documentNumber");
        }
        if (g.issuingAuthority.toLowerCase().includes(q)) {
          score += 10;
          matchedFields.push("issuingAuthority");
        }
        if (g.summary.toLowerCase().includes(q)) {
          score += 10;
          matchedFields.push("summary");
        }
        break;
      }
      case "2A": {
        const s = artifact as TechnicalSpec;
        if (s.managingOrganization.toLowerCase().includes(q)) {
          score += 10;
          matchedFields.push("managingOrganization");
        }
        if (s.category.toLowerCase().includes(q)) {
          score += 15;
          matchedFields.push("category");
        }
        if (s.elements?.some((e) => e.toLowerCase().includes(q))) {
          score += 10;
          matchedFields.push("elements");
        }
        break;
      }
      case "2B": {
        const p = artifact as DomainProfile;
        if (p.owningOrganization.toLowerCase().includes(q)) {
          score += 10;
          matchedFields.push("owningOrganization");
        }
        if (p.domain.toLowerCase().includes(q)) {
          score += 15;
          matchedFields.push("domain");
        }
        break;
      }
      case "3": {
        const t = artifact as TaggingTool;
        if (t.vendor.toLowerCase().includes(q)) {
          score += 50;
          matchedFields.push("vendor");
        }
        if (t.capabilities.some((c) => c.toLowerCase().includes(q))) {
          score += 10;
          matchedFields.push("capabilities");
        }
        if (t.licenseType.toLowerCase().includes(q)) {
          score += 10;
          matchedFields.push("licenseType");
        }
        break;
      }
    }

    if (score > 0) {
      results.push({ artifact, score, matchedFields });
    }
  }

  return results.sort((a, b) => b.score - a.score);
}
