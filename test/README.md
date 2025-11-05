# 테스트 구조

## Data Layer

### `test/data/datasoure/local/diary/local_diary_datasource_impl_test.dart`
- `create`
  - `does not create media rows when media list empty` 첨부 목록이 비어 있을 때 미디어 테이블에 레코드가 생성되지 않는지 확인합니다.
  - `persists a new diary row` 일기 본문이 올바르게 저장되는지 검증합니다.
  - `persists related media rows when provided` 첨부 메타데이터가 정렬 순서·사이즈와 함께 저장되는지 확인합니다.
- `fetchRowsByCursor`
  - `returns rows ordered by createdAt desc for first page` 커서 기반 첫 페이지가 최신 순으로 반환되는지 검증합니다.
  - `returns rows older than provided cursor` 지정한 커서보다 오래된 항목만 조회되는지 확인합니다.
- `findById`
  - `returns matching record when row exists` 존재하는 일기 식별자로 단일 행을 조회할 수 있는지 확인합니다.
  - `returns null when row does not exist` 없는 식별자일 때 `null`이 반환되는지 검증합니다.
- `searchByTitle`
  - `filters rows by keyword and orders by createdAt` 제목 키워드 검색이 정상 동작하고 최신순 정렬이 유지되는지 확인합니다.
- `update`
  - `updates row content and timestamp` 본문과 갱신 시간이 업데이트되는지 검증합니다.
  - `throws when row missing` 없는 레코드 업데이트 시 예외가 발생하는지 확인합니다.
- `delete`
  - `removes matching row` 삭제 요청 시 일기 행이 제거되는지 검증합니다.
  - `removes related media rows` 일기 삭제가 첨부 레코드까지 함께 삭제하는지 확인합니다.
  - `throws when row not found` 존재하지 않는 식별자 삭제 시 예외가 발생하는지 검증합니다.

### `test/data/datasoure/local/storage/local_storage_datasource_impl_test.dart`
- `save writes file to disk` 파일이 지정 경로에 저장되는지 확인합니다.
- `save throws when file exists and overwrite is false` 덮어쓰기 옵션 없이 중복 저장 시 예외가 발생하는지 검증합니다.
- `save overwrites file when overwrite true` 덮어쓰기 허용 시 기존 파일이 대체되는지 확인합니다.
- `save resizes image with maintainAspectRatio` 리사이즈 옵션이 적용되어 종횡비를 유지하는지 검증합니다.
- `read returns null for missing file` 파일이 없을 때 `null`을 반환하는지 확인합니다.
- `read returns stored bytes` 저장된 바이트를 정확히 읽어오는지 검증합니다.
- `exists reflects file presence` 존재 여부 확인 API가 파일 유무를 정확히 반영하는지 확인합니다.
- `delete removes file` 삭제 호출이 파일을 제거하는지 검증합니다.
- `deleteAll removes nested directory only` 지정 디렉터리만 재귀적으로 삭제하고 다른 경로는 유지되는지 확인합니다.

### `test/data/repository/diary_repository_impl_test.dart`
- `create`
  - `returns entity and persists row` 새 일기 생성이 성공하고 DB에 반영되는지 검증합니다.
  - `returns Failure when datasource throws AppException` 데이터소스 예외를 `Failure`로 노출하는지 확인합니다.
- `read operations`
  - `findById returns Right entry when found` 단일 조회가 성공적으로 `Right(entry)`를 반환하는지 검증합니다.
  - `getDiaryDetail returns detail with medias` 상세 조회가 첨부 메타데이터·절대 경로·이미지 크기를 포함하는지 확인합니다.
  - `getDiaryDetail returns Right(null) when record missing` 레코드가 없을 때 `Right(null)`을 반환하는지 검증합니다.
  - `fetchEntries returns entries ordered by createdAt desc` 페이지 조회가 최신순으로 반환되는지 확인합니다.
  - `fetchEntries excludes rows newer than cursor` 커서보다 최신 항목이 제외되는지 검증합니다.
  - `searchByTitle filters using keyword` 제목 검색이 키워드 필터링 및 정렬을 유지하는지 확인합니다.
- `write operations`
  - `update returns Right and mutates record` 업데이트가 성공하고 내용이 변경되는지 검증합니다.
  - `delete removes row` 삭제가 성공하고 레코드가 제거되는지 확인합니다.
- `media uploads`
  - `uploadMediaFiles returns metadata and saves image dimensions` 업로드가 이미지 크기·바이트 수를 계산하고 파일을 저장하는지 검증합니다.
  - `create persists medias returned from uploadMediaFiles` 업로드 결과가 일기 생성 시 함께 저장되는지 확인합니다.
- `watchAll`
  - `emits Right data when datasource stream succeeds` 스트림이 성공 데이터를 방출하는지 검증합니다.
  - `emits Left when datasource stream throws` 스트림 오류가 `Failure`로 전달되는지 확인합니다.

## Domain Layer

### `test/domain/usecase/diary/diary_usecases_test.dart`
- `create`
  - `returns validation failure when content is empty` 본문이 비어 있으면 검증 실패가 발생하는지 확인합니다.
  - `returns validation failure when content exceeds limit` 본문 길이 초과 시 제한 메시지를 반환하는지 검증합니다.
  - `returns validation failure when title exceeds limit` 제목 길이 초과 상황을 검증합니다.
  - `normalizes inputs before delegating to repository` 입력값 공백 정리가 저장소에 반영되는지 확인합니다.
  - `maps failure message based on error code` 에러 코드에 맞춰 사용자 친화적인 메시지가 매핑되는지 검증합니다.
  - `uploads media files before creating diary entry` 생성 전 첨부 업로드가 실행되고 결과가 전달되는지 확인합니다.
  - `propagates failure when uploadMediaFiles fails` 업로드 실패 시 이후 흐름이 중단되고 실패가 전달되는지 검증합니다.
- `update`
  - `returns validation failure when id is blank` 식별자 공백 시 검증 실패가 발생하는지 확인합니다.
  - `returns validation failure when content exceeds limit` 본문 길이 초과 시 업데이트를 막는지 검증합니다.
  - `maps repository failures to friendly messages` 저장소 실패가 안내 메시지로 변환되는지 확인합니다.
- `get`
  - `returns validation failure when id is blank` 상세 조회 식별자 검증을 확인합니다.
  - `maps repository failure message` 저장소 실패가 사용자 메시지로 매핑되는지 검증합니다.
- `fetch`
  - `returns validation failure when limit is invalid` 조회 개수 검증이 동작하는지 확인합니다.
  - `maps repository failure message for default fetch` 기본 목록 조회 실패 매핑을 검증합니다.
  - `returns pageable result with next cursor when data exists` 페이징 결과가 다음 커서를 포함하는지 확인합니다.
  - `maps repository failure message for title search` 제목 검색 실패 메시지 매핑을 검증합니다.
- `delete`
  - `returns validation failure when id is blank` 삭제 시 식별자 검증을 확인합니다.
  - `maps repository failure message` 저장소 실패가 안내 메시지로 변환되는지 검증합니다.
- `watch`
  - `maps failure emitted by repository` 스트림에서 방출된 실패가 메시지 매핑을 거치는지 확인합니다.

## Presentation Layer

### `test/presentation/provider/diary/create/create_diary_cubit_test.dart`
- `addMediaFiles enforces maximum of three images` 첨부 이미지가 최대 3장까지만 유지되는지 검증합니다.
- `removeMediaAt removes the target image` 지정 인덱스 첨부가 제거되는지 확인합니다.
- `handleSubmit uploads media files and emits success` 제출 시 업로드·저장 흐름이 정상 완료되고 성공 상태가 되는지 검증합니다.
- `handleSubmit surfaces failure when uploadMediaFiles fails` 업로드 실패가 에러 상태로 반영되고 저장이 중단되는지 확인합니다.

## 실행 방법

```bash
flutter test test/data/datasoure/local/diary/local_diary_datasource_impl_test.dart
flutter test test/data/datasoure/local/storage/local_storage_datasource_impl_test.dart
flutter test test/data/repository/diary_repository_impl_test.dart
flutter test test/domain/usecase/diary/diary_usecases_test.dart
flutter test test/presentation/provider/diary/create/create_diary_cubit_test.dart
```
