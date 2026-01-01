part of 'app_auth_bloc.dart';

@freezed
sealed class AppAuthState with _$AppAuthState {
  factory AppAuthState.idle() = _IdleState;

  factory AppAuthState.authenticated(
    AuthUserModel authUser, {
    AuthFailure? failure,
  }) = _AuthenticatedState;

  factory AppAuthState.unAuthenticated({AuthFailure? failure}) =
      _UnAuthenticatedState;
}

extension AppAuthStateExtension on AppAuthState {
  bool get isAuth => map(
    idle: (_) => false,
    authenticated: (_) => true,
    unAuthenticated: (_) => false,
  );
}
