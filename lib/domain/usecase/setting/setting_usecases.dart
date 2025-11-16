import 'package:dartz/dartz.dart';
import 'package:diary/core/error/failure/failure.dart';
import 'package:diary/core/error/failure/falure_handler.dart';
import 'package:diary/core/extension/logger_extension.dart';
import 'package:diary/core/utils/app_logger.dart';
import 'package:diary/domain/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

part 'scenario/get_dark_mode_enabled_usecase.dart';

part 'scenario/set_dark_mode_enabled_usecase.dart';

@lazySingleton
class SettingUseCases with AppLoggerMixIn {
  SettingUseCases(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  _GetDarkModeEnabledUseCase get getDarkModeEnabled =>
      _GetDarkModeEnabledUseCase(_settingsRepository, logger: logger);

  _SetDarkModeEnabledUseCase get setDarkModeEnabled =>
      _SetDarkModeEnabledUseCase(_settingsRepository, logger: logger);
}
