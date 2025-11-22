# Diary App

Flutter 로 구현한 오프라인 일기장 애플리케이션입니다. 네트워크 연결 유무와 관계없이 일기를 작성하고, 첨부 미디어를 로컬에 저장하며, 데이터/도메인/UI 레이어를 명확히 분리해 테스트 커버리지를 유지하는 것이 목표입니다.

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

### Bootstrap
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run
```bash
flutter run
```

## Release

1. 터미널에 다음 명령어 실행하면 루트 경로에 `your_key.jks`파일이 생성됨

`keytool -genkey -v -keystore your_key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias diary_app_key`

2. android/app/key.properties 파일 작성

```
storePassword=
keyPassword=
keyAlias=diary_app_key
storeFile=../app/diary_app_key.jks
```

3. android/app/diary_app_key.jks

`your_key.jks`파일을 android/app 경로로 가져오고 파일명을 `diary_app_key`로 변경

4. andorid/app/build.gradle.kts파일 수정

```
// ------- 추가 --------- //
import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
// --------------------- //

...

android {
    ...

    // 🔐 1) keystore를 release 서명으로 등록
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        // 🔐 2) release 빌드가 위에서 만든 signingConfig를 쓰도록 변경
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true        // 필요없으면 false
            isShrinkResources = true      // 필요없으면 false
        }

        ...
    }
}
```

5. 빌드 파일 생성

```
flutter clean
flutter pub get
flutter build appbundle --release
```