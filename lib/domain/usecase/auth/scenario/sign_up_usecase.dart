part of '../auth_usecases.dart';

class _SignUpUseCase {
  final AuthRepository _repository;

  _SignUpUseCase(this._repository);

  Future<AppResponse<AuthUserEntity?>> call({
    required String email,
    required String password,
    required String displayName,
    String? avatarUrl,
    String? bio,
  }) async {
    return await _repository
        .signUpWithPassword(
          email: email,
          password: password,
          displayName: displayName,
          avatarUrl: avatarUrl,
          bio: bio,
        )
        .then((res) => res.toAppResponse());
  }
}
