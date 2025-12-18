import ai from "../exports/gemini.js";
import { fixAIMarkdown } from "../lib/fixAImd.js";

export async function summariserAgent(urlToDocument, mimeType) {
    const docResp = await fetch(urlToDocument)
        .then((response) => response.arrayBuffer());

    const prompt = `
    You are really good in understanding and summarizing documents.
    Please provide a great descriptive summary of the following document.
    Please provide the output in markdown format.
    Output raw Markdown, not escaped text. Do not use backslash n.`
    const contents = [
        { text: prompt },
        {
            inlineData: {
                mimeType: mimeType,
                data: Buffer.from(docResp).toString("base64")
            }
        }
    ];

    const response = await ai.models.generateContent({
        model: "gemini-2.5-flash",
        contents: contents
    });
    
    return fixAIMarkdown(response.text);
}
