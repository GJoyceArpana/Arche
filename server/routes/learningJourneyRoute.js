import  { Router } from 'express';
import { getLearningJourneys, newLearningJourney, updateProgress } from '../controllers/learningJourneyController.js';

const learningJourneyRouter = Router();

learningJourneyRouter.post('/', newLearningJourney);

learningJourneyRouter.get('/', getLearningJourneys);

learningJourneyRouter.put('/update-progress', updateProgress);  

learningJourneyRouter.get('streak')

export default learningJourneyRouter;