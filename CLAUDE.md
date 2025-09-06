# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TravelMate is a Flutter-based travel agency platform with AI-powered features and comprehensive booking system. The project follows Clean Architecture principles with clear separation of concerns.

## Development Commands

### Setup
```bash
flutter pub get                    # Install dependencies
flutter packages pub run build_runner build  # Generate code
```

### Running the App
```bash
flutter run                       # Run in development mode
flutter run --release             # Run in release mode
flutter run --flavor dev          # Run with dev environment
flutter run --flavor staging      # Run with staging environment
flutter run --flavor prod         # Run with production environment
```

### Code Generation
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Internationalization
```bash
flutter gen-l10n                  # Generate localization files
```

### Code Quality
```bash
flutter analyze                   # Run static analysis
flutter format .                  # Format code
```

## Architecture

The project follows Clean Architecture with these layers:

### Core Layer (`lib/core/`)
- **constants/**: App-wide constants (API endpoints, colors, strings)
- **themes/**: UI themes and styling
- **utils/**: Utility functions and helpers
- **environment/**: Environment configuration management

### Data Layer (`lib/data/`)
- **api/**: REST API clients using Retrofit and Dio
- **models/**: Data models for JSON serialization
- **repositories/**: Repository implementations (API + local storage)

### Domain Layer (`lib/domain/`)
- **entities/**: Pure business objects
- **usecases/**: Business logic operations

### Presentation Layer (`lib/presentation/`)
- **screens/**: Full-screen widgets organized by feature
- **widgets/**: Reusable UI components
- **providers/**: State management using Riverpod

### Services Layer (`lib/services/`)
- **ai/**: AI services (Dialogflow, ML Kit)
- **notifications/**: Push and local notifications
- **payments/**: Payment integration (Iamport, Bootpay)

## Key Technologies

- **State Management**: Riverpod + Provider
- **HTTP Client**: Dio + Retrofit
- **Authentication**: Firebase Auth + Google Sign In
- **Payments**: Iamport + Bootpay
- **AI/ML**: Dialogflow + Google ML Kit
- **Database**: SQLite + Shared Preferences + Hive
- **Internationalization**: 4 languages (Korean, English, Chinese, Japanese)

## Environment Configuration

The app supports three environments with separate configuration files:
- `.env.dev` - Development
- `.env.staging` - Staging  
- `.env.prod` - Production

Use `AppEnvironment.initialize(Environment.development)` to set the environment.

## Code Generation

Run code generation after modifying:
- API services (Retrofit)
- Data models (JSON serializable)
- Database models (Hive)

## Important Notes

- **Testing**: Test infrastructure is set up but no tests are currently implemented
- **Linting**: Uses default Flutter linting rules via `flutter_lints` package
- **Real-time Features**: Socket.io is integrated for real-time communication
- **Assets**: Located in `assets/` with subdirectories for fonts, icons, and images
- **Localization**: ARB files are in `l10n/` directory for 4 supported languages