part of 'auth_bloc.dart';

enum AuthStatus { idle, loading, processed }

@CopyWith(copyWithNull: true)
class AuthState {
  final AuthStatus status;
  final AuthUserEntity? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.idle,
    this.user,
    this.errorMessage,
  });

  bool get isAuth => user != null;

  bool get isLoading => status == AuthStatus.loading;

  bool get isProcessed => status == AuthStatus.processed;

  bool get isError => errorMessage != null;

  factory AuthState.authenticated(AuthUserEntity user) {
    return AuthState(status: AuthStatus.processed, user: user);
  }

  factory AuthState.unauthenticated() {
    return AuthState(status: AuthStatus.processed);
  }

  factory AuthState.error(String errorMessage) {
    return AuthState(status: AuthStatus.processed, errorMessage: errorMessage);
  }
}
