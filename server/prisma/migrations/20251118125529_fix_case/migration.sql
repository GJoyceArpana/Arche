/*
  Warnings:

  - You are about to drop the column `MonthsToComplete` on the `learningPreference` table. All the data in the column will be lost.
  - Added the required column `monthsToComplete` to the `learningPreference` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "learningPreference" DROP COLUMN "MonthsToComplete",
ADD COLUMN     "monthsToComplete" INTEGER NOT NULL;
