part of 'bloc.dart';

@freezed
sealed class AuthenticationState with _$AuthenticationState {
  factory AuthenticationState.idle() = _IdleState;

  factory AuthenticationState.authenticated(
    AuthUserModel authUser, {
    Failure? failure,
  }) = _AuthenticatedState;

  factory AuthenticationState.unAuthenticated({Failure? failure}) =
      _UnAuthenticatedState;
}

extension AuthenticationStateExtension on AuthenticationState {
  bool get isAuth => map(
    idle: (_) => false,
    authenticated: (_) => true,
    unAuthenticated: (_) => false,
  );

  bool get isIdle => mapOrNull(idle: (_) => true) ?? false;
}
