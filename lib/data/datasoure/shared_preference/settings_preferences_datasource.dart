import 'package:shared_preferences/shared_preferences.dart';

part 'settings_preferences_datasource_impl.dart';

abstract interface class SharedPreferencesDataSource {
  Future<bool> getDarkModeEnabled();

  Future<void> setDarkModeEnabled(bool isEnabled);
}
