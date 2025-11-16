# Value Objects

## Countries

`Country` centralises the locales we expose to users. Each enum entry pairs a country code with the default language of that market so that the rest of the app can map `Country` ➜ `Locale` or show friendly language pickers.

## Error Messages

`ErrorMessages` is the single registry blocs, cubits, and widgets should consult for user-facing error text. Retrieve a message via `ErrorMessages.resolve(key, country: Country.unitedStates)` or grab the `LocalizedMessage` with `ErrorMessages.of(key)` when you need custom interpolation logic.

Some strings contain the placeholder `{max}`—pass `placeholders: {'max': 120}` when resolving to inject the runtime value.

| Key | Scenario | Korean | English | Japanese |
| --- | --- | --- | --- | --- |
| `genericUnknown` | Fallback for unexpected failures | 알 수 없는 오류가 발생했습니다. | An unknown error occurred. | 不明なエラーが発生しました。 |
| `networkRetry` | Connectivity missing or flaky | 네트워크 연결을 확인하고 다시 시도해주세요. | Check your network connection and try again. | ネットワーク接続を確認してからもう一度お試しください。 |
| `timeoutRetry` | Remote call timed out | 요청 시간이 초과되었습니다. 잠시 후 다시 시도해주세요. | The request timed out. Please try again later. | リクエストがタイムアウトしました。しばらくしてからもう一度お試しください。 |
| `storageOperationFailed` | File import/upload/download issues | 파일을 처리하는 중 문제가 발생했습니다. | We couldn’t process the files. | ファイルの処理中に問題が発生しました。 |
| `dataStoreUnavailable` | Cache/database read/write failed | 저장된 데이터를 불러오는 중 문제가 발생했습니다. | We couldn’t load the saved data. | 保存されたデータを読み込めませんでした。 |
| `settingsPersistenceFailed` | Saving or loading settings | 설정 정보를 처리하지 못했습니다. 잠시 후 다시 시도해주세요. | We couldn’t update your settings. Please try again later. | 設定を更新できませんでした。しばらくしてからもう一度お試しください。 |
| `diaryContentRequired` | Creating/updating diary without body | 일기 내용을 입력해주세요. | Please enter your diary content. | 日記の内容を入力してください。 |
| `diaryContentLengthExceeded` | Diary body exceeds allowed length | 일기 내용은 최대 {max}자까지 작성할 수 있습니다. | Diary content can include up to {max} characters. | 日記の内容は最大{max}文字まで入力できます。 |
| `diaryTitleLengthExceeded` | Diary title too long | 제목은 최대 {max}자까지 입력할 수 있습니다. | Titles can include up to {max} characters. | タイトルは最大{max}文字まで入力できます。 |
| `diaryIdInvalid` | Missing/empty diary identifier | 일기 식별자가 올바르지 않습니다. | The diary identifier is invalid. | 日記IDが正しくありません。 |
| `fetchLimitInvalid` | Invalid pagination request | 조회 개수는 1 이상이어야 합니다. | The number of items to fetch must be at least 1. | 取得件数は1件以上にしてください。 |
