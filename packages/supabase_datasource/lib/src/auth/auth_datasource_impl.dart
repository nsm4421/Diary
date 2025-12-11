part of 'auth_datasource.dart';

class SupabaseAuthDataSourceImpl
    with SupabaseDataSourceExceptionHandlerMixIn
    implements SupabaseAuthDataSource {
  late final GoTrueClient _auth;

  SupabaseAuthDataSourceImpl(SupabaseClient client) {
    _auth = client.auth;
  }

  @override
  Stream<AuthUserModel?> get authStream =>
      _auth.onAuthStateChange.asyncMap((e) => e.session?.user.toAuthUser());

  @override
  AuthUserModel? get currentUser => _auth.currentUser.toAuthUser();

  @override
  Future<AuthUserModel?> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth
          .signInWithPassword(email: email, password: password)
          .then((authResponse) => authResponse.user.toAuthUser());
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }

  @override
  Future<AuthUserModel?> signUpWithPassword({
    required String email,
    required String password,
    required String displayName,
    String? avatarUrl,
    String? bio,
  }) async {
    try {
      final data = {
        'display_name': displayName,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        if (bio != null) 'bio': bio,
      };
      return await _auth
          .signUp(email: email, password: password, data: data)
          .then((authResponse) => authResponse.user.toAuthUser());
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }

  @override
  Future<void> signOut([SignOutScope scope = SignOutScope.local]) async {
    try {
      await _auth.signOut(scope: scope);
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }

  @override
  Future<AuthUserModel?> setUserAttribute({required String displayName}) async {
    try {
      return await _auth
          .updateUser(UserAttributes(data: {'display_name': displayName}))
          .then((res) => res.user.toAuthUser());
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }
}
