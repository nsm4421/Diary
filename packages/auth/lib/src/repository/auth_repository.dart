import 'package:auth/auth.dart';

abstract interface class AuthRepository {
  Stream<AuthUserModel?> get authStream;

  AuthUserModel? get currentUser;

  Future<AuthUserModel?> signUpWithEmail({
    required String email,
    String? username,
    required String password,
  });

  Future<AuthUserModel?> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
