part of 'settings_preferences_datasource.dart';

class SharedPreferencesDataSourceImpl
    implements SharedPreferencesDataSource {
  SharedPreferencesDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  static const String _darkModeKey = 'settings.dark_mode_enabled';

  @override
  Future<bool> getDarkModeEnabled() async {
    return _prefs.getBool(_darkModeKey) ?? false;
  }

  @override
  Future<void> setDarkModeEnabled(bool isEnabled) async {
    await _prefs.setBool(_darkModeKey, isEnabled);
  }
}
