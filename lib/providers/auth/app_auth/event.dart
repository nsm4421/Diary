part of 'bloc.dart';

@freezed
sealed class AuthenticationEvent with _$AuthenticationEvent {
  factory AuthenticationEvent.start() = _StartEvent;

  factory AuthenticationEvent.onAuthenticated(AuthUserModel authUser) =
      _OnAuthenticatedEvent;

  factory AuthenticationEvent.onUnAuthenticated() = _OnUnAuthenticatedEvent;

  factory AuthenticationEvent.signOut() = _SignOutEvent;
}
