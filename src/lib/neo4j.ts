import neo4j, { Driver } from "neo4j-driver";

let driver: Driver | null = null;

export function getNeo4jDriver(): Driver {
  if (driver) return driver;

  const uri = process.env.NEO4J_URI;
  const user = process.env.NEO4J_USER || "neo4j";
  const password = process.env.NEO4J_PASSWORD;

  if (!uri || !password) {
    throw new Error("Missing Neo4j environment variables");
  }

  driver = neo4j.driver(uri, neo4j.auth.basic(user, password));
  return driver;
}

export async function runCypher<T = Record<string, unknown>>(
  query: string,
  params: Record<string, unknown> = {}
): Promise<T[]> {
  const session = getNeo4jDriver().session();
  try {
    const result = await session.run(query, params);
    return result.records.map((r) => r.toObject() as T);
  } finally {
    await session.close();
  }
}
