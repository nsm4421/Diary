import 'package:dartz/dartz.dart';
import 'package:diary/core/value_objects/error/api_error.dart';

abstract interface class SettingsRepository {
  /// 다크 모드 사용 여부를 불러옵니다.
  Future<Either<ApiError, bool>> isDarkModeEnabled();

  /// 다크 모드 사용 여부를 저장합니다.
  Future<Either<ApiError, Unit>> setDarkModeEnabled(bool isEnabled);
}
