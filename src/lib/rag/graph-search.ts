import { runCypher } from "../neo4j";

/**
 * Pure function words that break phrase boundaries.
 * NOT domain terms — "data", "information", etc. stay in phrases.
 */
const PHRASE_BREAKERS = new Set([
  "the", "a", "an", "and", "or", "but", "in", "on", "at", "to", "for",
  "of", "with", "by", "from", "as", "is", "was", "are", "were", "be",
  "been", "being", "have", "has", "had", "do", "does", "did", "will",
  "would", "could", "should", "may", "might", "can", "shall", "about",
  "what", "which", "who", "whom", "this", "that", "these", "those",
  "how", "when", "where", "why", "not", "no", "nor", "so", "if",
  "then", "than", "too", "very", "just", "each", "every", "its", "it",
  "tell", "me", "us", "you", "my", "your", "his", "her", "our",
  "their", "them", "we", "they", "him", "she", "he",
]);

/** Words not useful as individual search terms (superset of phrase breakers) */
const SEARCH_STOPWORDS = new Set([
  ...PHRASE_BREAKERS,
  "know", "used", "using", "like", "make", "work", "need", "because",
  "all", "any", "both", "few", "more", "most", "other", "some", "such",
  "between", "through", "during", "before", "after", "above", "below",
  "up", "down", "out", "off", "over", "under", "again", "further",
  // Domain terms: too common as individual words, but fine inside phrases
  "spec", "specification", "standard", "document", "metadata",
  "information", "data", "mandate", "mandates", "reference", "references",
  "support", "supports", "implement", "implements", "describe", "describes",
  "relationship", "related", "relate", "relates", "connect", "connected",
  "use", "uses", "require", "requires", "define", "defines",
  "enterprise", "header", "format", "system", "service",
]);

/** Known standard name patterns for entity extraction from queries */
const STANDARD_PATTERNS = [
  /\bDoDI\s*\d{4}\.\d{2}\b/gi,
  /\bDoDD\s*\d{4}\.\d{2}\b/gi,
  /\bIC-[A-Z]{2,5}\b/gi,
  /\bNIEM\b/gi,
  /\bDDMS\b/gi,
  /\bDCAT\b/gi,
  /\bDublin\s*Core\b/gi,
  /\bISO\s*\d{4,5}(?:-\d+)?\b/gi,
  /\bOWL\s*2?\b/gi,
  /\bSKOS\b/gi,
  /\bGENC\b/gi,
  /\bDCAMPS-?C?\b/gi,
  /\bPurview\b/gi,
  /\bVaronis\b/gi,
  /\bCollibra\b/gi,
  /\bTitus\b/gi,
  /\bBoldon\s*James\b/gi,
  /\bOPSWAT\b/gi,
  /\bFortra\b/gi,
  /\bW3C\b/gi,
  /\bODNI\b/gi,
];

/** Max relationships to return (keeps prompt manageable) */
const MAX_RELATIONSHIPS = 30;

/** Extract entity names from a user query using regex patterns */
export function extractQueryEntities(query: string): string[] {
  const found: string[] = [];
  for (const pattern of STANDARD_PATTERNS) {
    const matches = query.match(pattern);
    if (matches) {
      for (const m of matches) {
        const normalized = m.trim();
        if (!found.some((f) => f.toLowerCase() === normalized.toLowerCase())) {
          found.push(normalized);
        }
      }
    }
  }
  return found;
}

/**
 * Extract search terms from a query in priority tiers:
 * 1. Acronyms (all-caps, 2-8 chars) — always specific enough
 * 2. Multi-word phrases (preserving original word sequence) — specific
 * 3. Individual long words (7+ chars) — fallback only
 *
 * Phrases use PHRASE_BREAKERS to split, preserving domain terms like
 * "Data", "Information", "Enterprise" that are part of entity names.
 */
function extractSearchTerms(query: string): {
  acronyms: string[];
  phrases: string[];
  words: string[];
} {
  const cleaned = query.replace(/[^a-zA-Z0-9\s-]/g, " ").trim();
  const allWords = cleaned.split(/\s+/).filter((w) => w.length >= 2);

  const acronyms: string[] = [];
  const phrases: string[] = [];
  const words: string[] = [];

  // Acronyms: all-caps 2-8 chars (EDH, ISM, TDF, GENC, NIEM)
  for (const w of allWords) {
    if (/^[A-Z][A-Z0-9-]{1,7}$/.test(w)) {
      acronyms.push(w);
    }
  }

  // Build phrases by splitting on PHRASE_BREAKERS (pure function words).
  // Domain terms like "Data", "Information" stay inside phrases.
  // "What does the Enterprise Data Header reference" → ["Enterprise Data Header"]
  const phraseSeqs: string[][] = [[]];
  for (const w of allWords) {
    if (PHRASE_BREAKERS.has(w.toLowerCase())) {
      if (phraseSeqs[phraseSeqs.length - 1].length > 0) {
        phraseSeqs.push([]);
      }
    } else {
      phraseSeqs[phraseSeqs.length - 1].push(w);
    }
  }

  for (const seq of phraseSeqs) {
    // Skip single-word sequences (handled by acronyms/words tiers)
    if (seq.length < 2) continue;
    // Full phrase
    phrases.push(seq.join(" "));
    // Also 2-word sliding windows for longer phrases
    if (seq.length > 2) {
      for (let i = 0; i < seq.length - 1; i++) {
        phrases.push(seq.slice(i, i + 2).join(" "));
      }
    }
  }

  // Individual words: only useful ones (not in search stopwords, 7+ chars)
  for (const w of allWords) {
    if (SEARCH_STOPWORDS.has(w.toLowerCase())) continue;
    if (/^[A-Z][A-Z0-9-]{1,7}$/.test(w)) continue; // already in acronyms
    if (w.length >= 7) {
      words.push(w);
    }
  }

  return {
    acronyms: [...new Set(acronyms)],
    phrases: [...new Set(phrases)],
    words: [...new Set(words)],
  };
}

/** Query Neo4j for entities matching search terms by name or alias */
async function resolveEntities(
  terms: string[],
): Promise<Array<{ name: string; type: string }>> {
  if (terms.length === 0) return [];
  return runCypher<{ name: string; type: string }>(
    `UNWIND $terms AS term
     MATCH (e:Entity)
     WHERE toLower(e.name) CONTAINS toLower(term)
        OR ANY(a IN e.aliases WHERE toLower(a) CONTAINS toLower(term))
     RETURN DISTINCT e.name AS name, e.type AS type
     LIMIT 15`,
    { terms },
  );
}

export interface GraphContext {
  entities: string[];
  relationships: Array<{
    from: string;
    relType: string;
    to: string;
    evidence?: string;
  }>;
  connectedSourceUrls: string[];
}

/**
 * Graph search with tiered entity resolution.
 * Priority: regex patterns → acronyms → phrases → individual words.
 * Stops expanding once enough entities are found.
 */
export async function graphSearch(query: string): Promise<GraphContext> {
  const regexEntities = extractQueryEntities(query);
  const { acronyms, phrases, words } = extractSearchTerms(query);

  if (regexEntities.length === 0 && acronyms.length === 0 && phrases.length === 0 && words.length === 0) {
    return { entities: [], relationships: [], connectedSourceUrls: [] };
  }

  try {
    // Tiered entity resolution: try most specific terms first
    let matchedNames: string[] = [];

    // Tier 1: Regex-extracted names + acronyms (always reliable)
    const tier1Terms = [...new Set([...regexEntities, ...acronyms])];
    if (tier1Terms.length > 0) {
      const results = await resolveEntities(tier1Terms);
      matchedNames = results.map((e) => e.name);
    }

    // Tier 2: Multi-word phrases (if tier 1 found fewer than 2 entities)
    if (matchedNames.length < 2 && phrases.length > 0) {
      const results = await resolveEntities(phrases);
      for (const r of results) {
        if (!matchedNames.includes(r.name)) matchedNames.push(r.name);
      }
    }

    // Tier 3: Individual words (only if nothing found yet)
    if (matchedNames.length === 0 && words.length > 0) {
      const results = await resolveEntities(words);
      matchedNames = results.map((e) => e.name);
    }

    if (matchedNames.length === 0) {
      return {
        entities: regexEntities,
        relationships: [],
        connectedSourceUrls: [],
      };
    }

    // Cap to top 10 entities to keep traversal manageable
    matchedNames = matchedNames.slice(0, 10);

    // 1-hop traversal from matched entities (capped)
    const relResults = await runCypher<{
      fromName: string;
      relType: string;
      toName: string;
      evidence: string | null;
    }>(
      `UNWIND $names AS entityName
       MATCH (e:Entity {name: entityName})-[r:RELATES_TO]-(related:Entity)
       RETURN e.name AS fromName, r.rel_type AS relType, related.name AS toName, r.evidence AS evidence
       LIMIT 100`,
      { names: matchedNames },
    );

    // Get source URLs connected to matched entities
    const sourceResults = await runCypher<{ url: string }>(
      `UNWIND $names AS entityName
       MATCH (e:Entity {name: entityName})<-[:MENTIONS]-(s:Source)
       RETURN DISTINCT s.url AS url
       LIMIT 20`,
      { names: matchedNames },
    );

    const relationships = relResults.map((r) => ({
      from: r.fromName,
      relType: r.relType,
      to: r.toName,
      evidence: r.evidence || undefined,
    }));

    // Deduplicate relationships (including reverse direction)
    const seen = new Set<string>();
    const uniqueRels = relationships.filter((r) => {
      const key = `${r.from}-${r.relType}-${r.to}`;
      const reverseKey = `${r.to}-${r.relType}-${r.from}`;
      if (seen.has(key) || seen.has(reverseKey)) return false;
      seen.add(key);
      return true;
    });

    // Cap total relationships for prompt size management
    const cappedRels = uniqueRels.slice(0, MAX_RELATIONSHIPS);

    return {
      entities: matchedNames,
      relationships: cappedRels,
      connectedSourceUrls: sourceResults.map((s) => s.url),
    };
  } catch (e) {
    console.warn("Graph search failed (non-fatal):", e);
    return { entities: regexEntities, relationships: [], connectedSourceUrls: [] };
  }
}
