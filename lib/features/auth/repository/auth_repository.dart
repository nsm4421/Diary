import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_repository_impl.dart';

abstract interface class AuthRepository {
  Stream<User?> getSupabaseUserStream();

  Future<User?> getCurrentUser();

  Future<User> signUpWithEmail({
    required String email,
    String? username,
    required String password,
  });

  Future<User> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
