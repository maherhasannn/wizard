// Meditation categories
export const MEDITATION_CATEGORIES = {
  AUDIO: 'AUDIO',
  MUSIC: 'MUSIC',
  SLEEP: 'SLEEP',
} as const;

// Event types
export const EVENT_TYPES = {
  MEDITATION: 'MEDITATION',
  GOAL: 'GOAL',
  REMINDER: 'REMINDER',
  CUSTOM: 'CUSTOM',
} as const;

// Connection statuses
export const CONNECTION_STATUS = {
  PENDING: 'PENDING',
  ACCEPTED: 'ACCEPTED',
  REJECTED: 'REJECTED',
  BLOCKED: 'BLOCKED',
} as const;

// Swipe directions
export const SWIPE_DIRECTION = {
  LEFT: 'LEFT',
  RIGHT: 'RIGHT',
} as const;

// Stream statuses
export const STREAM_STATUS = {
  SCHEDULED: 'SCHEDULED',
  LIVE: 'LIVE',
  ENDED: 'ENDED',
} as const;

// Gender options
export const GENDER = {
  MALE: 'MALE',
  FEMALE: 'FEMALE',
  OTHER: 'OTHER',
  PREFER_NOT_TO_SAY: 'PREFER_NOT_TO_SAY',
} as const;

// Profile visibility
export const VISIBILITY = {
  PUBLIC: 'PUBLIC',
  FRIENDS_ONLY: 'FRIENDS_ONLY',
  PRIVATE: 'PRIVATE',
} as const;

// File upload paths
export const UPLOAD_PATHS = {
  PROFILES: 'profiles',
  MEDITATION: 'meditation',
  VIDEOS: 'videos',
  AFFIRMATIONS: 'affirmations',
  STREAMS: 'streams',
} as const;

// Default pagination
export const DEFAULT_PAGE_SIZE = 20;
export const MAX_PAGE_SIZE = 100;

// Token expiry (in hours)
export const EMAIL_VERIFICATION_EXPIRY = 24;
export const PASSWORD_RESET_EXPIRY = 1;

// Rate limiting
export const RATE_LIMITS = {
  AUTH: {
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 5, // 5 requests per window
  },
  API: {
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100, // 100 requests per window
  },
} as const;


