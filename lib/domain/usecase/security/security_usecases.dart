import 'package:dartz/dartz.dart';
import 'package:diary/core/value_objects/error/failure.dart';
import 'package:diary/core/utils/falure_handler.dart';
import 'package:diary/core/extension/logger_extension.dart';
import 'package:diary/core/utils/app_logger.dart';
import 'package:diary/domain/repository/password_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

part 'scenario/save_password_hash_usecase.dart';

part 'scenario/fetch_password_hash_usecase.dart';

part 'scenario/clear_password_usecase.dart';

@lazySingleton
class SecurityUseCases with AppLoggerMixIn {
  SecurityUseCases(this._passwordRepository);

  final PasswordRepository _passwordRepository;

  _SavePasswordHashUseCase get savePasswordHash =>
      _SavePasswordHashUseCase(_passwordRepository, logger: logger);

  _FetchPasswordHashUseCase get fetchPasswordHash =>
      _FetchPasswordHashUseCase(_passwordRepository, logger: logger);

  _ClearPasswordUseCase get clearPassword =>
      _ClearPasswordUseCase(_passwordRepository, logger: logger);
}
