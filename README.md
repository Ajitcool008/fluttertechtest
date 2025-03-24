# flutter_tech_task

A Flutter project demonstration implementation of CLEAN architecture with Stacked for state management.

## Key Features
- View posts from JSONPlaceholder
- Tap on a post to see its details
- Save posts for offline reading
- View comments on posts and that is also stored for offline
- View saved posts in a separate tab
- See how many posts are saved with the tab badge

## Technical Info
The app is built with separation of concerns in mind, following CLEAN architecture:

**Domain Layer** contains the business logic and rules:
- Entities (Post, Comment)
- Use Cases to handle business operations
- Repository interfaces

**Data Layer** manages data retrieval and storage:
- Data models
- Repository implementations
- Remote data source (API)
- Local data source (SharedPreferences)

**Presentation Layer** handles the UI:
- Stacked ViewModels
- Views
- UI Services

## Implementation Details
- Used Stacked architecture for state management
- Implemented dependency injection with GetIt
- Saved posts with SharedPreferences for offline access
- Added localization support for English and Spanish
- Included proper error handling with retry mechanisms
- Added offline capability for saved posts and comments

## Testing
The app has three levels of testing:
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for complete user flows

## Setup
1. Clone the repo
2. Run `flutter pub get`
4. Start the app with `flutter run`

## Tech Stack
- Flutter
- Stacked for MVVM
- HTTP for API calls
- SharedPreferences for local storage
- GetIt for dependency injection
- Dartz for functional error handling
