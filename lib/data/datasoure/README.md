# Local Datasource Overview

This document summarizes how the local persistence layer is organized and how the pieces interact. The implementation lives under `lib/data/datasoure/local`, with tests in `test/data/datasoure/local`.

## Database Layer
- `lib/data/datasoure/local/database/local_database.dart` wires up Drift with the `DiaryRecords` table (`schema/diary_table.dart`).
- `DiaryMediaRecords` (`schema/diary_media_table.dart`) stores metadata about media files that belong to a diary row. It references `DiaryRecords` via `diaryId` with cascade rules so orphaned media is removed when a diary disappears.
- `LocalDatabase()` lazily opens a file-backed SQLite DB. `LocalDatabase.test()` spins up an in-memory DB for fast tests.
- `LocalDatabaseDao` (drift accessor) exposes typed helpers used by higher layers.
- The `DiaryRecords` table stores diary metadata: UUID `id`, timestamps, `date` (YYYY-MM-DD), `isTemp`, optional `title`, and `content`.

## Diary Data Source
- Interface: `LocalDiaryDataSource` (`lib/data/datasoure/local/diary/local_diary_datasource.dart`) defines the contract used by the domain layer, exposing optional `transaction` parameters so multiple calls can participate in the same Drift transaction when required.
- Implementation: `LocalDiaryDataSourceImpl` performs all CRUD operations through the DAO:
  - `create` inserts via `DiaryRecordsCompanion`, stamping `createdAt`, `updatedAt`, and `date` using `DateTimeExtension.yyyymmdd`. When attachments are present it also batches `DiaryMediaRecordsCompanion` inserts using the same transaction.
  - `fetchRows` paginates ordered by `createdAt DESC`.
  - `findById` looks up rows by diary `id`, optionally reusing a provided transaction.
  - `searchByTitle` performs LIKE queries with validation for keyword/limits.
  - `watchAll` streams the table ordered by `createdAt DESC`.
  - `update` writes title/content and bumps `updatedAt`, throwing when no row matches. Supports external transactions.
  - `delete` removes by diary `id`, throwing when nothing is deleted. Media rows are cleaned up in the same transaction. Supports external transactions.
- DTOs for create/update requests live in `lib/data/datasoure/local/diary/dto.dart` (Freezed + JSON serializable).

## Testing
- Comprehensive unit tests cover every data source method: `test/data/datasoure/local/diary/local_diary_datasource_impl_test.dart`.
- Tests construct `LocalDatabase.test()` + `LocalDatabaseDao`, seed rows with helper functions, and exercise success/error paths (pagination, validation, watch streams, media cascading, etc.).
- Run them with:
  ```bash
  flutter test test/data/datasoure/local/diary/local_diary_datasource_impl_test.dart
  ```
