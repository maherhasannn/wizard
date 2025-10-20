# Quick Start Guide

## Prerequisites

- Node.js 18+ installed
- PostgreSQL database running
- Flutter SDK installed
- iOS Simulator or Android Emulator (or physical device)

---

## Step 1: Set Up Backend Database

1. Create a PostgreSQL database:
```bash
createdb wizard_db
```

2. Create `.env` file in `api/` directory:
```bash
cd /Users/madhavsoni/Documents/GitHub/wizard/api
cat > .env << 'EOF'
DATABASE_URL="postgresql://your_user:your_password@localhost:5432/wizard_db"
JWT_SECRET="your-super-secret-jwt-key-change-this-in-production"
JWT_REFRESH_SECRET="your-super-secret-refresh-key-change-this-in-production"
NODE_ENV="development"
PORT=3000
EOF
```

3. Run database migrations:
```bash
npx prisma migrate dev --name init
```

4. Seed the database with sample data:
```bash
npx prisma db seed
```

---

## Step 2: Start the Backend API

```bash
cd /Users/madhavsoni/Documents/GitHub/wizard/api
npm install
npm run dev
```

The API should now be running at `http://localhost:3000`

Test it:
```bash
curl http://localhost:3000/api/meditation/tracks
```

---

## Step 3: Run the Mobile App

### For iOS Simulator:

```bash
cd /Users/madhavsoni/Documents/GitHub/wizard/mobile
open -a Simulator
flutter run
```

### For Android Emulator:

```bash
cd /Users/madhavsoni/Documents/GitHub/wizard/mobile
# Start your Android emulator first
flutter run
```

### For Custom API URL:

If your API is not at `localhost:3000`:

```bash
flutter run --dart-define=API_URL=https://your-api-url.com/api
```

---

## Step 4: Test the Integration

1. **Register a new account:**
   - The app should show login screen initially
   - Tap "Sign Up"
   - Fill in email and password (name optional)
   - Tap "Sign Up"

2. **Browse Meditations:**
   - Navigate to Meditations tab (second tab)
   - Should see tracks loaded from API
   - Try switching categories (audio, music, sleep)
   - Try favoriting a track

3. **Check Loading States:**
   - Pull to refresh should show loading indicator
   - Errors should show with retry button

---

## Troubleshooting

### Backend Issues

**Database connection error:**
```bash
# Check if PostgreSQL is running
pg_isready

# Check DATABASE_URL in .env file
cat api/.env
```

**Port already in use:**
```bash
# Change PORT in api/.env
# Or kill the process using port 3000
lsof -ti:3000 | xargs kill
```

### Mobile App Issues

**Dependencies not found:**
```bash
cd mobile
flutter clean
flutter pub get
```

**Can't connect to API:**
- Make sure backend is running
- For iOS simulator, use `http://localhost:3000/api`
- For Android emulator, use `http://10.0.2.2:3000/api`

To use Android emulator IP:
```bash
flutter run --dart-define=API_URL=http://10.0.2.2:3000/api
```

**Build errors:**
```bash
# iOS
cd ios && pod install && cd ..
flutter clean
flutter run

# Android
flutter clean
flutter run
```

---

## What's Working

✅ **Backend API**
- All endpoints functional
- Transaction bug fixed
- Authentication with JWT
- Complete database schema

✅ **Mobile App**
- ✅ Authentication (login/register)
- ✅ Meditations tab (loads from API)
- ✅ State management with Provider
- ✅ Error handling and loading states
- ✅ Secure token storage

⚠️ **Needs Implementation**
- Home tab widgets (videos, affirmations, etc.)
- Calendar tab integration
- Networking tab
- Profile editing

---

## Development Tips

### Hot Reload

While developing, Flutter supports hot reload:
- Press `r` in terminal to reload
- Press `R` to hot restart
- Press `q` to quit

### API Development

Backend uses nodemon for auto-reload:
```bash
# In api/ directory
npm run dev
# Changes to TypeScript files will auto-reload
```

### View Database

```bash
cd api
npx prisma studio
```

Opens a GUI at `http://localhost:5555` to browse your database.

---

## Next Steps

See `IMPLEMENTATION_COMPLETE.md` for:
- Detailed architecture
- Remaining features to implement
- API endpoint reference
- Testing guide

---

## Quick Commands Reference

```bash
# Backend
cd /Users/madhavsoni/Documents/GitHub/wizard/api
npm run dev              # Start development server
npx prisma migrate dev   # Run migrations
npx prisma db seed       # Seed database
npx prisma studio        # Open database GUI

# Mobile
cd /Users/madhavsoni/Documents/GitHub/wizard/mobile
flutter run              # Run app
flutter clean            # Clean build
flutter pub get          # Install dependencies
flutter doctor           # Check setup

# Database
createdb wizard_db       # Create database
dropdb wizard_db         # Delete database (careful!)
psql wizard_db           # Connect to database
```

---

## Support

If you encounter issues:
1. Check this guide's Troubleshooting section
2. Review `IMPLEMENTATION_COMPLETE.md`
3. Check backend logs in terminal
4. Check mobile app logs in flutter console


