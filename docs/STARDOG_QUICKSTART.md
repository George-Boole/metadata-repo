# Stardog Cloud Quick-Start: DAF Metadata Repository

This tutorial walks through exploring the **metadata-repo** Stardog Cloud Free database, which contains ~50,734 triples representing a DoD/IC metadata standards knowledge graph.

**Time estimate**: ~45 minutes total

**Prerequisites**: A Stardog Cloud Free account at [cloud.stardog.com](https://cloud.stardog.com)

---

## Namespace Reference

| Prefix | URI |
|--------|-----|
| `daf:` | `https://daf-metadata.mil/ontology/` |
| `daf:rel/` | Relationship predicates (e.g., `daf:rel/RELATES_TO`) |
| `dcterms:` | `http://purl.org/dc/terms/` |
| `skos:` | `http://www.w3.org/2004/02/skos/core#` |

**Entity types**: Standard, Guidance, Tool, Profile, Ontology, Organization, Entity

**Labels**: `skos:prefLabel` (canonical name), `skos:altLabel` (aliases)

**Source linkage**: Source nodes use `dcterms:references` to connect to entities they mention.

---

## Part 1: Navigate Stardog Studio (5 min)

### 1.1 Log In

1. Go to [cloud.stardog.com](https://cloud.stardog.com) and sign in.
2. You will land on the **Dashboard**, which shows your databases and endpoint details.

### 1.2 Open Studio

1. Click **Studio** in the left navigation bar (or top menu, depending on layout).
2. Studio is the built-in SPARQL query editor and visual explorer.

### 1.3 Select the Database

1. In Studio, locate the **database selector** dropdown (usually top-left of the query editor area).
2. Select **metadata-repo** from the list.
3. If you do not see it, return to the Dashboard and confirm the database exists and is online.

### 1.4 Studio Layout

- **Sidebar (left)**: Database selector, saved queries, recent queries, and navigation to other tools (Explorer, Designer).
- **Query Editor (center)**: A text area where you write and edit SPARQL queries. Supports syntax highlighting and auto-complete for prefixes.
- **Results Panel (bottom)**: Displays query results in table format by default. A toggle lets you switch between **Table**, **Graph**, and **JSON** views for applicable query types.
- **Run Button**: Located above the query editor (or use `Ctrl+Enter` / `Cmd+Enter` to execute).

---

## Part 2: SPARQL Queries (20 min)

Paste each query into the Studio query editor and click **Run** (or press `Cmd+Enter`).

All queries below include the necessary prefix declarations. Studio may auto-complete some prefixes, but including them explicitly avoids errors.

### Query 1: Count All Triples

Get the total size of the graph.

```sparql
SELECT (COUNT(*) AS ?tripleCount)
WHERE {
  ?s ?p ?o .
}
```

Expected result: approximately **50,734** triples.

---

### Query 2: Entity Types and Counts

See what types of entities exist and how many of each.

```sparql
PREFIX daf: <https://daf-metadata.mil/ontology/>

SELECT ?type (COUNT(?entity) AS ?count)
WHERE {
  ?entity a ?type .
  FILTER(STRSTARTS(STR(?type), STR(daf:)))
}
GROUP BY ?type
ORDER BY DESC(?count)
```

This returns types like `daf:Standard`, `daf:Source`, `daf:Guidance`, `daf:Entity`, etc., along with their counts.

---

### Query 3: Browse Entities with Name and Type

List entities with their labels and types, excluding Source nodes (which are ingestion metadata, not domain entities).

```sparql
PREFIX daf: <https://daf-metadata.mil/ontology/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT ?entity ?name ?type
WHERE {
  ?entity a ?type ;
          skos:prefLabel ?name .
  FILTER(?type != daf:Source)
  FILTER(STRSTARTS(STR(?type), STR(daf:)))
}
ORDER BY ?type ?name
LIMIT 25
```

Scroll through the results to get a feel for the data. Increase the `LIMIT` or remove it to see more.

---

### Query 4: Search for a Specific Standard

Find all information about NIEM (National Information Exchange Model).

```sparql
PREFIX daf: <https://daf-metadata.mil/ontology/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT ?entity ?label ?type ?predicate ?value
WHERE {
  ?entity skos:prefLabel|skos:altLabel ?label .
  FILTER(CONTAINS(LCASE(?label), "niem"))
  ?entity a ?type .
  ?entity ?predicate ?value .
}
ORDER BY ?entity ?predicate
LIMIT 100
```

**Try substituting** these search terms in the `FILTER` line:
- `"ic-ism"` -- Intelligence Community Information Security Marking
- `"dublin core"` -- Dublin Core Metadata Element Set
- `"iso 11179"` -- ISO/IEC 11179 Metadata Registries
- `"dodi 8320"` -- DoD Instruction 8320 series

---

### Query 5: Find Relationships Between Entities (1-Hop)

Show direct relationships between entities, with human-readable names.

```sparql
PREFIX daf: <https://daf-metadata.mil/ontology/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT ?fromName ?relationship ?toName
WHERE {
  ?from ?rel ?to .
  ?from skos:prefLabel ?fromName .
  ?to skos:prefLabel ?toName .
  FILTER(STRSTARTS(STR(?rel), "https://daf-metadata.mil/ontology/rel/"))
  FILTER(?from != ?to)
}
ORDER BY ?fromName ?relationship
LIMIT 50
```

This reveals how standards relate to each other -- for example, which specs reference or depend on other specs.

---

### Query 6: Which Sources Mention a Specific Entity

Find all ingested sources that reference IC-ISM.

```sparql
PREFIX daf: <https://daf-metadata.mil/ontology/>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT ?sourceName ?sourceUrl ?entityLabel
WHERE {
  ?entity skos:prefLabel|skos:altLabel ?entityLabel .
  FILTER(CONTAINS(LCASE(?entityLabel), "ic-ism"))
  ?source dcterms:references ?entity ;
          a daf:Source ;
          skos:prefLabel ?sourceName .
  OPTIONAL { ?source daf:url ?sourceUrl . }
}
ORDER BY ?sourceName
```

This is useful for tracing which documents discuss a particular standard -- the graph equivalent of a citation index.

---

### Query 7: Most Connected Entities (Hub Analysis)

Find the entities with the most relationships -- these are the "hubs" of the knowledge graph.

```sparql
PREFIX daf: <https://daf-metadata.mil/ontology/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT ?name ?type (COUNT(?related) AS ?connections)
WHERE {
  {
    ?entity ?rel ?related .
    FILTER(STRSTARTS(STR(?rel), "https://daf-metadata.mil/ontology/rel/"))
  }
  UNION
  {
    ?related ?rel ?entity .
    FILTER(STRSTARTS(STR(?rel), "https://daf-metadata.mil/ontology/rel/"))
  }
  ?entity skos:prefLabel ?name ;
          a ?type .
  FILTER(STRSTARTS(STR(?type), STR(daf:)))
  FILTER(?type != daf:Source)
}
GROUP BY ?name ?type
ORDER BY DESC(?connections)
LIMIT 20
```

Expect to see foundational standards like IC-ISM, NIEM, and IC-TDF near the top.

---

### Query 8: Two-Hop Paths Between Entities

Discover indirect connections -- entities linked through an intermediary.

```sparql
PREFIX daf: <https://daf-metadata.mil/ontology/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT ?startName ?midName ?endName
WHERE {
  ?start skos:prefLabel ?startName .
  ?mid skos:prefLabel ?midName .
  ?end skos:prefLabel ?endName .

  ?start ?rel1 ?mid .
  ?mid ?rel2 ?end .

  FILTER(STRSTARTS(STR(?rel1), "https://daf-metadata.mil/ontology/rel/"))
  FILTER(STRSTARTS(STR(?rel2), "https://daf-metadata.mil/ontology/rel/"))
  FILTER(?start != ?mid && ?mid != ?end && ?start != ?end)
}
LIMIT 25
```

This reveals transitive connections -- for instance, how a DoD instruction connects to a technical spec through an intermediate standard.

---

## Part 3: Visual Exploration (10 min)

### 3.1 CONSTRUCT Query for Graph View

Studio can render SPARQL `CONSTRUCT` results as an interactive graph. Paste this query and run it:

```sparql
PREFIX daf: <https://daf-metadata.mil/ontology/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

CONSTRUCT {
  ?from ?rel ?to .
  ?from skos:prefLabel ?fromName .
  ?to skos:prefLabel ?toName .
}
WHERE {
  ?from ?rel ?to .
  ?from skos:prefLabel ?fromName .
  ?to skos:prefLabel ?toName .
  FILTER(STRSTARTS(STR(?rel), "https://daf-metadata.mil/ontology/rel/"))
}
LIMIT 100
```

### 3.2 Switch to Graph View

1. After running the `CONSTRUCT` query, look at the **results panel** at the bottom.
2. Click the **Graph** tab (or the graph icon toggle) to switch from the default table view.
3. Studio renders the triples as an interactive node-link diagram.
4. **Drag nodes** to rearrange the layout.
5. **Click a node** to see its properties in a side panel.
6. Adjust the `LIMIT` value to control graph density. Start with 100 and increase if your browser handles it smoothly.

### 3.3 Explorer

If available in your Studio version:

1. Click **Explorer** in the sidebar.
2. Search for an entity by name (e.g., "NIEM").
3. Explorer shows the entity's properties and connections in a navigable tree/graph view.
4. Click connected entities to traverse the graph interactively without writing SPARQL.

### 3.4 Database Overview

1. Return to the **Dashboard** or click the database name in Studio.
2. The overview page shows triple count, named graphs, namespaces, and database configuration.
3. Check the **Namespaces** section to confirm `daf:` is registered, which enables prefix auto-completion in the query editor.

---

## Part 4: Advanced Features (10 min)

### 4.1 Reasoning / Inference

Stardog supports OWL reasoning, which can infer additional triples at query time.

1. In Studio, look for the **Reasoning** toggle (often a switch or dropdown near the query editor).
2. Set reasoning level to **SL** (Stardog default level) to enable basic RDFS and OWL inference.
3. Re-run a query and compare results -- you may see additional type assertions and transitive relationships that are not explicitly stored.
4. Turn reasoning off for exact-match queries where you only want explicitly asserted triples.

### 4.2 Named Graphs

Triples can be organized into named graphs for provenance or partitioning.

```sparql
SELECT DISTINCT ?graph (COUNT(*) AS ?triples)
WHERE {
  GRAPH ?graph { ?s ?p ?o . }
}
GROUP BY ?graph
ORDER BY DESC(?triples)
```

If all data is in the default graph, this query will return no results -- that is normal for a single-graph dataset.

### 4.3 Full-Text Search (textMatch)

Stardog provides a built-in full-text search function for matching text in literal values.

```sparql
PREFIX daf: <https://daf-metadata.mil/ontology/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX fts: <tag:stardog:api:search:>

SELECT ?entity ?label ?score
WHERE {
  ?entity a ?type .
  FILTER(STRSTARTS(STR(?type), STR(daf:)))
  (?entity ?score) fts:textMatch ("metadata registry" 0.5) .
  ?entity skos:prefLabel ?label .
}
ORDER BY DESC(?score)
LIMIT 20
```

The second argument (`0.5`) is the minimum similarity threshold (0.0 to 1.0). Lower values return more results.

**Note**: Full-text search indexes must be enabled on the database. If this query returns an error, the index may need to be created first via the database admin settings.

### 4.4 Property Paths (Transitive Closure)

SPARQL property paths let you traverse chains of relationships without specifying exact hop counts.

```sparql
PREFIX daf: <https://daf-metadata.mil/ontology/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT ?startName ?endName (COUNT(?mid) AS ?pathLength)
WHERE {
  ?start skos:prefLabel ?startName .
  FILTER(CONTAINS(LCASE(?startName), "niem"))

  ?start (<https://daf-metadata.mil/ontology/rel/RELATES_TO>)+ ?end .
  ?end skos:prefLabel ?endName .
  FILTER(?start != ?end)
}
GROUP BY ?startName ?endName
ORDER BY ?pathLength
LIMIT 25
```

- `+` means one or more hops (transitive closure).
- `*` means zero or more hops (includes the starting node).
- These are useful for reachability queries ("what can NIEM reach through any chain of RELATES_TO?").

### 4.5 GraphQL Support

Stardog supports GraphQL queries as an alternative to SPARQL. In Studio or via the API:

1. Navigate to the **GraphQL** section in Studio (if available).
2. GraphQL queries map to the RDF schema automatically.
3. This is useful for developers who prefer GraphQL syntax over SPARQL.

Consult the [Stardog GraphQL documentation](https://docs.stardog.com/query-stardog/graphql/) for schema mapping details.

### 4.6 Stored Queries

Save frequently used queries for reuse:

1. Write a query in the Studio editor.
2. Click **Save** (or the save icon) and give the query a name.
3. Saved queries appear in the sidebar under **Saved Queries** or **My Queries**.
4. Stored queries can also be shared with other users on the same Stardog instance.

---

## Cloud Free Tier Limits

The Stardog Cloud Free tier is suitable for prototyping and exploration with the following constraints:

| Limit | Detail |
|-------|--------|
| **Triple quota** | ~1 million triples per database |
| **High availability** | Not available (single instance only) |
| **Automated backups** | Not included; export data manually if needed |
| **LDAP / SSO** | Not available; local auth only |
| **Support** | Community support via forums and GitHub |
| **Databases** | Limited number of databases (typically 1-2) |
| **Compute** | Shared resources; query performance may vary |

The metadata-repo database at ~50,734 triples is well within the free tier quota.

---

## Quick Reference: SPARQL Keywords

| Keyword | Purpose | Example |
|---------|---------|---------|
| `SELECT` | Return variables as a table | `SELECT ?name ?type` |
| `CONSTRUCT` | Return RDF triples (enables graph view) | `CONSTRUCT { ?s ?p ?o }` |
| `WHERE` | Define the graph pattern to match | `WHERE { ?s ?p ?o }` |
| `FILTER` | Restrict results with a condition | `FILTER(CONTAINS(?name, "NIEM"))` |
| `OPTIONAL` | Include pattern if it matches, skip if not | `OPTIONAL { ?s daf:url ?url }` |
| `UNION` | Combine two patterns (logical OR) | `{ ?s ?p ?o } UNION { ?o ?p ?s }` |
| `BIND` | Assign a computed value to a variable | `BIND(STR(?uri) AS ?uriStr)` |
| `VALUES` | Inline data / parameter list | `VALUES ?type { daf:Standard daf:Guidance }` |
| `GROUP BY` | Aggregate results by variable | `GROUP BY ?type` |
| `ORDER BY` | Sort results | `ORDER BY DESC(?count)` |
| `LIMIT` | Cap the number of results | `LIMIT 25` |
| `OFFSET` | Skip results (for pagination) | `OFFSET 50` |
| `COUNT` | Count matching items | `(COUNT(?x) AS ?total)` |
| `DISTINCT` | Remove duplicate rows | `SELECT DISTINCT ?name` |
| `a` | Shorthand for `rdf:type` | `?entity a daf:Standard` |
| `PREFIX` | Declare a namespace alias | `PREFIX daf: <https://...>` |
| `STRSTARTS` | Test if string starts with a value | `FILTER(STRSTARTS(STR(?t), "https://..."))` |
| `CONTAINS` | Test if string contains a substring | `FILTER(CONTAINS(LCASE(?s), "niem"))` |
| `LCASE` | Convert string to lowercase | `LCASE(?label)` |
| `+` / `*` | Property path: one-or-more / zero-or-more hops | `?s daf:rel/RELATES_TO+ ?o` |
| `GRAPH` | Query a specific named graph | `GRAPH ?g { ?s ?p ?o }` |
