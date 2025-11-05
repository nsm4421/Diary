# Local Storage DataSource

`LocalStorageDataSource`는 앱 내부 디렉터리에 파일(이미지 포함)을 저장/조회/삭제하는 컴포넌트입니다. 모든 파일은 지정된 기준 디렉터리(`baseDirectory` + `rootFolder`) 하위에 저장되며, 경로는 호출자가 전달한 상대 경로 기준으로 해석됩니다.

## 구성 요소
- `LocalStorageDataSource` (interface): 파일 저장/조회/삭제/디렉터리 삭제 계약을 정의합니다.
- `LocalStorageDataSourceImpl` (implementation):
  - `FsUtilMixIn`을 사용해 디렉터리 생성 및 파일 핸들링을 수행합니다.
  - `ImageUtilMixIn`을 사용해 이미지 저장 시 필요에 따라 리사이즈 및 포맷 변환을 지원합니다.
  - `Logger`를 통해 I/O 실패를 기록하고, 예외는 호출자에게 다시 전달합니다.

## 주요 기능
- **save**: 파일을 청크 단위로 기록하며 진행률 콜백(`onProgress`)을 제공합니다. `ResizeOption`으로 JPEG/PNG/WebP 리사이즈 및 품질을 제어할 수 있습니다.
- **read**: 파일이 존재하면 `Uint8List`로 반환하고, 없으면 `null`을 반환합니다.
- **exists**: 파일 존재 여부를 빠르게 확인합니다.
- **delete / deleteAll**: 특정 파일 또는 하위 디렉터리를 재귀적으로 삭제합니다.

## 테스트
`test/data/datasoure/local/storage/local_storage_datasource_impl_test.dart`에서 다음 케이스를 검증합니다.
- 파일 저장 및 진행률 콜백 동작
- 덮어쓰기 옵션/리사이즈 처리
- 읽기/존재 확인/삭제/디렉터리 삭제 시나리오

실행 방법:

```bash
flutter test test/data/datasoure/local/storage/local_storage_datasource_impl_test.dart
```
