# Diary App

Simple personal diary built with Flutter + Drift. The project demonstrates a clean architecture setup with clear data/domain/presentation layers, error-first use cases, and automated tests.

## Project Structure

```
lib/
  core/              # cross-cutting concerns (error types, extensions, theme)
  data/              # datasource + repository implementations
  domain/            # entities, repository contracts, use cases
  presentation/      # UI layer (widgets, blocs, etc.)
test/                # data + domain tests (datasource, repository, use cases)
```

Key flows:

- **Data layer** uses Drift (`lib/data/datasoure/local`) for local persistence and maps database rows to domain entities.
  - `DiaryRecords` keeps entry metadata.
  - `DiaryMediaRecords` stores attachment metadata (relative path, mime/size/dimensions) bound to a diary entry and is pruned automatically when diaries are deleted.
- **Domain layer** exposes `DiaryRepository` and focused use cases (`lib/domain/usecase/diary`) that validate inputs and provide localized error messages.
- **Presentation layer** (not covered here) consumes the use cases via dependency injection (`injectable` + `get_it`).
  - The create diary flow allows selecting up to three images, showing inline previews before submission.

## Prerequisites

- Flutter 3.19+ (Dart 3.9)
- `flutter pub get`

## Run the App

```bash
flutter run
```

## Run Tests

```bash
flutter test
```

Useful focused tests:

```bash
flutter test test/data/datasoure/local/diary/local_diary_datasource_impl_test.dart
flutter test test/data/repository/diary_repository_impl_test.dart
flutter test test/domain/usecase/diary/diary_usecases_test.dart
flutter test test/presentation/provider/diary/create/create_diary_cubit_test.dart
```

### Repository Test Coverage

`test/data/repository/diary_repository_impl_test.dart` exercises the full repository contract (see `test/README.md` for details across every test suite):

- `create` writes a new diary row and surfaces datasource failures.
- `findById` returns persisted entries or `null` when absent.
- `getDiaryDetail` hydrates diary metadata with media assets, preserving absolute/relative paths and image dimensions; also handles missing diary ids and friendly error mapping.
- `fetchEntries` and `searchByTitle` respect cursor pagination and keyword filtering order.
- `update` mutates an existing diary, while `delete` removes it from both storage and database.
- `uploadMediaFiles` saves image bytes, records dimensions/size/sort order, and ensures the stored file exists.
- `watchAll` streams the diary list and propagates datasource failures as `Failure`s.

## Seed Local Data

Need demo content in the embedded SQLite DB? Run the seeding entrypoint on an emulator or device:

```bash
# default 12 rows
flutter run -d <device-id> -t tool/seed_diary_entries.dart

# customise the amount
flutter run -d <device-id> -t tool/seed_diary_entries.dart --dart-define=SEED_COUNT=20
```

You can predefine specific rows by editing `_manualEntries` inside `tool/seed_diary_entries.dart`.

## Code Generation

This project uses build_runner for drift tables, `copy_with` extensions, and injectable configuration. Regenerate when model/schema changes:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Tech Stack

- Flutter, Dart
- Drift (SQLite persistence)
- Injectable + GetIt (DI)
- Dartz (Either-based error handling)
- AutoRoute (typed navigation + transitions)
- Equatable / copy_with_extension

## Error Handling

- `Failure` encapsulates app errors and provides factories (`Failure.validation`, `Failure.fromCode`).
- Use cases validate inputs before touching the repository and convert error codes into localized messages.

## License

MIT
