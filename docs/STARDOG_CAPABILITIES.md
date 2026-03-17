# Stardog Capabilities in the DAF Metadata Repository

## Currently Leveraged Capabilities

### SPARQL 1.1 Query Execution
The app executes arbitrary SPARQL 1.1 queries against Stardog Cloud via the `stardog` npm package. The `runSparqlSelect()` function in `src/lib/stardog.ts` sends queries using `stardogQuery.execute()` and parses SPARQL JSON result bindings. The SPARQL Explorer tab on the Knowledge Graph page provides an interactive query editor with pre-built example queries.

### RDF Triple Storage (OWL/SKOS Vocabulary)
All ingested content is stored as RDF triples using a custom DAF ontology namespace (`https://daf-metadata.mil/ontology/`). Entities use `skos:prefLabel` and `skos:altLabel` for names and aliases, `rdf:type` for classification (Standard, Guidance, Tool, etc.), and `dct:references` for source-to-entity links. Relationships use a `daf:rel/` namespace. The write layer in `src/lib/ingest/stardog-write.ts` constructs `INSERT DATA` SPARQL updates with batching (200 triples per batch).

### OWL 2 RL Reasoning (Toggle in SPARQL Explorer)
The SPARQL Explorer tab includes an "Enable Reasoning" checkbox that passes `reasoning: true` to `runSparqlSelect()`. When enabled, Stardog's OWL 2 RL reasoning engine infers additional triples at query time. The `getDatabaseInfo()` function checks the database's `reasoning.type` option to determine if reasoning is available.

### Query Explain Plans
The `explainSparqlQuery()` function calls `stardogQuery.explain()` to retrieve the query execution plan. The SPARQL Explorer tab has a dedicated "Explain Plan" button that renders the plan in a formatted code block, showing cost analysis and execution strategy.

### SPARQL Property Paths (Path Finder Tab)
The Path Finder tab uses SPARQL 1.1 property path syntax (`{1,N}` repetition) to find multi-hop connections between entities. Users specify start and end entities by partial name match and a maximum hop count (1-5). The generated query uses transitive property path expressions over `daf:rel/RELATES_TO` relationships.

### Parallel Dual-Backend Architecture (Neo4j + Stardog)
Stardog runs alongside Neo4j as a parallel graph backend. The ingestion pipeline writes to both Neo4j (Cypher) and Stardog (SPARQL INSERT) simultaneously via `writeToStardog()` and `writeStardogSourceNode()`. The Graph Visualization tab lets users toggle between Neo4j and Stardog as the data source. An admin-controlled toggle (`show_stardog` setting) controls whether Stardog-specific tabs are visible.

### Hybrid RAG Retrieval (Vector + Neo4j Graph + Stardog Graph)
The hybrid retriever (`src/lib/rag/hybrid-retriever.ts`) runs vector search, Neo4j graph search, and Stardog graph search in parallel using `Promise.all`. The `stardogGraphSearch()` function in `src/lib/rag/stardog-search.ts` performs SPARQL-based entity matching (via `skos:prefLabel`/`skos:altLabel`), 1-hop relationship traversal, and connected source URL retrieval. Results from both graph backends are merged to boost source relevance scoring.

### Hub Analysis via SPARQL Aggregation
The Statistics tab runs a SPARQL aggregation query (`GROUP BY` with `COUNT`) to identify the most connected entities (hubs) in the graph. The query uses a `UNION` pattern to count both incoming and outgoing relationships per entity, ranked by connection count.

### Read-Only Query Safety
The `/api/graph/stardog/query` API route enforces read-only access by checking that the query starts with `SELECT`, `ASK`, `DESCRIBE`, or `CONSTRUCT`. Any write operations (`INSERT`, `DELETE`) submitted through the UI are rejected with a 403 status.

## Capabilities Available but Not Yet Used

### Named Graphs
Stardog supports named graphs for partitioning triples into separate contexts. This could be used to isolate triples by source, tier, or ingestion batch, enabling scoped queries and selective graph management.

### SHACL Validation
Stardog includes a SHACL (Shapes Constraint Language) engine for validating RDF data against shape constraints. This could enforce schema rules on ingested metadata -- for example, requiring that every entity has a `skos:prefLabel` or that sources include required fields.

### Full-Text Search
Stardog has built-in full-text search indexing (`search.enabled` option, already checked by `getDatabaseInfo()`). This could replace or supplement the current SPARQL `CONTAINS`/`FILTER` approach with indexed Lucene-style text search for better performance on entity lookups.

### Virtual Graphs
Stardog virtual graphs map external data sources (SQL databases, CSV, JSON) into the RDF graph without copying data. This could connect directly to Supabase or other relational stores, enabling SPARQL queries that span both native triples and external data.

### Stored Functions
Custom stored functions can extend SPARQL with user-defined logic. This could be used to implement domain-specific scoring or normalization functions callable directly within SPARQL queries.

### GraphQL over SPARQL
Stardog can expose a GraphQL API backed by the SPARQL endpoint. This could provide a more developer-friendly query interface for frontend components that don't need full SPARQL expressiveness.

### Transaction Management
The `stardog` npm package exposes transaction APIs for multi-step read-write operations with rollback support. This could improve ingestion reliability by wrapping batch triple inserts in explicit transactions.

### Database Options Management
The `stardogDb.options` API (partially used by `getDatabaseInfo()`) provides full control over database configuration -- reasoning profiles, search indexing, namespaces, and performance tuning. Currently only read for status checks; could be used for runtime configuration changes.
