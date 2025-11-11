# Cluedo Party - Development Roadmap

## Phase 1: Foundation & Core Setup ✅

### Step 1.1: Project Setup
- [x] Create project structure (Clean Architecture + Feature-First)
- [x] Install Flutter SDK with FVM
- [x] Run `fvm flutter pub get` to install dependencies
- [x] Run `flutter pub run build_runner build` for code generation
- [x] Create Flutter project with platforms (Android, iOS, Windows, Web)
- [x] Implement basic main.dart with Material App
- [x] Verify project runs on Chrome

### Step 1.2: Core Configuration
- [ ] Implement `lib/core/config/theme.dart` (app colors, text styles)
- [ ] Implement `lib/core/constants/game_constants.dart` (default weapons, locations)
- [ ] Implement `lib/core/errors/failures.dart` (error handling classes)
- [ ] Implement `lib/core/errors/exceptions.dart` (custom exceptions)

---

## Phase 2: Game Data Feature (Weapons & Locations)

### Step 2.1: Domain Layer
- [ ] Create `Weapon` entity in `features/game_data/domain/entities/weapon.dart`
- [ ] Create `Location` entity in `features/game_data/domain/entities/location.dart`
- [ ] Define `ItemsRepository` interface
- [ ] Create use cases: `GetWeapons`, `GetLocations`

### Step 2.2: Data Layer
- [ ] Implement `WeaponModel` and `LocationModel` (with JSON serialization)
- [ ] Create `DefaultItemsDataSource` with hardcoded Spanish weapons/locations
- [ ] Create `CustomItemsDataSource` with Hive for user customization
- [ ] Implement `ItemsRepositoryImpl`

### Step 2.3: Presentation Layer
- [ ] Create `ItemsBloc` with events and states
- [ ] Build `CustomizeItemsPage` (optional feature for now)

**Test:** Can retrieve default weapons and locations

---

## Phase 3: Game Setup Feature (Add Players)

### Step 3.1: Domain Layer
- [ ] Create `Player` entity with id, name, isRevealed
- [ ] Create `GameConfig` entity
- [ ] Define `GameSetupRepository` interface
- [ ] Create use cases: `AddPlayer`, `RemovePlayer`, `ValidateGameConfig`

### Step 3.2: Data Layer
- [ ] Implement `PlayerModel` with Hive type adapter
- [ ] Create `LocalGameDataSource` for temporary player storage
- [ ] Implement `GameSetupRepositoryImpl`

### Step 3.3: Presentation Layer
- [ ] Create `GameSetupBloc` with events (AddPlayer, RemovePlayer, StartGame)
- [ ] Build `GameSetupPage` UI:
  - Title "Cluedo Party"
  - Player list with delete buttons
  - "Add Player" FAB
  - "Start Game" button (disabled if < 3 players)
- [ ] Create `AddPlayerDialog` widget
- [ ] Create `PlayerListWidget` with swipe-to-delete

**Test:** Can add/remove players, validate minimum 3 players

---

## Phase 4: Game Engine Feature (Core Logic)

### Step 4.1: Domain Layer - Entities
- [ ] Create `Assignment` entity:
  - killerId, victimId, weaponId, locationId, isRevealed
  - Method: `reveal()`
- [ ] Create `Game` entity:
  - id, players, assignments, createdAt, status

### Step 4.2: Domain Layer - Use Cases
- [ ] **`GenerateAssignments`** (CRITICAL):
  - Input: List of players, weapons, locations
  - Create circular killer-victim chain (no self-assignment)
  - Random weapon/location distribution (no repeats if enough items)
  - Return List<Assignment>
- [ ] `GetPlayerAssignment` (by playerId)
- [ ] `MarkAssignmentRevealed` (update isRevealed flag)

### Step 4.3: Data Layer
- [ ] Implement `AssignmentModel` with Hive
- [ ] Implement `GameModel` with Hive
- [ ] Create `GameStorageDataSource` for saving/loading active game
- [ ] Implement `GameRepositoryImpl`

### Step 4.4: Presentation Layer
- [ ] Create `GameBloc` with states:
  - GameInitial, GameLoading, GameActive, AssignmentRevealed, GameError
- [ ] Build `GameActivePage`:
  - Dropdown with unrevealed players
  - "Show My Assignment" button
  - Warning: "Once revealed, you can't go back"
- [ ] Build `AssignmentRevealPage`:
  - Show killer name
  - "You must kill..."
  - Victim name (large, bold)
  - "With: [weapon]"
  - "At: [location]"
  - "Got it!" button → returns to GameActivePage, removes player from list

**Test:** Generate game with 5 players, reveal assignments one by one

---

## Phase 5: Routing & Navigation

### Step 5.1: Setup GoRouter
- [ ] Implement `lib/core/config/routes.dart`:
  - `/` → GameSetupPage
  - `/game-active` → GameActivePage
  - `/assignment/:playerId` → AssignmentRevealPage

### Step 5.2: Navigation Flow
- [ ] GameSetupPage → "Start Game" → Navigate to GameActivePage
- [ ] GameActivePage → "Show Assignment" → Navigate to AssignmentRevealPage
- [ ] AssignmentRevealPage → "Got it!" → Pop back to GameActivePage

---

## Phase 6: Dependency Injection

### Step 6.1: Setup GetIt
- [ ] Implement `lib/core/di/injection.dart`:
  - Register data sources
  - Register repositories
  - Register use cases
  - Register BLoCs as factories

### Step 6.2: Initialize in main.dart
- [ ] Call `setupDependencies()` before runApp
- [ ] Provide BLoCs to widget tree with BlocProvider

---

## Phase 7: Polish & Testing

### Step 7.1: UI/UX Improvements
- [ ] Add app icon and splash screen
- [ ] Implement Material 3 theme with custom colors
- [ ] Add animations (page transitions, reveal animations)
- [ ] Add confirmation dialogs (delete player, start game)
- [ ] Error handling UI (snackbars, error screens)

### Step 7.2: Testing
- [ ] Unit tests for `GenerateAssignments` use case
- [ ] Unit tests for domain entities
- [ ] Widget tests for main pages
- [ ] Integration test: full game flow

### Step 7.3: Data Persistence
- [ ] Save active game to Hive when app closes
- [ ] Restore active game when app opens
- [ ] Add "New Game" button to reset

**Milestone:** Phase 1 Complete - Single Device MVP Ready! 🎉

---

## Phase 8: Future - Multiplayer (Not Implemented Yet)

### Step 8.1: Choose Backend
- [ ] Decision: Firebase vs Custom Backend vs P2P
- [ ] Setup Firebase project (if chosen)
- [ ] Add Firebase dependencies to pubspec.yaml

### Step 8.2: Multiplayer Feature
- [ ] Implement Room entity and repository
- [ ] Create room lobby UI
- [ ] Implement real-time sync
- [ ] Each player sees only their assignment
- [ ] Host controls game start

---

## Phase 8.5: Localization & Internationalization (i18n)

### Step 8.5.1: Setup Dependencies
- [ ] Add `flutter_localizations` to pubspec.yaml dependencies
- [ ] Add `intl: ^0.18.0` package
- [ ] Create `l10n.yaml` configuration file
- [ ] Add `generate: true` to pubspec.yaml

### Step 8.5.2: Create Translation Files
- [ ] Create `lib/l10n/app_en.arb` (English base file)
- [ ] Create `lib/l10n/app_es.arb` (Spanish translations)
- [ ] Add all app strings to ARB files:
  - App title, buttons, labels
  - Game setup strings (player names, etc.)
  - Game active strings (assignments, weapons, locations)
  - Error messages and validations
- [ ] Run `flutter gen-l10n` to generate code

### Step 8.5.3: Integrate with App
- [ ] Import generated localizations in main.dart
- [ ] Configure `MaterialApp`:
  - Add `localizationsDelegates`
  - Add `supportedLocales` (en, es)
  - Set `locale` handling
- [ ] Replace all hardcoded strings with `AppLocalizations.of(context)!.stringKey`

### Step 8.5.4: Language Selector UI
- [ ] Create settings page/dialog
- [ ] Add language dropdown (English/Español)
- [ ] Persist language preference with SharedPreferences
- [ ] Implement locale change logic

### Step 8.5.5: Localize Game Data
- [ ] Create localized weapon names (candelabro/candlestick, cuchillo/knife)
- [ ] Create localized location names (cocina/kitchen, salón/lounge)
- [ ] Update `DefaultItemsDataSource` to return localized strings
- [ ] Handle custom items (user-defined) - keep as-is

### Step 8.5.6: Testing
- [ ] Test all screens in both languages
- [ ] Verify weapon/location names change
- [ ] Test language persistence across app restarts
- [ ] Check text overflow on different languages

**Estimated Time: 4-6 hours**

**Note**: Consider adding more languages in the future (French, German, etc.)

---

## Quick Start Checklist (First Day)

```bash
# 1. Install dependencies
fvm flutter pub get

# 2. Run code generation (when you add Hive models)
fvm flutter pub run build_runner build --delete-conflicting-outputs

# 3. Run the app (will show errors until you implement main.dart)
fvm flutter run

# 4. Start with Phase 1.2 (Core Configuration)
# 5. Then move to Phase 2 (Game Data)
# 6. Then Phase 3 (Game Setup UI)
# 7. Then Phase 4 (Game Engine - the fun part!)
```

---

## Development Tips

- **Work vertically**: Complete one feature end-to-end (domain → data → presentation)
- **Test as you go**: After each step, run the app and test manually
- **Commit often**: After each completed step
- **Domain first**: Always implement domain layer before data/presentation
- **Use hot reload**: `r` in terminal to hot reload, `R` to hot restart

---

## Estimated Time

- Phase 1-2: 2-3 hours (setup + game data)
- Phase 3: 3-4 hours (player setup UI)
- Phase 4: 5-6 hours (game engine logic - most complex)
- Phase 5-6: 2-3 hours (routing + DI)
- Phase 7: 4-5 hours (polish + testing)
- **Phase 8: Future - Multiplayer** (TBD, complex feature)
- **Phase 8.5: Localization** (4-6 hours)

**Total MVP (Phase 1-7): ~20-25 hours**  
**With Localization: ~24-31 hours**
