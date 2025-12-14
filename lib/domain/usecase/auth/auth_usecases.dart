import 'package:diary/core/response/app_response.dart';
import 'package:diary/domain/entity/auth/auth_user_entity.dart';
import 'package:diary/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

part 'scenario/sign_in_usecase.dart';

part 'scenario/sign_up_usecase.dart';

part 'scenario/sign_out_usecase.dart';

@lazySingleton
class AuthUseCases {
  final AuthRepository _repository;

  AuthUseCases(this._repository);

  Stream<AuthUserEntity?> get authStream => _repository.authStream;

  AuthUserEntity? get currentUser => _repository.currentUser;

  _SignInUseCase get signIn => _SignInUseCase(_repository);

  _SignUpUseCase get signUp => _SignUpUseCase(_repository);

  _SignOutUseCase get signOut => _SignOutUseCase(_repository);
}
