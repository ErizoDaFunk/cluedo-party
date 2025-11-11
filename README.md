# Cluedo Party

A Flutter mobile application for organizing Cluedo-style party games where players assassinate each other with weapons in specific locations.

## Architecture

This project follows **Clean Architecture** with **Feature-First** organization and uses **BLoC** for state management.

### Project Structure

```
lib/
├── core/                    # Shared utilities and configuration
│   ├── config/             # Theme, routes
│   ├── constants/          # App constants
│   ├── di/                 # Dependency injection
│   ├── errors/             # Error handling
│   └── utils/              # Helper utilities
│
├── features/               # Feature modules
│   ├── game_setup/        # Player setup and game configuration
│   ├── game_engine/       # Core game logic and assignment generation
│   ├── game_data/         # Weapons and locations catalog
│   └── multiplayer/       # Multi-device support (future)
│
└── main.dart
```

### Features

#### Phase 1: Single Device
- ✅ Add/remove players
- ✅ Generate random assignments (killer-victim circular chain)
- ✅ Reveal assignments one by one
- ✅ Custom weapons and locations
- ✅ Offline-first architecture

#### Phase 2: Multi-Device (Future)
- 🔲 Create/join game rooms
- 🔲 Real-time synchronization
- 🔲 Each player sees only their assignment
- 🔲 Firebase or WebSocket support

## Tech Stack

- **Framework**: Flutter 3.0+
- **State Management**: flutter_bloc
- **Dependency Injection**: get_it + injectable
- **Routing**: go_router
- **Local Storage**: hive + shared_preferences
- **Functional Programming**: dartz (Either)

## Getting Started

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run code generation:
   ```bash
   flutter pub run build_runner build
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Architecture Principles

### Clean Architecture Layers

1. **Domain** (Business Logic)
   - Pure Dart, no external dependencies
   - Entities, Use Cases, Repository Interfaces
   - Framework-agnostic

2. **Data** (Implementation)
   - Repository implementations
   - Data sources (local/remote)
   - Models with serialization

3. **Presentation** (UI)
   - Flutter widgets
   - BLoC for state management
   - Pages and reusable widgets

### Dependency Rule
- Domain depends on nothing
- Data and Presentation depend on Domain
- Outer layers know about inner layers, but not vice versa

## Testing

Run unit tests:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

## Future Enhancements

- Firebase integration for multiplayer
- Custom themes
- Game history and statistics
- Multi-language support
- iOS and Web versions

## License

This project is for personal use.
