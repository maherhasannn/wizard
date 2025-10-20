# Wizard API Setup Guide

This guide will help you set up and run the Wizard API backend.

## Prerequisites

- Node.js 20+ and npm 10+
- PostgreSQL database (local or cloud)
- Google Cloud Platform account (for production deployment)

## Quick Start

### 1. Install Dependencies

```bash
cd /Users/madhavsoni/Documents/GitHub/wizard/api
npm install
```

### 2. Configure Environment

Create a `.env` file based on `.env.example`:

```bash
cp .env.example .env
```

Edit `.env` with your configuration:

```env
DATABASE_URL="postgresql://user:password@localhost:5432/wizard?schema=public"
JWT_SECRET=your-secret-key-here
JWT_REFRESH_SECRET=your-refresh-secret-here
```

### 3. Setup Database

```bash
# Generate Prisma client
npm run prisma:generate

# Run migrations (recommended - creates migration history)
npm run migrate:dev

# This will:
# - Create a migrations directory if it doesn't exist
# - Generate an initial migration from your schema
# - Apply the migration to your database
# - Automatically run prisma:generate

# Seed database with sample data
npm run db:seed
```

**Note**: We use migrations instead of `db:push` to maintain a proper migration history, which is essential for production deployments and team collaboration.

### 4. Run Development Server

```bash
npm run dev
```

The API will be running at `http://localhost:8080`

## Testing the API

### Health Check

```bash
curl http://localhost:8080/health
```

### Register a New User

```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "firstName": "Test",
    "lastName": "User"
  }'
```

### Login

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "gabriella@wizard.app",
    "password": "password123"
  }'
```

### Get Meditation Tracks (authenticated)

```bash
curl http://localhost:8080/api/meditation/tracks \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

## Database Management

### View Data in Prisma Studio

```bash
npm run prisma:studio
```

This opens a web interface at `http://localhost:5555` to view and edit your database.

### Migration Commands

```bash
# Create and apply a new migration after schema changes
npm run migrate:dev

# Apply pending migrations in production
npm run migrate:deploy

# Reset database (drops all data, re-runs all migrations, and seeds)
npm run migrate:reset

# Create a migration without applying it
npx prisma migrate dev --create-only

# View migration status
npx prisma migrate status
```

**When to use each command:**
- `migrate:dev` - Use during development when you change the schema
- `migrate:deploy` - Use in production to apply migrations
- `migrate:reset` - Use to completely reset your local database

## Available Endpoints

### Authentication (`/api/auth`)
- `POST /register` - Register new user
- `POST /login` - Login user
- `POST /refresh` - Refresh access token
- `POST /forgot-password` - Request password reset
- `POST /reset-password` - Reset password
- `GET /me` - Get current user (authenticated)

### User (`/api/user`)
- `GET /profile` - Get user profile
- `PUT /profile` - Update profile
- `POST /upload-photo` - Upload profile photo
- `GET /settings` - Get settings
- `PUT /settings` - Update settings
- `DELETE /account` - Delete account

### Meditation (`/api/meditation`)
- `GET /tracks` - List tracks
- `GET /tracks/:id` - Get track details
- `POST /tracks/:id/favorite` - Add to favorites
- `DELETE /tracks/:id/favorite` - Remove favorite
- `GET /favorites` - List favorites
- `POST /tracks/:id/play` - Record play
- `GET /history` - Get history
- `GET /stats` - Get stats

### Calendar (`/api/calendar`)
- `GET /events` - List events
- `POST /events` - Create event
- `GET /events/:id` - Get event
- `PUT /events/:id` - Update event
- `DELETE /events/:id` - Delete event
- `POST /events/:id/complete` - Mark complete
- `GET /upcoming` - Get upcoming events

### Networking (`/api/networking`)
- `PUT /profile` - Update network profile
- `GET /discover` - Discover users
- `POST /swipe` - Record swipe
- `GET /connections` - List connections
- `POST /connections/request` - Send request
- `POST /connections/:id/accept` - Accept request
- `POST /connections/:id/reject` - Reject request
- `GET /search` - Search users
- `GET /user/:id` - Get user profile
- `POST /location` - Update location

### Content (`/api/content`)
- `GET /message-of-day` - Get message of the day
- `GET /videos` - List videos
- `GET /videos/:id` - Get video
- `POST /videos/:id/view` - Record view
- `GET /affirmations` - List affirmations
- `GET /affirmations/:id` - Get affirmation
- `POST /affirmations/:id/interact` - Record interaction

### Live Streams (`/api/livestream`)
- `GET /streams` - List streams
- `GET /streams/:id` - Get stream
- `POST /streams/:id/join` - Join stream
- `POST /streams/:id/leave` - Leave stream
- `POST /streams/:id/chat` - Send chat message
- `GET /streams/:id/chat` - Get chat messages

### Power (`/api/power`)
- `GET /categories` - List power categories
- `POST /select` - Save selections
- `GET /selected` - Get selections

## Seed Data

The database is seeded with:
- **30 users**: Including test user `gabriella@wizard.app` (password: `password123`)
  - All users have pre-configured settings
  - Ready to login and test immediately
- **50 meditation tracks**: Various categories (Audio, Music, Sleep)
- **10 power categories**: Different focus areas for personal development
- **20 videos**: Tutorial and practice videos
- **30 affirmations**: Daily affirmations
- **7 messages of the day**: For the next week
- **2 live streams**: One scheduled, one active

## Production Deployment

### Google Cloud Platform

1. **Create Cloud SQL PostgreSQL instance**
   ```bash
   gcloud sql instances create wizard-db \
     --database-version=POSTGRES_15 \
     --tier=db-f1-micro \
     --region=us-central1
   ```

2. **Create database**
   ```bash
   gcloud sql databases create wizard \
     --instance=wizard-db
   ```

3. **Deploy to Cloud Run**
   ```bash
   gcloud run deploy wizard-api \
     --source . \
     --platform managed \
     --region us-central1 \
     --allow-unauthenticated
   ```

## Troubleshooting

### Port already in use

If port 8080 is already in use, change the `PORT` in your `.env` file:

```env
PORT=3000
```

### Database connection issues

Make sure your PostgreSQL server is running and the `DATABASE_URL` is correct.

### Prisma Client errors

If you encounter Prisma Client errors, regenerate the client:

```bash
npm run prisma:generate
```

## Next Steps

1. Configure GCS for file uploads
2. Setup email service for verification and password reset
3. Configure rate limiting for production
4. Setup monitoring and logging
5. Implement caching for frequently accessed data

## Support

For issues or questions, refer to the main README or contact the development team.


