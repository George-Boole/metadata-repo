# Checkpoint — 2026-03-16 (Stardog Integration)

## Goal
Add Stardog Cloud Free as a **full parallel graph backend** alongside Neo4j. Every source ingested (past and future) flows to both Neo4j and Stardog. UI exposes Stardog as a switchable view. Purpose: demonstrate to leadership "we evaluated Stardog too."

## Stardog Credentials (in .env.local)
- Endpoint: `https://sd-77eaf0c0.stardog.cloud:5820`
- Database: `metadata-repo` (already created, online)
- Username: `greg@nolders.com`
- Password: in `.env.local`

## Implementation Plan

### Phase 1: Stardog Client & RDF Mapping
1. `npm install stardog` (official JS client)
2. Create `src/lib/stardog.ts` — singleton connection, `runQuery()` helper (mirrors `neo4j.ts` pattern)
3. Create `src/lib/ingest/stardog-write.ts` — converts ExtractionResult to RDF triples and writes via SPARQL UPDATE
   - Entity → `<daf:entity/{name}> rdf:type <daf:{type}>; skos:prefLabel "{name}"; skos:altLabel "{alias}"`
   - RELATES_TO → `<daf:entity/{from}> <daf:rel/{relType}> <daf:entity/{to}>`
   - MENTIONS → `<daf:source/{sourceId}> dcterms:references <daf:entity/{name}>`
4. Create `src/lib/rag/stardog-search.ts` — SPARQL-based graph search (mirrors `graph-search.ts`)

### Phase 2: Pipeline Integration
5. Modify `src/lib/ingest/pipeline.ts`:
   - After step 8 (Neo4j Source node), add step 8b: create Stardog Source triple
   - After step 9 (Neo4j graph extraction), add step 9b: call `writeToStardog()`
   - Both Stardog steps are non-fatal (try/catch, log errors)
6. Modify `src/lib/ingest/graph-write.ts` — add `writeToStardog()` call after `writeToGraph()`

### Phase 3: Bulk Sync Script
7. Create `scripts/sync-to-stardog.ts` — one-time migration:
   - Read all Entity/Source/RELATES_TO/MENTIONS from Neo4j
   - Convert to RDF triples
   - Batch-insert into Stardog
   - Run via `npx tsx scripts/sync-to-stardog.ts`

### Phase 4: Hybrid Retriever Integration
8. Modify `src/lib/rag/hybrid-retriever.ts` — add optional Stardog graph search alongside Neo4j
9. Modify `src/lib/rag/graph-search.ts` — add `stardogGraphSearch()` function using SPARQL
10. Add admin setting: graph backend toggle (Neo4j / Stardog / Both)

### Phase 5: UI — Stardog Explorer Page
11. Create `src/app/knowledge-graph/page.tsx` — tabbed view:
    - Tab 1: Neo4j view (existing graph data)
    - Tab 2: Stardog view (SPARQL query results)
    - Tab 3: Comparison (side-by-side stats, query results)
12. Add nav link in sidebar/header
13. Optional: force-directed graph visualization using a lightweight library

### Phase 6: Admin Panel Updates
14. Add Stardog section to admin settings:
    - Connection status indicator
    - Sync status (last sync, entity/triple counts)
    - Manual "Sync Now" button
    - Graph backend selector for RAG queries

## File Map (new files)
- `src/lib/stardog.ts` — client singleton
- `src/lib/ingest/stardog-write.ts` — RDF write layer
- `src/lib/rag/stardog-search.ts` — SPARQL search
- `src/app/knowledge-graph/page.tsx` — explorer UI
- `src/app/api/admin/stardog/route.ts` — status/sync API
- `scripts/sync-to-stardog.ts` — bulk migration

## File Map (modified files)
- `src/lib/ingest/pipeline.ts` — add Stardog write steps
- `src/lib/rag/hybrid-retriever.ts` — add Stardog search option
- `src/lib/rag/graph-search.ts` — add SPARQL search function
- `src/app/admin/page.tsx` — add Stardog settings section
- `src/components/nav*.tsx` or layout — add Knowledge Graph nav link
- `package.json` — add `stardog` dependency
- `.env.example` — add STARDOG_* vars

## What's Done
- [x] Stardog Cloud Free account created
- [x] Database `metadata-repo` created and online
- [x] Credentials added to `.env.local`
- [x] Codebase analyzed — all integration points identified
- [ ] Phase 1: Client & RDF mapping
- [ ] Phase 2: Pipeline integration
- [ ] Phase 3: Bulk sync script
- [ ] Phase 4: Hybrid retriever
- [ ] Phase 5: Knowledge Graph UI
- [ ] Phase 6: Admin panel updates

## Next Steps (if context resets)
1. Read CLAUDE.md, this CHECKPOINT.md
2. Start with Phase 1 — install `stardog`, create `src/lib/stardog.ts`
3. Work through phases sequentially (1→6)
4. Run `npm run build` after each phase to verify
5. Run bulk sync (Phase 3) after Phase 2 is complete
6. Commit after each phase
