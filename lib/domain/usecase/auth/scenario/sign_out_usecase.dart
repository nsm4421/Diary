part of '../auth_usecases.dart';

class _SignOutUseCase {
  final AuthRepository _repository;

  _SignOutUseCase(this._repository);

  Future<AppResponse<void>> call() async {
    return await _repository.signOut().then((res) => res.toAppResponse());
  }
}
