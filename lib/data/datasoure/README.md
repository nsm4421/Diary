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

## 공유 환경설정 (SharedPreferences)
- `lib/data/datasoure/shared_preference/settings_preferences_datasource.dart` 는 다크모드 여부와 같이 가벼운 설정 값을 `SharedPreferences`에 저장합니다.
- 불러오기(`getIsDarkMode`)와 저장(`setIsDarkMode`) 모두 비동기 Future 로 노출되어 있어 앱 시작 시 초기화하거나 설정 화면에서 토글한 값이 바로 반영되도록 설계돼 있습니다.
- `LocalDatasourceModule` 에서 `SharedPreferences` 인스턴스를 `@preResolve` 로 준비하므로, 의존성 주입 시점에 한 번만 읽고 재사용합니다.

## 보안 저장소 (Flutter Secure Storage)
- 민감한 값(예: 잠금 비밀번호 해시)을 저장하기 위해 `lib/data/datasoure/secure_storage/password_secure_storage_datasource.dart` 를 추가했습니다.
  - 내부 구현(`…_impl.dart`)은 `FlutterSecureStorage`를 사용하며 iOS Keychain/Android EncryptedSharedPreferences 옵션을 기본 적용합니다.
  - 공개 메서드는 `savePasswordHash`, `fetchPasswordHash`, `clearPassword` 세 가지이며, 반드시 **해시 등 복호화가 불필요한 형태**로 넘겨주는 것을 권장합니다.
- 동일한 값을 도메인에서 간편하게 다루도록 `lib/data/repository/password_repository_impl.dart` 와 `lib/domain/repository/security/password_repository.dart` 를 제공하여, 이후 유스케이스에서 의존성만 주입하면 됩니다.
