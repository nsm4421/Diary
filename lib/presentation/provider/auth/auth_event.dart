part of 'auth_bloc.dart';

@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.init() = _Initial;

  const factory AuthEvent.update(AuthUserEntity? user) = _Update;

  const factory AuthEvent.signIn({
    required String email,
    required String password,
  }) = _SignIn;

  const factory AuthEvent.signUp({
    required String email,
    required String password,
    required String displayName,
    String? avatarUrl,
    String? bio,
  }) = _SignUp;

  const factory AuthEvent.signOut() = _SignOut;
}
