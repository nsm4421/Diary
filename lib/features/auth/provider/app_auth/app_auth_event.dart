part of 'app_auth_bloc.dart';

@freezed
sealed class AppAuthEvent with _$AppAuthEvent {
  factory AppAuthEvent.signOut() = _signOutEvent;

  factory AppAuthEvent.onAuthenticated(AuthUserModel authUser) =
      _authenticatedEvent;

  factory AppAuthEvent.onUnAuthenticated() = _unAuthenticatedEvent;
}
