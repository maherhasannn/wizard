/*
  Warnings:

  - You are about to drop the `UserAuth` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "public"."UserAuth" DROP CONSTRAINT "UserAuth_user_id_fkey";

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "refresh_token" TEXT,
ADD COLUMN     "refresh_token_expiry" TIMESTAMP(3),
ADD COLUMN     "reset_token" TEXT,
ADD COLUMN     "reset_token_expiry" TIMESTAMP(3);

-- DropTable
DROP TABLE "public"."UserAuth";

-- CreateIndex
CREATE INDEX "User_refresh_token_idx" ON "User"("refresh_token");

-- CreateIndex
CREATE INDEX "User_reset_token_idx" ON "User"("reset_token");
