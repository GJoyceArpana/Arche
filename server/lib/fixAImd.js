
export function fixAIMarkdown(input) {
  return input
    .replace(/\\n\\n/g, '\n\n')
    .replace(/\\n/g, '\n')
    .replace(/\\"/g, '"')
    .replace(/^\*\s+/gm, '- ')
    .replace(/([^\n])\n(- )/g, '$1\n\n$2')
    .trim();
}

