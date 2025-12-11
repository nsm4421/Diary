part of '../auth_usecases.dart';

class _SignUpUseCase {
  final AuthRepository _repository;

  _SignUpUseCase(this._repository);

  Future<AppResponse<AuthUserEntity?>> call({
    required String email,
    required String password,
    required String displayName,
  }) async {
    return await _repository
        .signUpWithPassword(
          email: email,
          password: password,
          displayName: displayName,
        )
        .then((res) => res.toAppResponse());
  }
}
