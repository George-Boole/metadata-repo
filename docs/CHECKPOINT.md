# Checkpoint — 2026-03-01 (Session 10, paused)

## Current State
Phase 1 (auth + database foundation) is complete. Auth gate, Supabase schema, and Neo4j driver are all in place. Build passes clean (48 pages). Pushed to GitHub, Vercel auto-deploying.

## What's Done
- All env vars set in `.env.local` and pushed to Vercel production
- `.env.local.bak` backup exists
- Cookie-based shared password auth (middleware + login page + API route)
- Supabase: sources, chunks (pgvector 512-dim), app_settings tables + match_chunks() RPC
- Neo4j: driver singleton + /api/setup/neo4j schema initialization endpoint
- NPM packages: ai SDK, Supabase client, Neo4j driver, zod

## Critical Decision: No Fictional Data
User explicitly decided: **only real data goes into databases**. The static JSON files contain:
- **REAL**: Tier 1 guidance, Tier 2A specs, Tier 3 tools, JDO/OWL2/LOV ontologies
- **FICTIONAL**: All 6 Tier 2B domain profiles, "DAF Data Fabric Ontology"
- **AI-WRITTEN**: All descriptions/summaries are paraphrases, not authoritative text

Do NOT seed AI-generated descriptions as RAG content. Real content comes from crawling authoritative websites.

## Next Session Plan
Skip Phase 2 (seeding static JSON) and Phase 3/4 (RAG chat) for now. Instead:

1. **Build ingestion pipeline first** (Phase 5 from plan):
   - Firecrawl/Jina web crawler
   - Type-aware parsers (HTML, PDF, XML)
   - Token-counted chunker with overlap
   - OpenAI embedding generation
   - Pipeline orchestrator: crawl → parse → chunk → embed → store in Supabase + Neo4j

2. **Build RAG chat** (Phase 3/4):
   - Vector search via match_chunks()
   - Graph-enhanced hybrid retrieval
   - Streaming chat with Vercel AI SDK
   - Replace mock Standards Brain with real chat

3. **Build admin panel** (Phase 6):
   - Add source by URL
   - Trigger ingestion
   - Model selector
   - Source management

4. **Ingest real content** (Phase 7):
   - Crawl ODNI spec pages from manifest URLs
   - Crawl NIEM, Dublin Core, W3C, DoD guidance URLs

## Implementation Plan
`C:\Users\greg\.claude\plans\gentle-sleeping-kite.md` — full 8-phase plan (Phase 2 will be modified to skip fictional data)

## Accounts & Infrastructure
- **Vercel**: Project deployed, env vars set, auto-deploys from GitHub main
- **Supabase**: "DAF Prototypes" org, project "daf-metadata-repo" (ref: wxqrlpefradsbsunpiio), schema created
- **Neo4j AuraDB**: Account exists, instance running, driver configured (schema not yet initialized — needs POST to /api/setup/neo4j after deploy)
- **API Keys**: All set in .env.local and Vercel (Anthropic, OpenAI, Google AI, Firecrawl)
