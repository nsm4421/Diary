# Provider 상태 가이드

`lib/presentation/provider` 는 UI 에서 사용하는 Cubit/BLoC 과 그들이 노출하는
상태 객체를 모아둔 디렉터리입니다. 이 문서는 현재 정의된 상태들을 요약하여
각 상태가 무엇을 추적하는지, 언제 사용해야 하는지 빠르게 파악할 수 있도록
정리했습니다.

## 비밀번호

`provider/security` 폴더에는 잠금 화면과 설정 화면을 각각 담당하는 두 개의
Cubit 이 존재합니다. 설정 흐름은 `PasswordSetupCubit`, 잠금 해제 흐름은
`PasswordLockCubit` 이 책임집니다.

### `PasswordSetupCubit` (`security/password_setup_cubit.dart`)
- **상태(PasswordSetupState)**
  - `status` (`_PasswordSetupStatus`): `idle` (로딩 전), `editing` (안정 상태),
    `loading` (저장/삭제 중), `success`, `failure`.
  - `hasExistingPassword` (`bool`): 보안 저장소에 해시가 있는지 여부.
  - `errorMessage` (`String`): 최근 오류 메시지. 정상 흐름으로 돌아오면 빈 문자열.
- **주요 동작**
  1. `init()` 이 `fetchPasswordHash` 를 호출해 초기 로딩 상태를 거친 뒤
     `hasExistingPassword` 를 업데이트합니다.
  2. `setPassword(String)` 는 비밀번호를 검증·정규화한 뒤 해시로 저장하고,
     성공 시 `success` → `resetStatus()` 로 다시 `editing` 으로 전환합니다.
  3. `clearPassword(String)` 는 현재 비밀번호를 확인한 뒤 저장소에서 제거합니다.
  4. `resetStatus()` 는 에러 메시지를 지우고 `editing` 으로 되돌려 폼에서 다시 시도할 수 있게 합니다.

### `PasswordLockCubit` (`security/password_lock_cubit.dart`)
- **상태(PasswordLockState)**
  - `status` (`PasswordLockStatus`): `initial`, `success`, `failure`.
    성공은 잠금 해제 완료 시에만 사용합니다.
  - `isInitialized`, `isLoading`, `isChecking`, `isClearing`: 초기 fetch 여부와
    동시 진행 중인 작업을 추적하는 플래그입니다.
  - `input`: 사용자가 잠금 해제 화면에서 입력 중인 값.
  - `remainingAttempts`: 남은 시도 횟수(기본 5회).
  - `hasPassword`: 저장된 해시 존재 여부.
  - `failure`: 검증/저장소 오류.
- **주요 동작**
  1. `init()` 은 보안 저장소에서 해시를 불러와 `_cachedHash` 를 채우고,
     비밀번호가 없으면 `hasPassword` 를 `false` 로 두어 화면이 홈으로
     리디렉션되도록 합니다.
  2. `updateInput` 은 폼 컨트롤러와 상태를 동기화합니다.
  3. `submit()` 은 입력값을 해시 후 `_cachedHash` 와 비교해 성공 시
     `status: success` 로, 실패 시 시도 횟수를 차감하고 `status: failure` 로
     전환합니다.
  4. `clearPassword()` 는 잠금 화면에서 직접 비밀번호를 제거해야 할 때 사용하며,
     완료 후 `hasPassword` 를 `false` 로 돌려보냅니다.
  5. `resetStatus` 는 오류 메시지를 초기화하여 다시 입력 받을 때 사용합니다.

## 설정

### `AppSettingState` (`setting/app_setting_state.dart`)
- **소유자**: `AppSettingCubit`
- **필드**
  - `status` (`_SettingStatus`): `initial`, `loading`, `ready`, `updating`,
    `failure`.
  - `themeMode` (`ThemeMode`): 사용자 설정 또는 시스템에서 결정된 테마 모드.
  - `failure` (`Failure?`): 마지막 오류 정보, 정상 흐름으로 전환되면 초기화됨.
- **핵심 동작**
  - `_SettingStatus.loading`: 저장된 설정을 읽는 동안 사용.
  - `_SettingStatus.ready`: 초기 로딩 완료 또는 업데이트 성공 이후의 안정 상태.
  - `_SettingStatus.updating`: 설정을 저장하는 동안 낙관적으로 전환.
  - `_SettingStatus.failure`: 저장/로드 실패 시 진입하며, 재시도나
    `clearFailure` 호출 시 해제.
  - `isInitial`, `isLoading`, `isDarkMode` 와 같은 getter 로 UI 분기를 단순화.

## 일기

### `CreateDiaryState` (`diary/create/create_diary_state.dart`)
- **소유자**: `CreateDiaryCubit`
- **필드**
  - `status` (`_Status`): `initial`, `editing`, `submitting`, `failure`,
    `success`.
  - `title` (`String`), `content` (`String`): 작성 중인 내용.
  - `medias` (`List<File>`): 최대 3개의 첨부 파일을 담는 불변 리스트.
  - `failure` (`Failure?`): 생성 실패 시 채워지는 오류 정보.
- **핵심 동작**
  - `_Status.editing`: 사용자가 입력을 시작하면 기본으로 진입하며
    `handleChange` 로 실시간 수정.
  - `_Status.submitting`: 중복 제출을 막기 위해 저장 요청 동안 유지.
  - `_Status.success`: 저장 성공 후 잠시 유지하여 완료 애니메이션 등에 활용.
  - `_Status.failure`: 도메인/데이터 오류를 담아 UI 가 메시지와 재시도 플로우를
    제공할 수 있도록 함.

### `SearchDiaryCubit` (`diary/search/search_diary_cubit.dart`)
- **상태**: `Cubit` 의 상태 타입은 `FetchDiaryParam` 으로, 현재 검색 kind 와 값을 동시에 나타냅니다.
- **캐시 전략**: 제목/본문/기간 각각 마지막 입력 값을 별도로 보관하고 있으며
  `switchKind` 호출 시 해당 캐시를 그대로 상태로 내보내 입력 필드와 UI 가 즉시
  복원됩니다.
- **변경 메서드**
  - `updateTitle`, `updateContent` 는 전달된 값을 `trim()` 하여 공백만 있는
    경우를 방지합니다.
  - `updateDateRange` 는 `start`/`end` 모두 필수이며, 최근 범위를 내부 캐시에
    저장해 다시 기간 검색으로 돌아올 때 유지합니다.
- **사용 팁**: UI 에서는 `state is FetchDiaryByTitleParamValue` 와 같이 kind 를
  pattern matching 하여 입력 필드를 분기하면 됩니다.

### `DisplayDiaryBloc` (`provider/diary/display/display_diary.bloc.dart`)
- `DisplayBloc` 를 확장하여 일기 목록을 페이징합니다. `FetchDiaryParam` 이
  factory 파라미터로 주입되어 검색 결과 화면에서도 동일 로직을 재사용합니다.
- `status` 흐름
  - `loading`: 초기 로딩 중, 기존 아이템이 없을 때 로딩 스피너를 노출합니다.
  - `refreshing`: 풀투리프레시 도중이므로 목록은 유지하되 상단 인디케이터를 표시합니다.
  - `paginated`: 추가 페이지를 가져오는 동안이며 기존 아이템 뒤에 로딩 행을
    표시할 때 사용합니다.
  - `initial`: 유휴 상태. `nextPageRequested` 를 보낼 수 있는 유일한 상태입니다.
- `isEnd` 는 `nextCursor == null` 인지로 판별되며, 검색 결과나 기본 목록에서
  추가 로드 여부를 통일된 방식으로 판단합니다.

## 공용 디스플레이(페이징)

### `DisplayState<E, C>` (`display/display_state.dart`)
- **소유자**: `DisplayBloc<E, C, P>` 및 `DisplayDiaryBloc` 과 같은 파생 구현.
- **필드**
  - `status` (`DisplayStatus`, `core/value_objects/status.dart`):
    `initial`, `loading`, `refreshing`, `paginated`.
  - `items` (`List<E>`): 현재 화면에 누적된 엔티티 목록.
  - `nextCursor` (`C?`): 다음 페이지를 요청할 커서, `null` 이면 더 없음.
  - `failure` (`Failure?`): 마지막 페치 오류.
- **핵심 동작**
  - `loading` 과 `refreshing` 으로 최초 로딩과 당겨서 새로고침을 구분.
  - `paginated` 는 추가 페이지 로딩 중임을 의미하며 기존 목록은 유지.
  - `isEmpty` 는 아이템과 오류가 모두 없을 때만 `true`, 플레이스홀더 표현에 적합.
  - `isEnd` 는 `nextCursor == null` 일 때 `true` 가 되어 추가 요청을 방지.

#### `DisplayBloc<E, C, P>` 의 제네릭 설명
- **`E` (Entity)**: UI 에서 렌더링할 실제 데이터 모델 타입입니다. 예) `DiaryEntity`.
- **`C` (Cursor 타입)**: 페이지네이션에 사용되는 커서 값의 자료형입니다. 날짜, 문자열, ID 등 비즈니스에 맞게 선택합니다.
- **`P` (Parameter 타입)**: `fetch` 호출 시 추가 필터/옵션을 전달하고 싶을 때 사용하는 파라미터 객체 타입입니다. 필요 없다면 `void` 대신 `Null` 을 넘기거나 optional 로 처리할 수 있습니다.

이러한 상태 모델을 재사용하면 화면 간 상태/오류 표현이 일관되며, 새로운
기능을 추가할 때도 공통 패턴을 쉽게 따를 수 있습니다.
