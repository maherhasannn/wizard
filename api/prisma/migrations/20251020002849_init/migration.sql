-- CreateEnum
CREATE TYPE "MeditationCategory" AS ENUM ('AUDIO', 'MUSIC', 'SLEEP');

-- CreateEnum
CREATE TYPE "EventType" AS ENUM ('MEDITATION', 'GOAL', 'REMINDER', 'CUSTOM');

-- CreateEnum
CREATE TYPE "ConnectionStatus" AS ENUM ('PENDING', 'ACCEPTED', 'REJECTED', 'BLOCKED');

-- CreateEnum
CREATE TYPE "SwipeDirection" AS ENUM ('LEFT', 'RIGHT');

-- CreateEnum
CREATE TYPE "StreamStatus" AS ENUM ('SCHEDULED', 'LIVE', 'ENDED');

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "first_name" TEXT,
    "last_name" TEXT,
    "phone" TEXT,
    "profile_photo" TEXT,
    "bio" TEXT,
    "birthday" DATE,
    "gender" TEXT,
    "country" TEXT,
    "city" TEXT,
    "instagram_handle" TEXT,
    "interests" TEXT[],
    "is_profile_public" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserAuth" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "auth_token" TEXT,
    "token_expiry" TIMESTAMP(3),
    "refresh_token" TEXT,
    "refresh_token_expiry" TIMESTAMP(3),
    "reset_token" TEXT,
    "reset_token_expiry" TIMESTAMP(3),
    "is_email_verified" BOOLEAN NOT NULL DEFAULT false,
    "email_verification_token" TEXT,
    "verification_expiry" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "UserAuth_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserSettings" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "push_notifications" BOOLEAN NOT NULL DEFAULT true,
    "email_notifications" BOOLEAN NOT NULL DEFAULT true,
    "dark_mode" BOOLEAN NOT NULL DEFAULT false,
    "language" TEXT NOT NULL DEFAULT 'en',
    "timezone" TEXT NOT NULL DEFAULT 'UTC',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "UserSettings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MeditationTrack" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "artist" TEXT NOT NULL,
    "description" TEXT,
    "category" "MeditationCategory" NOT NULL,
    "duration" INTEGER NOT NULL,
    "audio_url" TEXT NOT NULL,
    "image_url" TEXT,
    "is_premium" BOOLEAN NOT NULL DEFAULT false,
    "play_count" INTEGER NOT NULL DEFAULT 0,
    "favorite_count" INTEGER NOT NULL DEFAULT 0,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MeditationTrack_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserMeditationFavorite" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "track_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserMeditationFavorite_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserMeditationHistory" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "track_id" INTEGER NOT NULL,
    "played_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "duration" INTEGER NOT NULL,
    "completed" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "UserMeditationHistory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserMeditationStats" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "total_minutes" INTEGER NOT NULL DEFAULT 0,
    "sessions_count" INTEGER NOT NULL DEFAULT 0,
    "streak" INTEGER NOT NULL DEFAULT 0,
    "last_session_date" DATE,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "UserMeditationStats_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CalendarEvent" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "type" "EventType" NOT NULL,
    "scheduled_at" TIMESTAMP(3) NOT NULL,
    "duration" INTEGER,
    "is_completed" BOOLEAN NOT NULL DEFAULT false,
    "completed_at" TIMESTAMP(3),
    "recurrence" JSONB,
    "notificationTime" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CalendarEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EventReminder" (
    "id" SERIAL NOT NULL,
    "event_id" INTEGER NOT NULL,
    "reminder_time" TIMESTAMP(3) NOT NULL,
    "sent_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "EventReminder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NetworkProfile" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "visibility" TEXT NOT NULL DEFAULT 'PUBLIC',
    "lookingFor" TEXT,
    "bio" TEXT,
    "interests" TEXT[],
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "last_location_update" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "NetworkProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Connection" (
    "id" SERIAL NOT NULL,
    "requester_id" INTEGER NOT NULL,
    "receiver_id" INTEGER NOT NULL,
    "status" "ConnectionStatus" NOT NULL DEFAULT 'PENDING',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "accepted_at" TIMESTAMP(3),
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Connection_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserSwipe" (
    "id" SERIAL NOT NULL,
    "swiper_id" INTEGER NOT NULL,
    "swiped_user_id" INTEGER NOT NULL,
    "direction" "SwipeDirection" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserSwipe_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserView" (
    "id" SERIAL NOT NULL,
    "viewer_id" INTEGER NOT NULL,
    "viewed_user_id" INTEGER NOT NULL,
    "viewed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserView_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MessageOfDay" (
    "id" SERIAL NOT NULL,
    "date" DATE NOT NULL,
    "title" TEXT NOT NULL,
    "card_type" TEXT NOT NULL,
    "short_message" TEXT NOT NULL,
    "full_message" TEXT NOT NULL,
    "image_url" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MessageOfDay_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Video" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "thumbnail_url" TEXT NOT NULL,
    "video_url" TEXT NOT NULL,
    "duration" INTEGER NOT NULL,
    "category" TEXT,
    "view_count" INTEGER NOT NULL DEFAULT 0,
    "uploaded_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Video_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserVideoView" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "video_id" INTEGER NOT NULL,
    "viewed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "watch_duration" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "UserVideoView_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Affirmation" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "category" TEXT,
    "image_url" TEXT,
    "video_url" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Affirmation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserAffirmationInteraction" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "affirmation_id" INTEGER NOT NULL,
    "feeling" INTEGER,
    "viewed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserAffirmationInteraction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LiveStream" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "host_id" INTEGER NOT NULL,
    "thumbnail_url" TEXT,
    "stream_url" TEXT,
    "status" "StreamStatus" NOT NULL DEFAULT 'SCHEDULED',
    "viewer_count" INTEGER NOT NULL DEFAULT 0,
    "started_at" TIMESTAMP(3),
    "ended_at" TIMESTAMP(3),
    "scheduled_at" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LiveStream_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LiveStreamParticipant" (
    "id" SERIAL NOT NULL,
    "stream_id" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,
    "joined_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "left_at" TIMESTAMP(3),

    CONSTRAINT "LiveStreamParticipant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LiveStreamChat" (
    "id" SERIAL NOT NULL,
    "stream_id" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,
    "message" TEXT NOT NULL,
    "sent_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LiveStreamChat_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PowerCategory" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "icon" TEXT,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PowerCategory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserPowerSelection" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "power_category_id" INTEGER NOT NULL,
    "selected_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "priority" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "UserPowerSelection_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE INDEX "User_email_idx" ON "User"("email");

-- CreateIndex
CREATE INDEX "User_created_at_idx" ON "User"("created_at");

-- CreateIndex
CREATE INDEX "User_is_profile_public_idx" ON "User"("is_profile_public");

-- CreateIndex
CREATE UNIQUE INDEX "UserAuth_user_id_key" ON "UserAuth"("user_id");

-- CreateIndex
CREATE INDEX "UserAuth_auth_token_idx" ON "UserAuth"("auth_token");

-- CreateIndex
CREATE INDEX "UserAuth_refresh_token_idx" ON "UserAuth"("refresh_token");

-- CreateIndex
CREATE INDEX "UserAuth_reset_token_idx" ON "UserAuth"("reset_token");

-- CreateIndex
CREATE INDEX "UserAuth_email_verification_token_idx" ON "UserAuth"("email_verification_token");

-- CreateIndex
CREATE UNIQUE INDEX "UserSettings_user_id_key" ON "UserSettings"("user_id");

-- CreateIndex
CREATE INDEX "MeditationTrack_category_is_active_idx" ON "MeditationTrack"("category", "is_active");

-- CreateIndex
CREATE INDEX "MeditationTrack_play_count_idx" ON "MeditationTrack"("play_count");

-- CreateIndex
CREATE INDEX "MeditationTrack_favorite_count_idx" ON "MeditationTrack"("favorite_count");

-- CreateIndex
CREATE INDEX "UserMeditationFavorite_user_id_idx" ON "UserMeditationFavorite"("user_id");

-- CreateIndex
CREATE INDEX "UserMeditationFavorite_track_id_idx" ON "UserMeditationFavorite"("track_id");

-- CreateIndex
CREATE UNIQUE INDEX "UserMeditationFavorite_user_id_track_id_key" ON "UserMeditationFavorite"("user_id", "track_id");

-- CreateIndex
CREATE INDEX "UserMeditationHistory_user_id_played_at_idx" ON "UserMeditationHistory"("user_id", "played_at");

-- CreateIndex
CREATE INDEX "UserMeditationHistory_track_id_idx" ON "UserMeditationHistory"("track_id");

-- CreateIndex
CREATE UNIQUE INDEX "UserMeditationStats_user_id_key" ON "UserMeditationStats"("user_id");

-- CreateIndex
CREATE INDEX "CalendarEvent_user_id_scheduled_at_idx" ON "CalendarEvent"("user_id", "scheduled_at");

-- CreateIndex
CREATE INDEX "CalendarEvent_is_completed_idx" ON "CalendarEvent"("is_completed");

-- CreateIndex
CREATE INDEX "EventReminder_reminder_time_sent_at_idx" ON "EventReminder"("reminder_time", "sent_at");

-- CreateIndex
CREATE INDEX "EventReminder_event_id_idx" ON "EventReminder"("event_id");

-- CreateIndex
CREATE UNIQUE INDEX "NetworkProfile_user_id_key" ON "NetworkProfile"("user_id");

-- CreateIndex
CREATE INDEX "NetworkProfile_visibility_idx" ON "NetworkProfile"("visibility");

-- CreateIndex
CREATE INDEX "NetworkProfile_latitude_longitude_idx" ON "NetworkProfile"("latitude", "longitude");

-- CreateIndex
CREATE INDEX "Connection_requester_id_status_idx" ON "Connection"("requester_id", "status");

-- CreateIndex
CREATE INDEX "Connection_receiver_id_status_idx" ON "Connection"("receiver_id", "status");

-- CreateIndex
CREATE UNIQUE INDEX "Connection_requester_id_receiver_id_key" ON "Connection"("requester_id", "receiver_id");

-- CreateIndex
CREATE INDEX "UserSwipe_swiper_id_idx" ON "UserSwipe"("swiper_id");

-- CreateIndex
CREATE INDEX "UserSwipe_swiped_user_id_idx" ON "UserSwipe"("swiped_user_id");

-- CreateIndex
CREATE UNIQUE INDEX "UserSwipe_swiper_id_swiped_user_id_key" ON "UserSwipe"("swiper_id", "swiped_user_id");

-- CreateIndex
CREATE INDEX "UserView_viewer_id_viewed_at_idx" ON "UserView"("viewer_id", "viewed_at");

-- CreateIndex
CREATE INDEX "UserView_viewed_user_id_idx" ON "UserView"("viewed_user_id");

-- CreateIndex
CREATE UNIQUE INDEX "MessageOfDay_date_key" ON "MessageOfDay"("date");

-- CreateIndex
CREATE INDEX "MessageOfDay_date_idx" ON "MessageOfDay"("date");

-- CreateIndex
CREATE INDEX "Video_category_is_active_idx" ON "Video"("category", "is_active");

-- CreateIndex
CREATE INDEX "Video_uploaded_at_idx" ON "Video"("uploaded_at");

-- CreateIndex
CREATE INDEX "Video_view_count_idx" ON "Video"("view_count");

-- CreateIndex
CREATE INDEX "UserVideoView_user_id_viewed_at_idx" ON "UserVideoView"("user_id", "viewed_at");

-- CreateIndex
CREATE INDEX "UserVideoView_video_id_idx" ON "UserVideoView"("video_id");

-- CreateIndex
CREATE INDEX "Affirmation_category_is_active_idx" ON "Affirmation"("category", "is_active");

-- CreateIndex
CREATE INDEX "UserAffirmationInteraction_user_id_viewed_at_idx" ON "UserAffirmationInteraction"("user_id", "viewed_at");

-- CreateIndex
CREATE INDEX "UserAffirmationInteraction_affirmation_id_idx" ON "UserAffirmationInteraction"("affirmation_id");

-- CreateIndex
CREATE INDEX "LiveStream_status_scheduled_at_idx" ON "LiveStream"("status", "scheduled_at");

-- CreateIndex
CREATE INDEX "LiveStream_host_id_idx" ON "LiveStream"("host_id");

-- CreateIndex
CREATE INDEX "LiveStreamParticipant_stream_id_user_id_idx" ON "LiveStreamParticipant"("stream_id", "user_id");

-- CreateIndex
CREATE INDEX "LiveStreamParticipant_user_id_idx" ON "LiveStreamParticipant"("user_id");

-- CreateIndex
CREATE INDEX "LiveStreamChat_stream_id_sent_at_idx" ON "LiveStreamChat"("stream_id", "sent_at");

-- CreateIndex
CREATE INDEX "LiveStreamChat_user_id_idx" ON "LiveStreamChat"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "PowerCategory_name_key" ON "PowerCategory"("name");

-- CreateIndex
CREATE INDEX "PowerCategory_sort_order_is_active_idx" ON "PowerCategory"("sort_order", "is_active");

-- CreateIndex
CREATE INDEX "UserPowerSelection_user_id_priority_idx" ON "UserPowerSelection"("user_id", "priority");

-- CreateIndex
CREATE INDEX "UserPowerSelection_power_category_id_idx" ON "UserPowerSelection"("power_category_id");

-- CreateIndex
CREATE UNIQUE INDEX "UserPowerSelection_user_id_power_category_id_key" ON "UserPowerSelection"("user_id", "power_category_id");

-- AddForeignKey
ALTER TABLE "UserAuth" ADD CONSTRAINT "UserAuth_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserSettings" ADD CONSTRAINT "UserSettings_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserMeditationFavorite" ADD CONSTRAINT "UserMeditationFavorite_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserMeditationFavorite" ADD CONSTRAINT "UserMeditationFavorite_track_id_fkey" FOREIGN KEY ("track_id") REFERENCES "MeditationTrack"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserMeditationHistory" ADD CONSTRAINT "UserMeditationHistory_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserMeditationHistory" ADD CONSTRAINT "UserMeditationHistory_track_id_fkey" FOREIGN KEY ("track_id") REFERENCES "MeditationTrack"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserMeditationStats" ADD CONSTRAINT "UserMeditationStats_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CalendarEvent" ADD CONSTRAINT "CalendarEvent_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EventReminder" ADD CONSTRAINT "EventReminder_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "CalendarEvent"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NetworkProfile" ADD CONSTRAINT "NetworkProfile_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Connection" ADD CONSTRAINT "Connection_requester_id_fkey" FOREIGN KEY ("requester_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Connection" ADD CONSTRAINT "Connection_receiver_id_fkey" FOREIGN KEY ("receiver_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserSwipe" ADD CONSTRAINT "UserSwipe_swiper_id_fkey" FOREIGN KEY ("swiper_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserSwipe" ADD CONSTRAINT "UserSwipe_swiped_user_id_fkey" FOREIGN KEY ("swiped_user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserView" ADD CONSTRAINT "UserView_viewer_id_fkey" FOREIGN KEY ("viewer_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserView" ADD CONSTRAINT "UserView_viewed_user_id_fkey" FOREIGN KEY ("viewed_user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserVideoView" ADD CONSTRAINT "UserVideoView_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserVideoView" ADD CONSTRAINT "UserVideoView_video_id_fkey" FOREIGN KEY ("video_id") REFERENCES "Video"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserAffirmationInteraction" ADD CONSTRAINT "UserAffirmationInteraction_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserAffirmationInteraction" ADD CONSTRAINT "UserAffirmationInteraction_affirmation_id_fkey" FOREIGN KEY ("affirmation_id") REFERENCES "Affirmation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LiveStream" ADD CONSTRAINT "LiveStream_host_id_fkey" FOREIGN KEY ("host_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LiveStreamParticipant" ADD CONSTRAINT "LiveStreamParticipant_stream_id_fkey" FOREIGN KEY ("stream_id") REFERENCES "LiveStream"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LiveStreamParticipant" ADD CONSTRAINT "LiveStreamParticipant_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LiveStreamChat" ADD CONSTRAINT "LiveStreamChat_stream_id_fkey" FOREIGN KEY ("stream_id") REFERENCES "LiveStream"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LiveStreamChat" ADD CONSTRAINT "LiveStreamChat_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserPowerSelection" ADD CONSTRAINT "UserPowerSelection_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserPowerSelection" ADD CONSTRAINT "UserPowerSelection_power_category_id_fkey" FOREIGN KEY ("power_category_id") REFERENCES "PowerCategory"("id") ON DELETE CASCADE ON UPDATE CASCADE;
