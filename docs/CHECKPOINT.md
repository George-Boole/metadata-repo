# Checkpoint — 2026-03-16 (Stardog Integration)

## Goal
Add Stardog Cloud Free as a **full parallel graph backend** alongside Neo4j. Every source ingested (past and future) flows to both Neo4j and Stardog. UI exposes a Knowledge Graph Explorer page with interactive graph visualization, platform comparison, and SPARQL query interface.

## Current Status: Partially Complete — Needs Resume

### FIRST THING TO DO WHEN RESUMING
1. **Add Stardog env vars to Vercel** — this is blocking Stardog from working on the live site:
   - Go to: https://vercel.com/greg-nolders-projects/metadata-repo/settings/environment-variables
   - Add these 4 vars (all environments):
     - `STARDOG_ENDPOINT` = `https://sd-77eaf0c0.stardog.cloud:5820`
     - `STARDOG_DATABASE` = `metadata-repo`
     - `STARDOG_USERNAME` = `greg@nolders.com`
     - `STARDOG_PASSWORD` = (in `.env.local`)
   - Redeploy after adding

### What's Done
- [x] Stardog Cloud Free account created, database `metadata-repo` online
- [x] Credentials in `.env.local` (instance user `greg@nolders.com`, password changed via Studio)
- [x] `stardog` npm package installed, client singleton at `src/lib/stardog.ts`
- [x] RDF write layer (`src/lib/ingest/stardog-write.ts`) — converts ExtractionResult to triples
- [x] SPARQL graph search (`src/lib/rag/stardog-search.ts`) — mirrors Neo4j graph-search
- [x] Ingestion pipeline wired — all 3 paths (URL, file, ZIP) auto-sync to both Neo4j + Stardog
- [x] Hybrid retriever queries both graph backends in parallel
- [x] Bulk sync script ran — **50,734 triples** loaded into Stardog from Neo4j
- [x] Knowledge Graph Explorer page (`/knowledge-graph`) with 4 tabs:
  - Graph Visualization (interactive force-directed, toggle Neo4j/Stardog)
  - Platform Comparison (side-by-side table)
  - SPARQL Explorer (run queries against Stardog from within the app)
  - Neo4j Stats
- [x] Admin dashboard shows Stardog connection status + triple counts
- [x] Nav bar has "Knowledge Graph" link
- [x] Public API routes at `/api/graph/*` (not admin-gated)
- [x] `isStardogConfigured()` defensive check prevents crashes when env vars missing
- [x] `.env.example` created with all vars
- [x] GitHub deploy key set up for metadata-repo (`~/.ssh/id_ed25519_metadata`, alias `github-metadata`)
- [x] Remote switched to SSH (`git@github-metadata:George-Boole/metadata-repo.git`)
- [x] Removed external "Open Stardog Studio" link (users don't have credentials)
- [x] Two commits pushed to main, Vercel auto-deployed

### What's In Progress (agents were running when session paused)
- [ ] **Graph visualization improvements** — bigger nodes, hover highlighting, better labels, thicker links
- [ ] **Admin toggle** — setting in admin panel to show/hide Stardog features on public site. Agent was modifying `src/app/admin/settings/page.tsx` and adding `/api/settings` route + `showStardog` state to knowledge-graph page
- [ ] **Stardog env vars on Vercel** — cannot be done programmatically (no Vercel CLI auth on Mac), requires manual dashboard action

### What Remains After In-Progress Items
- [ ] Verify Stardog data shows on live site after env vars added
- [ ] Test SPARQL Explorer with real queries on production
- [ ] Test admin toggle hides/shows Stardog features correctly
- [ ] Update CLAUDE.md Current State section
- [ ] Update SESSION_LOG.md

## Stardog Credentials
- Endpoint: `https://sd-77eaf0c0.stardog.cloud:5820`
- Database: `metadata-repo`
- Instance user: `greg@nolders.com` (separate from portal login)
- Portal login: `greg@nolders.com` (different password than instance)
- Password: in `.env.local`

## Key Files Created
- `src/lib/stardog.ts` — client singleton + `isStardogConfigured()` guard
- `src/lib/ingest/stardog-write.ts` — RDF write layer
- `src/lib/rag/stardog-search.ts` — SPARQL search
- `src/app/knowledge-graph/page.tsx` — explorer UI (4 tabs + graph viz)
- `src/app/api/graph/stardog/route.ts` — public stats API
- `src/app/api/graph/stardog/data/route.ts` — graph data for visualization
- `src/app/api/graph/stardog/query/route.ts` — SPARQL query API (read-only)
- `src/app/api/graph/neo4j/route.ts` — Neo4j stats API
- `src/app/api/graph/neo4j/data/route.ts` — Neo4j graph data for viz
- `scripts/sync-to-stardog.ts` — bulk migration (already run)
- `.env.example` — all env var templates

## Key Files Modified
- `src/lib/ingest/pipeline.ts` — Stardog write steps in all 3 ingest paths
- `src/lib/rag/hybrid-retriever.ts` — parallel Stardog + Neo4j search
- `src/components/Navbar.tsx` — Knowledge Graph nav link
- `src/app/admin/page.tsx` — Stardog status section
- `src/app/api/setup/neo4j/route.ts` — added GET for stats
- `package.json` — `stardog` + `react-force-graph-2d` dependencies

## Architecture Notes
- Portal login (`cloud.stardog.com`) and instance credentials are **separate** — changing password in Studio only changes the instance user password
- Neo4j AuraDB Free auto-pauses after inactivity — must resume from https://console.neo4j.io
- Stardog Cloud Free limit: 25 queries/hour — SPARQL Explorer may hit this
- All Stardog pipeline steps are non-fatal (try/catch) — failures don't break ingestion
- `react-force-graph-2d` requires dynamic import with `ssr: false` (needs canvas/window)
