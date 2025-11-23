-- CreateTable
CREATE TABLE "subTopic" (
    "id" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "subTopic_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "videoResource" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "duration" INTEGER NOT NULL,
    "subTopicId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "videoResource_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "videoResource_subTopicId_idx" ON "videoResource"("subTopicId");

-- AddForeignKey
ALTER TABLE "videoResource" ADD CONSTRAINT "videoResource_subTopicId_fkey" FOREIGN KEY ("subTopicId") REFERENCES "subTopic"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
