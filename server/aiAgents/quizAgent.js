
import ai from "../exports/gemini.js"
import { z } from "zod"
import { zodToJsonSchema } from "zod-to-json-schema"

// Schema for the entire quiz
const quizSchema = z.array(
  z.object({
    question: z.string().describe("The quiz question"),
    options: z.array(z.string()).length(4).describe("An array of 4 possible answer options"),
    correct_answer: z.string().describe("The correct answer from the options"),
  }).describe("A single quiz question with options and the correct answer"),
);

const quizAgent = async (subTopicDescription) => {
  const prompt = `You are an expert quiz creator. Your task is to create a quiz based on the given sub-topic description.
  The quiz should can contain 10 to 20 multiple choice questions. Each question should have 4 options, and only one correct answer.
  Make sure the questions cover the key concepts from the sub-topic description.
  You will only return the expected array of objects response as per the schema provided. Do not include any additional text or explanations.
  example schema:
  [
    {
      "question": "What is ...?",
      "options": ["Option A", "Option B", "Option C", "Option D"],
      "correct_answer": "Option A"
    },
    ...
  ]
  `;

    const response = await ai.models.generateContent({
        model: "gemini-2.5-flash",
        contents: `${prompt}\n\nSub-Topic Description: ${subTopicDescription}`,
        config: {
            responseMimeType: "application/json",
            responseJsonSchema: zodToJsonSchema(quizSchema),
        }
    })
    // console.log("Quiz Agent Response:", (response.text));
    const quiz = quizSchema.parse(JSON.parse(response.text));
    // console.log(quiz);

    return quiz;
}

export default quizAgent