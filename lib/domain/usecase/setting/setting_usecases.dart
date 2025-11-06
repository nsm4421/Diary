import 'package:dartz/dartz.dart';
import 'package:diary/core/error/failure.dart';
import 'package:diary/domain/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

part 'scenario/get_dark_mode_enabled_usecase.dart';
part 'scenario/set_dark_mode_enabled_usecase.dart';

@lazySingleton
class SettingUseCases {
  SettingUseCases(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  _GetDarkModeEnabledUseCase get getDarkModeEnabled =>
      _GetDarkModeEnabledUseCase(_settingsRepository);

  _SetDarkModeEnabledUseCase get setDarkModeEnabled =>
      _SetDarkModeEnabledUseCase(_settingsRepository);
}
