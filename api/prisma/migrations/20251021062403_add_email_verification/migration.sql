-- AlterTable
ALTER TABLE "User" ADD COLUMN     "is_email_verified" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "verification_code" TEXT,
ADD COLUMN     "verification_code_expiry" TIMESTAMP(3);
