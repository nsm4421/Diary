import 'package:auth/auth.dart';

abstract interface class AuthRepository {
  Stream<AuthUserModel?> get authStream;

  AuthUserModel? get currentUser;

  Future<AuthUserModel?> signUpWithEmail({
    required String email,
    required String username,
    required String password,
    String? avatarUrl
  });

  Future<AuthUserModel?> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> callDeleteUserApi();
}
