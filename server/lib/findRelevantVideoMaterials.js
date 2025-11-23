import { searchYouTube } from "./ytSearch.js";
import prisma from "../exports/prisma.js";
async function findRelevantVideoMaterials(subTopics, maxResults = 3) {


    for (const topic of subTopics) {
        const query = `${topic.description}`;
        try {
            const searchResults = await searchYouTube(query, maxResults);
            const videoResources = await prisma.videoResource.createMany({
                data: searchResults.map(video => ({
                    title: video.snippet.title,
                    url: `https://www.youtube.com/watch?v=${video.id.videoId}`,
                    subTopicId: topic.id,
                }))
            });
            return videoResources;
            
        } catch (error) {
            console.error(`Error fetching videos for topic "${topic}":`, error);
        }
    }
}

export default findRelevantVideoMaterials;