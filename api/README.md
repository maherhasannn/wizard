# Wizard API

Backend API for the Wizard meditation and wellness platform.

## Tech Stack

- **Runtime**: Node.js 20+
- **Framework**: Express.js
- **Language**: TypeScript
- **Database**: PostgreSQL
- **ORM**: Prisma
- **Authentication**: JWT with Argon2 password hashing
- **Cloud Storage**: Google Cloud Storage
- **Deployment**: Google Cloud Run

## Getting Started

### Prerequisites

- Node.js 20+ and npm 10+
- PostgreSQL database
- Google Cloud Platform account (for storage and deployment)

### Installation

```bash
# Install dependencies
npm install

# Copy environment file
cp .env.example .env

# Edit .env with your configuration
```

### Database Setup

```bash
# Generate Prisma client
npm run prisma:generate

# Run migrations (creates and applies migrations)
npm run migrate:dev

# Seed database with sample data
npm run db:seed

# Open Prisma Studio to view data
npm run prisma:studio
```

**Migration vs DB Push**: We use `migrate:dev` instead of `db:push` to maintain proper migration history. This is essential for production deployments and tracking schema changes over time.

### Running the Server

```bash
# Development mode with hot reload
npm run dev

# Production build
npm run build
npm start
```

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `POST /api/auth/refresh` - Refresh access token
- `POST /api/auth/forgot-password` - Request password reset
- `POST /api/auth/reset-password` - Reset password
- `GET /api/auth/me` - Get current user

### User
- `GET /api/user/profile` - Get user profile
- `PUT /api/user/profile` - Update profile
- `POST /api/user/upload-photo` - Upload profile photo
- `GET /api/user/settings` - Get settings
- `PUT /api/user/settings` - Update settings

### Meditation
- `GET /api/meditation/tracks` - List tracks
- `GET /api/meditation/tracks/:id` - Get track details
- `POST /api/meditation/tracks/:id/favorite` - Add to favorites
- `DELETE /api/meditation/tracks/:id/favorite` - Remove favorite
- `GET /api/meditation/favorites` - List favorites
- `POST /api/meditation/tracks/:id/play` - Record play
- `GET /api/meditation/history` - Get history
- `GET /api/meditation/stats` - Get stats

### Calendar
- `GET /api/calendar/events` - List events
- `POST /api/calendar/events` - Create event
- `GET /api/calendar/events/:id` - Get event
- `PUT /api/calendar/events/:id` - Update event
- `DELETE /api/calendar/events/:id` - Delete event
- `POST /api/calendar/events/:id/complete` - Mark complete

### Networking
- `PUT /api/networking/profile` - Update network profile
- `GET /api/networking/discover` - Discover users
- `POST /api/networking/swipe` - Record swipe
- `GET /api/networking/connections` - List connections
- `POST /api/networking/connections/request` - Send request
- `POST /api/networking/connections/:id/accept` - Accept request
- `GET /api/networking/search` - Search users
- `GET /api/networking/user/:id` - Get user profile

### Content
- `GET /api/content/message-of-day` - Get message of the day
- `GET /api/content/videos` - List videos
- `GET /api/content/videos/:id` - Get video
- `POST /api/content/videos/:id/view` - Record view
- `GET /api/content/affirmations` - List affirmations
- `GET /api/content/affirmations/:id` - Get affirmation

### Live Streams
- `GET /api/livestream/streams` - List streams
- `GET /api/livestream/streams/:id` - Get stream
- `POST /api/livestream/streams/:id/join` - Join stream
- `POST /api/livestream/streams/:id/chat` - Send chat message

### Power
- `GET /api/power/categories` - List power categories
- `POST /api/power/select` - Save selections
- `GET /api/power/selected` - Get selections

## Project Structure

```
api/
├── src/
│   ├── modules/          # Feature modules
│   │   ├── auth/         # Authentication
│   │   ├── user/         # User management
│   │   ├── meditation/   # Meditation features
│   │   ├── calendar/     # Calendar events
│   │   ├── networking/   # Social networking
│   │   ├── content/      # Content management
│   │   ├── livestream/   # Live streaming
│   │   └── power/        # Power categories
│   ├── middleware/       # Express middleware
│   ├── lib/              # Shared libraries
│   ├── utils/            # Utility functions
│   ├── app.ts            # Express app setup
│   ├── index.ts          # Server entry point
│   └── config.ts         # Configuration
├── prisma/
│   ├── schema.prisma     # Database schema
│   └── seed.ts           # Seed data
├── dist/                 # Compiled output
└── uploads/              # File uploads

```

## Environment Variables

See `.env.example` for all required environment variables.

## Deployment

### Google Cloud Platform

1. **Cloud SQL**: Create PostgreSQL instance (db-f1-micro for cost efficiency)
2. **Cloud Storage**: Create bucket for media files
3. **Cloud Run**: Deploy containerized API

```bash
# Build and deploy to Cloud Run
gcloud run deploy wizard-api \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

## License

ISC


