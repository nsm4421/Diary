abstract interface class SettingsRepository {
  /// 다크 모드 사용 여부를 불러옵니다.
  Future<bool> isDarkModeEnabled();

  /// 다크 모드 사용 여부를 저장합니다.
  Future<void> setDarkModeEnabled(bool isEnabled);
}
