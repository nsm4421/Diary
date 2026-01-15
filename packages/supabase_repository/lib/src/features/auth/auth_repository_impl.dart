import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auth/auth.dart';
import 'package:shared/shared.dart';
import 'package:injectable/injectable.dart';
import 'mapper.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl with DevLoggerMixIn implements AuthRepository {
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
    try {
      return await _client.auth
          .signInWithPassword(email: email, password: password)
          .then((res) => res.user?.toModel());
    } catch (error, stackTrace) {
      logE('sign in fails', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<AuthUserModel?> signUpWithEmail({
    required String email,
    required String username,
    required String password,
    String? avatarUrl,
  }) async {
    try {
      final data = {
        'username': username,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      };
      return await _client.auth
          .signUp(email: email, password: password, data: data)
          .then((res) => res.user?.toModel());
    } catch (error, stackTrace) {
      logE('sign up fails', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut(scope: SignOutScope.global);
    } catch (error, stackTrace) {
      logE('sign out fails', error, stackTrace);
      rethrow;
    }
  }
}
