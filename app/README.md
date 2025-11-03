# BranchOut Flutter App

Flutter mobile application for BranchOut developer matching platform.

## Setup

1. Install dependencies:

```bash
flutter pub get
```

2. Configure environment:

```bash
cp .env.example .env
# Edit .env with your API URLs
```

3. Run the app:

```bash
flutter run
```

## Project Structure

```
lib/
├── app/                 # App-wide configuration
│   ├── routes.dart      # Navigation routes
│   ├── theme.dart       # Theme configuration
│   └── constants.dart   # App constants
├── core/                # Core functionality
│   ├── network/         # API client
│   ├── storage/         # Local storage
│   └── error/           # Error handling
├── features/            # Feature modules
│   ├── auth/            # Authentication
│   ├── discover/        # Profile discovery
│   ├── matches/         # Matches list
│   ├── profile/         # User profile
│   └── chat/            # Messaging
└── shared/              # Shared widgets & utils
```

## Features

- Clean architecture with feature-based structure
- Riverpod for state management
- Dio for HTTP requests
- Socket.io for real-time chat
- Material Design 3 with custom theme
- Environment-based configuration
