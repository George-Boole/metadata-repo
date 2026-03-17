import { Connection, query as stardogQuery } from "stardog";

let conn: Connection | null = null;

/** Check if Stardog env vars are configured */
export function isStardogConfigured(): boolean {
  return !!(
    process.env.STARDOG_ENDPOINT &&
    process.env.STARDOG_USERNAME &&
    process.env.STARDOG_PASSWORD &&
    process.env.STARDOG_DATABASE
  );
}

export function getStardogConnection(): Connection {
  if (conn) return conn;

  const endpoint = process.env.STARDOG_ENDPOINT;
  const username = process.env.STARDOG_USERNAME;
  const password = process.env.STARDOG_PASSWORD;

  if (!endpoint || !username || !password) {
    throw new Error("Missing Stardog environment variables (STARDOG_ENDPOINT, STARDOG_USERNAME, STARDOG_PASSWORD)");
  }

  conn = new Connection({ endpoint, username, password });
  return conn;
}

export function getStardogDatabase(): string {
  const db = process.env.STARDOG_DATABASE;
  if (!db) throw new Error("Missing STARDOG_DATABASE environment variable");
  return db;
}

/** Run a SPARQL SELECT query and return the bindings as plain objects */
export async function runSparqlSelect<T = Record<string, unknown>>(
  sparql: string,
): Promise<T[]> {
  if (!isStardogConfigured()) {
    throw new Error("Stardog not configured");
  }

  const connection = getStardogConnection();
  const database = getStardogDatabase();

  const res = await stardogQuery.execute(connection, database, sparql, "application/sparql-results+json");

  if (res.status !== 200) {
    throw new Error(`Stardog SPARQL SELECT failed (${res.status})`);
  }

  const bindings = res.body?.results?.bindings;
  if (!Array.isArray(bindings)) return [];

  // Convert SPARQL JSON result bindings to plain objects
  return bindings.map((binding: Record<string, { value: string; type: string }>) => {
    const obj: Record<string, unknown> = {};
    for (const [key, val] of Object.entries(binding)) {
      obj[key] = val.value;
    }
    return obj as T;
  });
}

/** Run a SPARQL UPDATE (INSERT/DELETE) */
export async function runSparqlUpdate(sparql: string): Promise<void> {
  if (!isStardogConfigured()) {
    throw new Error("Stardog not configured");
  }

  const connection = getStardogConnection();
  const database = getStardogDatabase();

  const res = await stardogQuery.execute(connection, database, sparql, "application/sparql-results+json");

  if (res.status !== 200) {
    throw new Error(`Stardog SPARQL UPDATE failed (${res.status})`);
  }
}
