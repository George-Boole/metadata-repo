import { XMLParser } from "fast-xml-parser";

export function extractSchematronContent(xmlString: string): string {
  const parser = new XMLParser({
    ignoreAttributes: false,
    attributeNamePrefix: "@_",
    textNodeName: "#text",
  });

  const parsed = parser.parse(xmlString);
  const lines: string[] = [];

  function extractRules(obj: unknown, depth = 0): void {
    if (!obj || typeof obj !== "object") return;
    const record = obj as Record<string, unknown>;

    for (const [key, value] of Object.entries(record)) {
      if (key.includes("pattern")) {
        const items = Array.isArray(value) ? value : [value];
        for (const item of items) {
          if (item && typeof item === "object") {
            const rec = item as Record<string, unknown>;
            const name = rec["@_name"] as string || rec["@_id"] as string || "";
            if (name) lines.push(`Pattern: ${name}`);
          }
        }
      }

      if (key.includes("rule")) {
        const items = Array.isArray(value) ? value : [value];
        for (const item of items) {
          if (item && typeof item === "object") {
            const rec = item as Record<string, unknown>;
            const context = rec["@_context"] as string || "";
            if (context) lines.push(`${"  ".repeat(depth)}Rule context: ${context}`);
          }
        }
      }

      if (key.includes("assert") || key.includes("report")) {
        const items = Array.isArray(value) ? value : [value];
        for (const item of items) {
          if (item && typeof item === "object") {
            const rec = item as Record<string, unknown>;
            const test = rec["@_test"] as string || "";
            const text = rec["#text"] as string || "";
            if (test || text) {
              lines.push(`${"  ".repeat(depth + 1)}${key}: ${text || test}`);
            }
          } else if (typeof item === "string") {
            lines.push(`${"  ".repeat(depth + 1)}${key}: ${item}`);
          }
        }
      }

      if (typeof value === "object" && value !== null) {
        extractRules(value, depth + 1);
      }
    }
  }

  extractRules(parsed);
  return lines.join("\n") || xmlString.slice(0, 5000);
}
