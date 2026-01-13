part of 'bloc.dart';

@freezed
sealed class AuthenticationEvent with _$AuthenticationEvent {
  factory AuthenticationEvent.start() = _startEvent;

  factory AuthenticationEvent.onAuthenticated(AuthUserModel authUser) =
      _onAuthenticatedEvent;

  factory AuthenticationEvent.onUnAuthenticated() = _onUnAuthenticatedEvent;

  factory AuthenticationEvent.signOut() = _signOutEvent;
}
