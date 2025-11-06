import 'package:diary/data/datasoure/shared_preference/settings_preferences_datasource.dart';
import 'package:diary/domain/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._preferencesDataSource);

  final SharedPreferencesDataSource _preferencesDataSource;

  @override
  Future<bool> isDarkModeEnabled() {
    return _preferencesDataSource.getDarkModeEnabled();
  }

  @override
  Future<void> setDarkModeEnabled(bool isEnabled) {
    return _preferencesDataSource.setDarkModeEnabled(isEnabled);
  }
}
