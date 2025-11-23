/*
  Warnings:

  - Added the required column `learningJourneyId` to the `subTopic` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "subTopic" ADD COLUMN     "learningJourneyId" TEXT NOT NULL;

-- AddForeignKey
ALTER TABLE "subTopic" ADD CONSTRAINT "subTopic_learningJourneyId_fkey" FOREIGN KEY ("learningJourneyId") REFERENCES "learningJourney"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
