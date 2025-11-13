# Diary App

Offline-first personal journal built with Flutter, Drift, and a layered architecture. Entries live in a local SQLite database, attachments are stored on disk, and the whole stack is covered by unit tests across data, domain, and presentation layers.

## Highlights
- Offline storage via Drift + local file system, so entries and media are available without a network connection.
- Search pipeline supports free-text (title/content) and date-range filtering with cursor-based pagination.
- Passcode gate (secure storage + cubits) protects the diary list when enabled.
- Clean architecture boundaries with injectable/get_it DI, AutoRoute navigation, and Flutter Bloc state management.
- Extensive automated tests (see `test/README.md`) keep regressions out of the repository.

## Architecture Overview

```
Widgets / Cubits (presentation)
        │
        ▼
  Diary Use Cases (domain)
        │
        ▼
 DiaryRepository (domain contract)
        │
        ▼
Local datasources (Drift DB, file system, secure storage, shared prefs)
```

- **Presentation (`lib/presentation`)** – Widgets, feature pages, and Cubits built on `flutter_bloc`. Navigation is powered by AutoRoute.
- **Domain (`lib/domain`)** – Entities, repository contracts, value objects (constraints, pageable), and use cases. Failures are normalized here.
- **Data (`lib/data`)** – Drift DAOs, file-system/secure-storage datasources, and repository implementations that translate raw results into domain entities.
- **Core (`lib/core`)** – Cross-cutting helpers: error handling mixins, extensions, logging utilities, and constants.

## Directory Map

```
lib/
  core/                        # error handling, extensions, logging
  data/
    datasoure/
      database/                # Drift tables, DAO, LocalDiaryDbDataSource
      fs/                      # Local file system storage for media
      secure_storage/          # Password storage via FlutterSecureStorage
      shared_preference/       # Lightweight app settings (e.g. theme)
    repository/                # Diary/password repository implementations
  domain/
    entity/                    # Diary + detail models
    repository/                # Contracts + request DTOs
    usecase/                   # DiaryUseCases entry point + scenarios
  presentation/
    pages/                     # Feature screens
    provider/                  # Cubits/BLoCs (diary flows, security)
    components/                # Reusable UI widgets
    router/                    # AutoRoute definitions
test/
  data/                        # Drift + repository specs
  domain/                      # Use-case tests
  presentation/                # Cubit tests
  helpers/                     # test utilities (loggers, fixtures)
tool/
  seed_diary_entries.dart      # CLI for seeding demo content
```

Additional deep dives:
- `lib/data/datasoure/README.md` – storage/DAO details.
- `test/README.md` – inventory of every suite with behaviour notes.

## Key Workflows

### Diary CRUD + Media Storage
- `_FetchDiariesUseCase` delegates to `DiaryRepository` which, in turn, calls `LocalDiaryDbDataSource` for all SQL work.
- `DiaryRepositoryImpl.create/update` also talks to `LocalDiaryFsDataSource` to persist media bytes, derive image metadata, and sync the `DiaryMediaRecords` table.
- `watchAll` exposes a stream backed by Drift queries; errors are mapped to `Failure` instances before hitting the UI.

### Search & Pagination
- `FetchDiaryParam` + `SearchDiaryKind` capture the active search mode: `none`, `title`, `content`, or `dateRange`.
- Repository methods (`fetchDiaries`, `searchByTitle`, `searchByContent`, `searchByDateRange`) all accept a `cursor` timestamp and `limit` to enforce deterministic pagination.
- Date-range filters are inclusive of both `start` and `end` dates and rely on the persisted `date` column (`YYYY-MM-DD`) for efficient comparisons.

### Password Lock Flow
- `PasswordSetupPage` and `PasswordGatePage` live under `lib/presentation/pages/security`. They rely on `PasswordSetupCubit` / `PasswordLockCubit`.
- Hashes are stored via `PasswordSecureStorageDataSource` (Flutter Secure Storage). Clearing a diary removes the associated passcode as well.
- Tests ensure both cubits handle happy paths and error propagation.

### Settings & Preferences
- Non-sensitive settings (such as dark-mode flags) live in `SharedPreferences` through `SettingsPreferencesDataSource`.
- Dependencies are assembled inside `LocalDatasourceModule` so the same instances are injected across the app.

## Development Workflow

### Prerequisites
- Flutter 3.19+ (Dart 3.9).
- Xcode/Android toolchains if you plan to run on device/emulator.

### Bootstrap
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run
```bash
flutter run
```

### Recommended Commands
```bash
flutter analyze
dart format lib test
flutter test
```

## Testing

Core suites (run individually when iterating):

```bash
# Data Layer
flutter test test/data/datasoure/database/local_diary_db_datasource_impl_test.dart
flutter test test/data/datasoure/fs/local_diary_fs_datasource_impl_test.dart
flutter test test/data/repository/diary_repository_impl_test.dart

# Domain Layer
flutter test test/domain/usecase/diary/diary_usecases_test.dart

# Presentation Layer
flutter test test/presentation/provider/diary/create/create_diary_cubit_test.dart
flutter test test/presentation/provider/security/password_setup/password_setup_cubit_test.dart
flutter test test/presentation/provider/security/password_lock/password_lock_cubit_test.dart
```

Refer to `test/README.md` for the full matrix and behavioural notes for each spec file.

## Seed Local Data

Populate the local database with demo entries and attachments:

```bash
# Default 12 rows
flutter run -d <device-id> -t tool/seed_diary_entries.dart

# Custom amount
flutter run -d <device-id> -t tool/seed_diary_entries.dart --dart-define=SEED_COUNT=20
```

Edit `_manualEntries` in `tool/seed_diary_entries.dart` to craft deterministic fixtures.

## Tooling & Libraries
- Drift + sqlite3_flutter_libs for persistence.
- image/image_picker for media handling.
- flutter_bloc + bloc_concurrency for state.
- injectable + get_it for DI.
- AutoRoute for navigation.
- Flutter Secure Storage + SharedPreferences for device storage.
- dartz for `Either`, equatable/copy_with_extension for value objects.

## Error Handling
- `ErrorHandlerMixIn` wraps repository calls with a `guard` helper to convert thrown `AppException`s into typed `Failure`s.
- Use cases enrich these failures with user-friendly messages before returning to the UI.

## License

MIT
