import { XMLParser } from "fast-xml-parser";

export function extractXsdContent(xmlString: string): string {
  const parser = new XMLParser({
    ignoreAttributes: false,
    attributeNamePrefix: "@_",
    textNodeName: "#text",
  });

  const parsed = parser.parse(xmlString);
  const lines: string[] = [];

  function extractElements(obj: unknown, depth = 0): void {
    if (!obj || typeof obj !== "object") return;
    const record = obj as Record<string, unknown>;

    for (const [key, value] of Object.entries(record)) {
      // Extract element/complexType/simpleType definitions
      if (key.includes("element") || key.includes("complexType") || key.includes("simpleType")) {
        const items = Array.isArray(value) ? value : [value];
        for (const item of items) {
          if (item && typeof item === "object") {
            const rec = item as Record<string, unknown>;
            const name = rec["@_name"] as string || "";
            const type = rec["@_type"] as string || "";
            const doc = extractAnnotation(rec);
            if (name) {
              lines.push(`${"  ".repeat(depth)}${key}: ${name}${type ? ` (type: ${type})` : ""}`);
              if (doc) lines.push(`${"  ".repeat(depth + 1)}Documentation: ${doc}`);
            }
          }
        }
      }

      // Extract annotations
      if (key.includes("annotation") || key.includes("documentation")) {
        const doc = typeof value === "string" ? value : extractAnnotation(value);
        if (doc) lines.push(`${"  ".repeat(depth)}Documentation: ${doc}`);
      }

      // Recurse
      if (typeof value === "object" && value !== null) {
        extractElements(value, depth + 1);
      }
    }
  }

  function extractAnnotation(obj: unknown): string {
    if (!obj || typeof obj !== "object") return "";
    const record = obj as Record<string, unknown>;
    for (const [key, value] of Object.entries(record)) {
      if (key.includes("documentation") || key.includes("annotation")) {
        if (typeof value === "string") return value.trim();
        if (typeof value === "object" && value !== null) {
          const inner = value as Record<string, unknown>;
          if (inner["#text"]) return String(inner["#text"]).trim();
          return extractAnnotation(value);
        }
      }
    }
    return "";
  }

  extractElements(parsed);
  return lines.join("\n") || xmlString.slice(0, 5000);
}
