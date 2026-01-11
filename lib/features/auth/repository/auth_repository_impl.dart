part of 'auth_repository.dart';

@LazySingleton(as:AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabaseClient;

  AuthRepositoryImpl(this._supabaseClient);

  @override
  Stream<User?> getSupabaseUserStream() {
    return _supabaseClient.auth.onAuthStateChange.asyncMap((data) {
      switch (data.event) {
        case AuthChangeEvent.signedIn:
          return data.session?.user;
        case AuthChangeEvent.initialSession:
        case AuthChangeEvent.passwordRecovery:
        case AuthChangeEvent.userUpdated:
          return _supabaseClient.auth.currentUser;
        case AuthChangeEvent.signedOut:
        case AuthChangeEvent.tokenRefreshed:
        default:
          return null;
      }
    });
  }

  @override
  Future<User?> getCurrentUser() async => _supabaseClient.auth.currentUser;

  @override
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final user = await _supabaseClient.auth
        .signInWithPassword(email: email, password: password)
        .then((res) => res.user);
    if (user == null) {
      throw AuthException('Sign in failed: no user returned.');
    }
    return user;
  }

  @override
  Future<User> signUpWithEmail({
    required String email,
    String? username,
    required String password,
  }) async {
    final user = await _supabaseClient.auth
        .signUp(
          email: email,
          password: password,
          data: username == null ? null : {'username': username},
        )
        .then((res) => res.user);
    if (user == null) {
      throw AuthException('Sign up failed: no user returned.');
    }
    return user;
  }

  @override
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut(scope: SignOutScope.global);
  }
}
