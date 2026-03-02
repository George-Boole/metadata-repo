export interface Chunk {
  content: string;
  heading: string;
  index: number;
  tokenEstimate: number;
}

export interface ChunkOptions {
  /** Max tokens per chunk (default: 500) */
  maxTokens?: number;
  /** Overlap tokens between consecutive chunks (default: 50) */
  overlapTokens?: number;
}

/** Approximate token count: ~4 chars per token for English text */
function estimateTokens(text: string): number {
  return Math.ceil(text.length / 4);
}

/**
 * Split markdown into chunks by headings, then by paragraph boundaries
 * for sections that exceed maxTokens.
 */
export function chunkMarkdown(
  markdown: string,
  options: ChunkOptions = {}
): Chunk[] {
  const maxTokens = options.maxTokens ?? 500;
  const overlapTokens = options.overlapTokens ?? 50;
  const overlapChars = overlapTokens * 4;
  const maxChars = maxTokens * 4;

  const sections = splitByHeadings(markdown);
  const chunks: Chunk[] = [];

  for (const section of sections) {
    const tokenCount = estimateTokens(section.content);

    if (tokenCount <= maxTokens) {
      const trimmed = section.content.trim();
      if (trimmed.length > 20) {
        chunks.push({
          content: trimmed,
          heading: section.heading,
          index: chunks.length,
          tokenEstimate: estimateTokens(trimmed),
        });
      }
    } else {
      // Split long sections by paragraphs with overlap
      const subChunks = splitLongSection(
        section.content,
        maxChars,
        overlapChars
      );
      for (const sub of subChunks) {
        const trimmed = sub.trim();
        if (trimmed.length > 20) {
          chunks.push({
            content: trimmed,
            heading: section.heading,
            index: chunks.length,
            tokenEstimate: estimateTokens(trimmed),
          });
        }
      }
    }
  }

  return chunks;
}

function splitByHeadings(
  markdown: string
): { heading: string; content: string }[] {
  const lines = markdown.split("\n");
  const sections: { heading: string; content: string }[] = [];
  let currentHeading = "";
  let currentContent: string[] = [];

  for (const line of lines) {
    const headingMatch = line.match(/^#{1,3}\s+(.+)/);
    if (headingMatch) {
      if (currentContent.length > 0) {
        sections.push({
          heading: currentHeading,
          content: currentContent.join("\n"),
        });
      }
      currentHeading = headingMatch[1].trim();
      currentContent = [line];
    } else {
      currentContent.push(line);
    }
  }

  if (currentContent.length > 0) {
    sections.push({
      heading: currentHeading,
      content: currentContent.join("\n"),
    });
  }

  return sections;
}

function splitLongSection(
  text: string,
  maxChars: number,
  overlapChars: number
): string[] {
  const paragraphs = text.split(/\n\n+/);
  const chunks: string[] = [];
  let current = "";

  for (const para of paragraphs) {
    if (current.length + para.length > maxChars && current.length > 0) {
      chunks.push(current);
      // Start new chunk with overlap from end of previous
      const overlap = current.slice(-overlapChars);
      current = overlap + "\n\n" + para;
    } else {
      current = current ? current + "\n\n" + para : para;
    }
  }

  if (current.trim()) {
    chunks.push(current);
  }

  return chunks;
}
