import 'package:dartz/dartz.dart';
import 'package:diary/core/constant/api_error_code.dart';
import 'package:diary/core/value_objects/error/api_error.dart';
import 'package:diary/core/utils/api_error_handler.dart';
import 'package:diary/data/datasoure/shared_preference/settings_preferences_datasource.dart';
import 'package:diary/domain/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl
    with ApiErrorHandlerMiIn
    implements SettingsRepository {
  SettingsRepositoryImpl(this._preferencesDataSource);

  final SharedPreferencesDataSource _preferencesDataSource;

  @override
  Future<Either<ApiError, bool>> isDarkModeEnabled() {
    return guard(
      () => _preferencesDataSource.getDarkModeEnabled(),
      fallbackCode: ApiErrorCode.cache,
    );
  }

  @override
  Future<Either<ApiError, Unit>> setDarkModeEnabled(bool isEnabled) {
    return guard(
      () => _preferencesDataSource
          .setDarkModeEnabled(isEnabled)
          .then((_) => unit),
      fallbackCode: ApiErrorCode.cache,
    );
  }
}
