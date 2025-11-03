# BranchOut - Developer Matching Platform

A Tinder-style matching app for developers to find collaborators, co-founders, mentors, mentees, and networking opportunities.

## Project Structure

```
.
├── app/          # Flutter mobile application
└── server/       # Node.js + Express backend
```

## Features

- 🔐 Google OAuth authentication
- 👤 Developer profiles with tech stack and projects
- 💚 Swipe-based matching system
- 💬 Real-time chat with code snippet sharing
- 🎯 Advanced filtering and discovery
- ⭐ Premium features (unlimited swipes, project marketplace)
- 🔔 Real-time notifications

## Tech Stack

### Backend

- Node.js + Express + TypeScript
- MongoDB + Prisma ORM
- Socket.io for real-time features
- Passport.js for OAuth
- JWT authentication

### Frontend (Flutter)

- Flutter with Riverpod state management
- Dio for HTTP requests
- Socket.io client for real-time
- Material Design 3 with custom olive theme

## Getting Started

### Prerequisites

- Node.js 18+
- Flutter 3.9+
- MongoDB

### Backend Setup

1. Navigate to server directory:

```bash
cd server
```

2. Install dependencies:

```bash
npm install
```

3. Configure environment variables:

```bash
cp .env.example .env
# Edit .env with your configuration
```

4. Generate Prisma client:

```bash
npm run prisma:generate
```

5. Run migrations:

```bash
npm run prisma:migrate
```

6. Start development server:

```bash
npm run dev
```

Server will run on http://localhost:3000

### Flutter App Setup

1. Navigate to app directory:

```bash
cd app
```

2. Install dependencies:

```bash
flutter pub get
```

3. Configure environment variables:

```bash
cp .env.example .env
# Edit .env with your API URLs
```

4. Run the app:

```bash
flutter run
```

## Environment Variables

### Backend (.env)

- `PORT` - Server port (default: 3000)
- `DATABASE_URL` - MongoDB connection string
- `JWT_SECRET` - Secret key for JWT tokens
- `GOOGLE_CLIENT_ID` - Google OAuth client ID
- `GOOGLE_CLIENT_SECRET` - Google OAuth client secret
- `UPLOADTHING_SECRET` - UploadThing API secret
- `GITHUB_TOKEN` - GitHub API token
- `POLAR_API_KEY` - Polar.sh API key

### Flutter (.env)

- `API_BASE_URL` - Backend API URL
- `SOCKET_URL` - Socket.io server URL

## API Endpoints

### Authentication

- `GET /api/auth/google` - Initiate Google OAuth
- `GET /api/auth/google/callback` - OAuth callback
- `GET /api/auth/me` - Get current user
- `POST /api/auth/logout` - Logout

### Users

- `GET /api/users/profile/:id` - Get user profile
- `PUT /api/users/profile` - Update profile
- `DELETE /api/users/account` - Delete account
- `GET /api/users/discover` - Get profiles to swipe

### Swipes & Matches

- `POST /api/swipes` - Record a swipe
- `GET /api/swipes/matches` - Get all matches

### Messages

- `GET /api/messages/:matchId` - Get messages for a match
- `POST /api/messages` - Send a message
- `PUT /api/messages/:id/read` - Mark message as read

## Development

### Backend

```bash
cd server
npm run dev        # Start development server
npm run build      # Build for production
npm start          # Start production server
```

### Flutter

```bash
cd app
flutter run        # Run on connected device
flutter build apk  # Build Android APK
flutter build ios  # Build iOS app
```

## License

MIT
