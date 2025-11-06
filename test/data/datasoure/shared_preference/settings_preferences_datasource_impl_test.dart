import 'package:diary/data/datasoure/shared_preference/settings_preferences_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const key = 'settings.dark_mode_enabled';
  late SharedPreferences prefs;
  late SharedPreferencesDataSource dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    dataSource = SharedPreferencesDataSourceImpl(prefs);
  });

  test('getDarkModeEnabled returns false when value not stored', () async {
    expect(await dataSource.getDarkModeEnabled(), isFalse);
  });

  test('getDarkModeEnabled returns stored value when present', () async {
    await prefs.setBool(key, true);

    expect(await dataSource.getDarkModeEnabled(), isTrue);
  });

  test('setDarkModeEnabled persists value to preferences', () async {
    await dataSource.setDarkModeEnabled(true);
    expect(prefs.getBool(key), isTrue);

    await dataSource.setDarkModeEnabled(false);
    expect(prefs.getBool(key), isFalse);
  });
}
