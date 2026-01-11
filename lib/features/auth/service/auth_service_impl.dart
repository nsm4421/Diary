part of 'auth_service.dart';

@LazySingleton(as: AuthService)
class AuthServiceImpl implements AuthService {
  final AuthRepository _authRepository;
  final Logger _logger;

  AuthServiceImpl(this._authRepository, this._logger);

  @override
  Stream<AuthUserModel?> get authUserStream {
    return _authRepository.getSupabaseUserStream().asyncMap(
      (supabaseUser) => supabaseUser == null
          ? null
          : AuthUserModel.fromSupabaseUser(supabaseUser),
    );
  }

  @override
  TaskEither<AuthFailure, AuthUserModel?> getCurrentUser() {
    return TaskEither.tryCatch(
      () async {
        final supabaseUser = await _authRepository.getCurrentUser();
        if (supabaseUser == null) return null;
        return AuthUserModel.fromSupabaseUser(supabaseUser);
      },
      (error, stackTrace) {
        return AuthFailure(
          message: 'getting user failed',
          error: error,
          stackTrace: stackTrace,
          logger: _logger,
        );
      },
    );
  }

  @override
  TaskEither<AuthFailure, AuthUserModel> signInWithEmail({
    required String email,
    required String password,
  }) {
    return TaskEither.tryCatch(
      () async {
        final supabaseUser = await _authRepository.signInWithEmail(
          email: email.trim(),
          password: password.trim(),
        );
        _logger.t('sign in success, id:${supabaseUser.id}');
        return AuthUserModel.fromSupabaseUser(supabaseUser);
      },
      (error, stackTrace) {
        return AuthFailure(
          message: 'sign in failed',
          error: error,
          stackTrace: stackTrace,
          logger: _logger,
        );
      },
    );
  }

  @override
  TaskEither<AuthFailure, AuthUserModel> signUpWithEmail({
    required String email,
    String? clientUsername,
    required String password,
  }) {
    return TaskEither.tryCatch(
      () async {
        final username = (clientUsername == null || clientUsername.isEmpty)
            ? null
            : clientUsername.trim();
        final supabaseUser = await _authRepository.signUpWithEmail(
          email: email.trim(),
          username: username,
          password: password.trim(),
        );
        _logger.t('sign up success, id:${supabaseUser.id}');
        return AuthUserModel.fromSupabaseUser(supabaseUser);
      },
      (error, stackTrace) {
        return AuthFailure(
          message: 'sign up failed',
          error: error,
          stackTrace: stackTrace,
          logger: _logger,
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
          logger: _logger,
        );
      },
    );
  }
}
