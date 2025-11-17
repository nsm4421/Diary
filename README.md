# Diary App

Flutter 로 구현한 오프라인 일기장 애플리케이션입니다. 네트워크 연결 유무와 관계없이 일기를 작성하고, 첨부 미디어를 로컬에 저장하며, 데이터/도메인/UI 레이어를 명확히 분리해 테스트 커버리지를 유지하는 것이 목표입니다.

## TODO LIST
[] 바텀네비게이션
[] 일기 수정 기능
[] 다국어 기능
  [] 에러메세지 키값 정의
  [] Bloc, Cubit, View에러메세지 수정
[] 일기 조회화면 추가구현 - 현재와 같은 피드형식뿐 아니라 달력UI도 구현
[] 앱테마 추가구현 - prioty를 보라색으로 했는데, amber나 teal로 변경 가능하도록 구현

## 프로젝트 목적
- **완전한 오프라인 경험**: Drift 기반 SQLite와 파일 시스템을 활용해 네트워크가 없는 환경에서도 일기와 미디어를 읽고 쓸 수 있습니다.
- **안전한 개인 공간**: Secure Storage 로 비밀번호 해시를 저장하고, `PasswordLockCubit`/`PasswordSetupCubit` 으로 잠금 플로우를 제공해 사생활을 보호합니다.
- **예측 가능한 유지보수**: data → domain → presentation 계층을 분리하고, 각 레이어별 테스트를 추가해 회귀를 최소화합니다.
- **검색과 페이징 최적화**: 제목/본문/날짜 범위 검색과 커서 기반 페이지네이션으로 원하는 기록을 빠르게 찾을 수 있습니다.

## 주요 기술 스택
- **플랫폼**: Flutter 3 (Dart 3.9), iOS/Android 동시 타깃.
- **데이터베이스**: Drift + `sqlite3_flutter_libs` 로 로컬 SQL 테이블/DAO 관리.
- **스토리지**: 
  - SharedPreferences (환경 설정 저장),
  - Flutter Secure Storage (비밀번호 해시 저장),
  - `LocalFileSystemDataSource` (미디어 파일 저장).
- **상태 관리 & DI**: `flutter_bloc`/`bloc_concurrency` + injectable/get_it 조합, AutoRoute 네비게이션.
- **유틸리티**: `image` 패키지(메타데이터 추출), `dartz` (Either), `equatable`, `copy_with_extension`, PrettyPrinter logger.
- **테스트**: flutter_test, mocktail, Drift in-memory DB, 커스텀 `MockLogger`.

## 프로젝트 구조
```
lib/
  core/        # 에러/로깅/확장 등 공통 모듈
  data/        # 데이터소스 + Repository 구현
  domain/      # 엔티티, 값 객체, UseCase, Repository 인터페이스
  presentation/# UI, Cubit/BLoC, Router
test/          # 레이어별 단위 테스트 + 헬퍼
tool/          # 시드 스크립트 등 부가 도구
```
- **data**: Drift DAO, 파일/보안 스토리지, SharedPreferences 등을 추상화한 datasource 와 repository 가 위치합니다.
- **domain**: UI와 데이터 사이에서 계약을 정의하고, validation 및 Failure 변환을 담당하는 유즈케이스 계층입니다.
- **presentation**: Cubit/BLoC 을 통해 상태를 관리하고, AutoRoute 기반 화면을 구성합니다. `provider/README.md` 에서 상태 객체를 추가 설명합니다.

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

### Test Utilities

- `test/mock_logger.dart` centralizes a `MockLogger` that runs with `Level.nothing` so failure-path specs can swap it in and keep `Logger`/`PrettyPrinter` output out of the console.

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
- `ErrorHandlerMixIn` wraps repository calls with a `guard` helper to convert thrown `ApiException`s into typed `ApiError`s.
- Use cases translate those API errors into user-friendly `Failure`s before returning to the UI.

## License

MIT
