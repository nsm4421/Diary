part of 'bloc.dart';

@freezed
sealed class AuthenticationEvent with _$AuthenticationEvent {
  factory AuthenticationEvent.start() = _StartEvent;

  factory AuthenticationEvent.onAuthenticated(AuthUserModel authUser) =
      _OnAuthenticatedEvent;

  factory AuthenticationEvent.onUnAuthenticated() = _OnUnAuthenticatedEvent;

  factory AuthenticationEvent.profileUpdated(ProfileModel profile) =
      _ProfileUpdatedEvent;

  factory AuthenticationEvent.signOut() = _SignOutEvent;

  factory AuthenticationEvent.deleteAccount() = _DeleteAccountEvent;

}
