enum DisplayStatus { initial, loading, refreshing, paginated }

enum DiaryDetailStatus { idle, loading, fetched, failure }

enum CreateDiaryStatus { initial, editing, submitting, failure, success }

enum DeleteDiaryStatus { idle, success, loading, failure }

enum PasswordLockStatus { idle, loading, unLocked, locked, failure }

enum PasswordSetupStatus { idle, editing, loading, success, failure }

enum SettingStatus { initial, loading, ready, updating, failure }
