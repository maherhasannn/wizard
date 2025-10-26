/*
  Warnings:

  - You are about to drop the column `content` on the `Ritual` table. All the data in the column will be lost.
  - You are about to drop the column `day` on the `Ritual` table. All the data in the column will be lost.
  - The `status` column on the `UserChallenge` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - Added the required column `category` to the `Challenge` table without a default value. This is not possible if the table is not empty.
  - Added the required column `day_number` to the `Ritual` table without a default value. This is not possible if the table is not empty.
  - Made the column `challenge_id` on table `Ritual` required. This step will fail if there are existing NULL values in that column.
  - Changed the type of `type` on the `Ritual` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- CreateEnum
CREATE TYPE "ChallengeStatus" AS ENUM ('NOT_STARTED', 'ACTIVE', 'PAUSED', 'COMPLETED');

-- CreateEnum
CREATE TYPE "RitualType" AS ENUM ('TEXT', 'AUDIO', 'VIDEO', 'MEDITATION');

-- CreateEnum
CREATE TYPE "ChallengeCategory" AS ENUM ('SELF_LOVE', 'HEALING', 'CONFIDENCE', 'MANIFESTATION', 'MINDFULNESS', 'MORNING_ROUTINE');

-- DropIndex
DROP INDEX "public"."Ritual_challenge_id_day_idx";

-- DropIndex
DROP INDEX "public"."Ritual_is_active_sort_order_idx";

-- AlterTable
ALTER TABLE "Challenge" ADD COLUMN     "category" "ChallengeCategory" NOT NULL,
ADD COLUMN     "color_theme" TEXT,
ADD COLUMN     "subtitle" TEXT;

-- AlterTable
ALTER TABLE "Ritual" DROP COLUMN "content",
DROP COLUMN "day",
ADD COLUMN     "audio_url" TEXT,
ADD COLUMN     "day_number" INTEGER NOT NULL,
ADD COLUMN     "meditation_track_id" INTEGER,
ADD COLUMN     "text_content" TEXT,
ADD COLUMN     "video_url" TEXT,
ALTER COLUMN "challenge_id" SET NOT NULL,
DROP COLUMN "type",
ADD COLUMN     "type" "RitualType" NOT NULL;

-- AlterTable
ALTER TABLE "UserChallenge" ADD COLUMN     "paused_at" TIMESTAMP(3),
DROP COLUMN "status",
ADD COLUMN     "status" "ChallengeStatus" NOT NULL DEFAULT 'NOT_STARTED',
ALTER COLUMN "current_day" SET DEFAULT 1;

-- CreateTable
CREATE TABLE "UserRitualCompletion" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "user_challenge_id" INTEGER NOT NULL,
    "ritual_id" INTEGER NOT NULL,
    "completed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "time_spent" INTEGER,
    "notes" TEXT,

    CONSTRAINT "UserRitualCompletion_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "UserRitualCompletion_user_id_completed_at_idx" ON "UserRitualCompletion"("user_id", "completed_at");

-- CreateIndex
CREATE INDEX "UserRitualCompletion_ritual_id_idx" ON "UserRitualCompletion"("ritual_id");

-- CreateIndex
CREATE UNIQUE INDEX "UserRitualCompletion_user_challenge_id_ritual_id_key" ON "UserRitualCompletion"("user_challenge_id", "ritual_id");

-- CreateIndex
CREATE INDEX "Challenge_category_idx" ON "Challenge"("category");

-- CreateIndex
CREATE INDEX "Ritual_challenge_id_day_number_idx" ON "Ritual"("challenge_id", "day_number");

-- CreateIndex
CREATE INDEX "Ritual_is_active_idx" ON "Ritual"("is_active");

-- CreateIndex
CREATE INDEX "UserChallenge_user_id_status_idx" ON "UserChallenge"("user_id", "status");

-- AddForeignKey
ALTER TABLE "UserRitualCompletion" ADD CONSTRAINT "UserRitualCompletion_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserRitualCompletion" ADD CONSTRAINT "UserRitualCompletion_user_challenge_id_fkey" FOREIGN KEY ("user_challenge_id") REFERENCES "UserChallenge"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserRitualCompletion" ADD CONSTRAINT "UserRitualCompletion_ritual_id_fkey" FOREIGN KEY ("ritual_id") REFERENCES "Ritual"("id") ON DELETE CASCADE ON UPDATE CASCADE;
