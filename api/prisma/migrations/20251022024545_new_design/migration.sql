-- CreateTable
CREATE TABLE "Challenge" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "duration" INTEGER NOT NULL,
    "goals" TEXT[],
    "icon" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Challenge_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserChallenge" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "challenge_id" INTEGER NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'NOT_STARTED',
    "current_day" INTEGER NOT NULL DEFAULT 0,
    "started_at" TIMESTAMP(3),
    "completed_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "UserChallenge_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Ritual" (
    "id" SERIAL NOT NULL,
    "challenge_id" INTEGER,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "duration" INTEGER NOT NULL,
    "type" TEXT NOT NULL,
    "content" TEXT,
    "day" INTEGER,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Ritual_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserMood" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "mood" TEXT NOT NULL,
    "date" DATE NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserMood_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Challenge_is_active_sort_order_idx" ON "Challenge"("is_active", "sort_order");

-- CreateIndex
CREATE INDEX "UserChallenge_user_id_status_idx" ON "UserChallenge"("user_id", "status");

-- CreateIndex
CREATE INDEX "UserChallenge_challenge_id_idx" ON "UserChallenge"("challenge_id");

-- CreateIndex
CREATE UNIQUE INDEX "UserChallenge_user_id_challenge_id_key" ON "UserChallenge"("user_id", "challenge_id");

-- CreateIndex
CREATE INDEX "Ritual_challenge_id_day_idx" ON "Ritual"("challenge_id", "day");

-- CreateIndex
CREATE INDEX "Ritual_is_active_sort_order_idx" ON "Ritual"("is_active", "sort_order");

-- CreateIndex
CREATE INDEX "UserMood_user_id_date_idx" ON "UserMood"("user_id", "date");

-- CreateIndex
CREATE UNIQUE INDEX "UserMood_user_id_date_key" ON "UserMood"("user_id", "date");

-- AddForeignKey
ALTER TABLE "UserChallenge" ADD CONSTRAINT "UserChallenge_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserChallenge" ADD CONSTRAINT "UserChallenge_challenge_id_fkey" FOREIGN KEY ("challenge_id") REFERENCES "Challenge"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ritual" ADD CONSTRAINT "Ritual_challenge_id_fkey" FOREIGN KEY ("challenge_id") REFERENCES "Challenge"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserMood" ADD CONSTRAINT "UserMood_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
