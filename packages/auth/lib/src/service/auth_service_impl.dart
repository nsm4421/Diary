part of 'auth_service.dart';

@LazySingleton(as: AuthService)
class AuthServiceImpl implements AuthService {
  final AuthRepository _authRepository;

  AuthServiceImpl(this._authRepository);

  @override
  TaskEither<AuthFailure, Stream<AuthUserModel?>> getAuthUserStream() {
    return TaskEither.tryCatch(
      () async {
        return _authRepository.authStream;
      },
      (error, stackTrace) {
        return AuthFailure(
          message: 'getting user failed',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  @override
  TaskEither<AuthFailure, AuthUserModel> getCurrentUser() {
    return TaskEither.tryCatch(
      () async {
        final currentUser = _authRepository.currentUser;
        if (currentUser == null) {
          throw AuthFailure(message: 'user not found');
        }
        return currentUser;
      },
      (error, stackTrace) {
        return AuthFailure(
          message: 'getting user failed',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  @override
  TaskEither<AuthFailure, AuthUserModel?> signInWithEmail({
    required String email,
    required String password,
  }) {
    return TaskEither.tryCatch(
      () async {
        return await _authRepository.signInWithEmail(
          email: email.trim(),
          password: password.trim(),
        );
      },
      (error, stackTrace) {
        return AuthFailure(
          message: 'sign in failed',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  @override
  TaskEither<AuthFailure, AuthUserModel?> signUpWithEmail({
    required String email,
    required String username,
    required String password,
    String? avatarUrl,
  }) {
    return TaskEither.tryCatch(
      () async {
        return await _authRepository.signUpWithEmail(
          email: email.trim(),
          username: username.trim(),
          password: password.trim(),
          avatarUrl: avatarUrl,
        );
      },
      (error, stackTrace) {
        return AuthFailure(
          message: 'sign up failed',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  @override
  TaskEither<AuthFailure, void> signOut() {
    return TaskEither.tryCatch(
      () async {
        await _authRepository.signOut();
      },
      (error, stackTrace) {
        return AuthFailure(
          message: 'sign out failed',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  @override
  TaskEither<AuthFailure, void> deleteUser() {
    return TaskEither.tryCatch(
      () async {
        await _authRepository.callDeleteUserApi();
      },
      (error, stackTrace) {
        return AuthFailure(
          message: 'delete user failed',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }
}
