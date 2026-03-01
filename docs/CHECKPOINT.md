# Checkpoint — 2026-03-01 (Session 9, paused)

## Current State
Phase 0 account setup was nearly complete from the crashed Session 8 continuation. All 12 env vars had been filled in `.env.local`. However, running `vercel link` in Session 9 **overwrote `.env.local`**, wiping all keys. The template has been restored but keys need to be re-entered.

## What Needs to Happen Before Coding
1. **Restore `.env.local` keys** — either via OneDrive version history (right-click → OneDrive → Version history) or by re-copying from each service dashboard
2. **Set SITE_PASSWORD** — user chooses a shared demo password
3. **Push env vars to Vercel** — `vercel env add` or via Vercel dashboard
4. Then Phase 1 can begin

## Accounts That Exist (all created in crashed Session 8 continuation)
- **Vercel**: Project "metadata-repo" deployed, linked locally, auto-deploys from GitHub main. Team: greg-nolders-projects. NO env vars set on Vercel yet.
- **Supabase**: "DAF Prototypes" org, project "daf-metadata-repo" (ref: wxqrlpefradsbsunpiio). RLS enabled. New key format: sb_publishable_ / sb_secret_. NOTE: Supabase MCP only has permission to TherapyTracker org — cannot pull DAF keys via MCP.
- **Neo4j AuraDB**: Account created (GitHub auth), instance created with URI and password (lost in .env.local wipe)
- **Anthropic**: API key created (lost in wipe)
- **OpenAI**: API key created (lost in wipe)
- **Google AI**: API key created (lost in wipe)
- **Firecrawl**: Account + API key created (lost in wipe)

## Where to Re-grab Keys
| Key | Source |
|-----|--------|
| NEXT_PUBLIC_SUPABASE_URL | `https://wxqrlpefradsbsunpiio.supabase.co` |
| NEXT_PUBLIC_SUPABASE_ANON_KEY | supabase.com → DAF Prototypes → daf-metadata-repo → Settings → API |
| SUPABASE_SERVICE_ROLE_KEY | supabase.com → DAF Prototypes → daf-metadata-repo → Settings → API |
| NEO4J_URI | console.neo4j.io → instance → Connect dropdown |
| NEO4J_PASSWORD | console.neo4j.io (may need to reset if not saved elsewhere) |
| ANTHROPIC_API_KEY | console.anthropic.com → API Keys (may need new key if old one wasn't saved) |
| OPENAI_API_KEY | platform.openai.com → API Keys (may need new key) |
| GOOGLE_GENERATIVE_AI_API_KEY | aistudio.google.com → Get API Key |
| FIRECRAWL_API_KEY | firecrawl.dev → Dashboard → API Keys |
| AUTH_SECRET | Already filled: 261bc3ccafc50a05a56e87ae81ad8863b8ba4ac34b192e7f02072235f88963e5 |
| SITE_PASSWORD | User's choice |

## .env.local Template Status
- File restored with all 12 variable names
- AUTH_SECRET is filled
- All other values are empty, awaiting user re-entry

## Vercel Link Status
- Local repo is now linked to Vercel project (`.vercel/project.json` exists)
- Team: greg-nolders-projects, Project: metadata-repo
- No env vars on Vercel yet

## After .env.local Is Restored — Next Steps
1. Push all env vars to Vercel (`vercel env add` or dashboard)
2. Start Phase 1: Auth + database foundation
   - Next.js middleware for shared password auth
   - Supabase tables (sources, chunks with pgvector, app_settings)
   - Neo4j graph schema (Standard, Guidance, Profile, Tool, Ontology nodes)
   - match_chunks RPC function

## Implementation Plan Location
`C:\Users\greg\.claude\plans\gentle-sleeping-kite.md` — full 8-phase plan

## Lesson Learned
**NEVER run `vercel link` when `.env.local` has values** — it overwrites the file with Vercel's (potentially empty) dev environment. Always back up `.env.local` first, or use `vercel link --yes` without the env pull.
