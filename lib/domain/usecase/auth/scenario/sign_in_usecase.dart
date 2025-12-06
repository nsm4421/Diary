part of '../auth_usecases.dart';

class _SignInUseCase {
  final AuthRepository _repository;

  _SignInUseCase(this._repository);

  Future<AppResponse<AuthUserEntity?>> call({
    required String email,
    required String password,
  }) async {
    return await _repository
        .signInWithPassword(email: email, password: password)
        .then((res) => res.toAppResponse());
  }
}
