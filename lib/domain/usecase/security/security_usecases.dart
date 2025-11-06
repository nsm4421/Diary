import 'package:dartz/dartz.dart';
import 'package:diary/core/error/failure.dart';
import 'package:diary/domain/repository/password_repository.dart';
import 'package:injectable/injectable.dart';

part 'scenario/save_password_hash_usecase.dart';
part 'scenario/fetch_password_hash_usecase.dart';
part 'scenario/clear_password_usecase.dart';

@lazySingleton
class SecurityUseCases {
  SecurityUseCases(this._passwordRepository);

  final PasswordRepository _passwordRepository;

  _SavePasswordHashUseCase get savePasswordHash =>
      _SavePasswordHashUseCase(_passwordRepository);

  _FetchPasswordHashUseCase get fetchPasswordHash =>
      _FetchPasswordHashUseCase(_passwordRepository);

  _ClearPasswordUseCase get clearPassword =>
      _ClearPasswordUseCase(_passwordRepository);
}
