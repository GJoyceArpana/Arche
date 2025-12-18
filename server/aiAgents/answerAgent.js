import ai from "../exports/gemini.js";
import { fixAIMarkdown } from "../lib/fixAImd.js";

export async function answerAgent(userQuery, context) {

    const prompt = `
    You are really good in explaining topics in simple and clear way.
    you have been provided with necessary contents. Your job is to answer 
    user query with the context of provided contents. Please output your answer in
    markdown format only.
    context:  ${context}
    user query:  ${userQuery}
    `
    const contents = [
        { text: prompt },
    ];

    const response = await ai.models.generateContent({
        model: "gemini-2.5-flash",
        contents: contents
    });
    
    return fixAIMarkdown(response.text);
}
