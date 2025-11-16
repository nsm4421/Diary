# RepositoryImpl API 에러 정리

`lib/data/repository` 아래 구현체에서 API 에러가 어떻게 생성되는지 정리했다.  
공통적으로 세 구현체 모두 `ApiErrorHandlerMiIn` 믹스인을 사용하며, 아래 규칙으로 에러 코드가 결정된다.

## 공통 규칙 (`ApiErrorHandlerMiIn`)

- `guard(run, fallbackCode)`  
  - `run` 안에서 `ApiException`이 던져지면 해당 exception의 `ApiErrorCode`가 그대로 반환된다.  
  - 그 외 예외는 `fallbackCode`(기본값 `UNKNOWN`)로 감싼 `ApiException`으로 변환된다.
- `runDatabase`  
  - 내부에서 예외가 발생하면 `ApiException.database`(`DATABASE_ERROR`)로 변환해 다시 던진다.
- `runStorage`  
  - 내부에서 예외가 발생하면 `ApiException.storage`(`STORAGE_ERROR`)로 변환해 다시 던진다.

아래 표에서는 각 메서드별로 어떤 작업이 실패할 때 어떤 `ApiErrorCode`가 만들어지는지 정리했다.

## DiaryRepositoryImpl (`lib/data/repository/diary_repository_impl.dart`)

| 메서드 | 주요 처리 | 발생 가능한 `ApiErrorCode` | 비고 |
| --- | --- | --- | --- |
| `create` | DB에 일기와 미디어 메타데이터 생성 (`runDatabase`) | `DATABASE_ERROR`, `UNKNOWN` | DB 에러는 `DATABASE_ERROR`, DTO 변환 등 기타 예외는 `UNKNOWN` |
| `findById` | DB에서 단건 조회 (`runDatabase`) | `DATABASE_ERROR`, `UNKNOWN` | 결과가 없으면 `null` 성공으로 반환 |
| `getDiaryDetail` | DB에서 레코드·미디어 조회 (`runDatabase`) 후 엔터티 변환 | `DATABASE_ERROR`, `UNKNOWN` | 레코드 없음은 `null` 성공, 변환 중 예외는 `UNKNOWN` |
| `fetchDiaries` | 커서 기준 목록 조회 (`runDatabase`) | `DATABASE_ERROR`, `UNKNOWN` | |
| `searchByTitle` / `searchByContent` / `searchByDateRange` | 각각 제목/내용/기간 조건으로 조회 (`runDatabase`) | `DATABASE_ERROR`, `UNKNOWN` | 세 메서드 동일 |
| `watchAll` | DB `watchAll()` 스트림 변환 | `DATABASE_ERROR` 또는 스트림이 던진 기존 `ApiErrorCode` | 스트림에서 `ApiException`이 오면 그대로, 그 외 예외는 `DATABASE_ERROR`로 래핑 |
| `update` | 기존 파일 일괄 삭제 (`runStorage`) 후 DB 업데이트 (`runDatabase`) | `STORAGE_ERROR`, `DATABASE_ERROR`, `UNKNOWN` | 파일 삭제 실패는 `STORAGE_ERROR`, DB 업데이트 실패는 `DATABASE_ERROR` |
| `delete` | 파일 일괄 삭제 (`runStorage`), DB 삭제 (`runDatabase`) | `STORAGE_ERROR`, `DATABASE_ERROR`, `UNKNOWN` | 작업 순서 동일 |
| `uploadMediaFiles` | 미디어 목록 조회 (`runDatabase`), 파일 저장 (`runStorage`), 메타데이터 작성 | `DATABASE_ERROR`, `STORAGE_ERROR`, `UNKNOWN` | 이미지 디코드 등 기타 예외는 `UNKNOWN` |

## PasswordRepositoryImpl (`lib/data/repository/password_repository_impl.dart`)

세 메서드 모두 `_secureStorage` 접근만 수행하고, `guard`에 `fallbackCode: ApiErrorCode.storage`를 명시해둔다.  
따라서 Secure Storage 접근에서 예외가 발생하거나 알 수 없는 예외가 나도 결과적으로 `STORAGE_ERROR`로 내려간다.

| 메서드 | 작업 | 에러 코드 |
| --- | --- | --- |
| `savePasswordHash` | 비밀번호 해시 저장 | `STORAGE_ERROR` |
| `fetchPasswordHash` | 비밀번호 해시 조회 | `STORAGE_ERROR` |
| `clearPassword` | 저장된 비밀번호 제거 | `STORAGE_ERROR` |

## SettingsRepositoryImpl (`lib/data/repository/settings_repository_impl.dart`)

SharedPreferences 접근을 캡슐화하며, `guard`의 `fallbackCode`를 `ApiErrorCode.cache`로 지정한다.  
결과적으로 모든 실패는 `CACHE_ERROR`로 매핑된다.

| 메서드 | 작업 | 에러 코드 |
| --- | --- | --- |
| `isDarkModeEnabled` | 다크모드 플래그 조회 | `CACHE_ERROR` |
| `setDarkModeEnabled` | 다크모드 플래그 저장 | `CACHE_ERROR` |

## 활용 팁

- 저장소 레이어에서 새로운 메서드를 추가할 때 **DB I/O는 반드시 `runDatabase`**, **파일/보안저장소 I/O는 `runStorage`**로 감싸면 일관된 에러 코드가 유지된다.
- 특별한 도메인 규칙에 따른 검증 실패는 `ApiException.validation` 등 명시적인 `ApiException`을 던져 원하는 코드로 전달할 수 있다.
