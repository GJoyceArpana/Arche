/*
  Warnings:

  - Added the required column `userId` to the `fileUpload` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "fileUpload" ADD COLUMN     "userId" TEXT NOT NULL;

-- AddForeignKey
ALTER TABLE "fileUpload" ADD CONSTRAINT "fileUpload_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
