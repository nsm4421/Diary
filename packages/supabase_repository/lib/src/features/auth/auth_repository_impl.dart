import 'package:auth/auth.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'mapper.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client;

  AuthRepositoryImpl(this._client);

  @override
  Stream<AuthUserModel?> get authStream => _client.auth.onAuthStateChange
      .asyncMap(
        (data) => switch (data.event) {
          AuthChangeEvent.signedIn ||
          AuthChangeEvent.initialSession ||
          AuthChangeEvent.passwordRecovery ||
          AuthChangeEvent.userUpdated => data.session?.user,
          (_) => null,
        },
      )
      .asyncMap((supabaseUser) => supabaseUser?.toModel());

  @override
  AuthUserModel? get currentUser => _client.auth.currentUser?.toModel();

  @override
  Future<AuthUserModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _client.auth
        .signInWithPassword(email: email, password: password)
        .then((res) => res.user?.toModel());
  }

  @override
  Future<AuthUserModel?> signUpWithEmail({
    required String email,
    String? username,
    required String password,
  }) async {
    return await _client.auth
        .signUp(
          email: email,
          password: password,
          data: username == null ? null : {'username': username},
        )
        .then((res) => res.user?.toModel());
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut(scope: SignOutScope.global);
  }
}
