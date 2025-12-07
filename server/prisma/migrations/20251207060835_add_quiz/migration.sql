-- AlterTable
ALTER TABLE "subTopic" ADD COLUMN     "containsQuiz" BOOLEAN NOT NULL DEFAULT false;

-- CreateTable
CREATE TABLE "question" (
    "id" TEXT NOT NULL,
    "quizId" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "options" TEXT[],
    "correctAnswer" TEXT NOT NULL,

    CONSTRAINT "question_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "quiz" (
    "id" TEXT NOT NULL,
    "subTopicId" TEXT NOT NULL,

    CONSTRAINT "quiz_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "quiz_subTopicId_key" ON "quiz"("subTopicId");

-- AddForeignKey
ALTER TABLE "question" ADD CONSTRAINT "question_quizId_fkey" FOREIGN KEY ("quizId") REFERENCES "quiz"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quiz" ADD CONSTRAINT "quiz_subTopicId_fkey" FOREIGN KEY ("subTopicId") REFERENCES "subTopic"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
