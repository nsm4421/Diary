import 'package:supabase_flutter/supabase_flutter.dart';

class AuthUserModel {
  final String id;
  final String email;
  final String username;

  AuthUserModel({
    required this.id,
    required this.email,
    required this.username,
  });

  factory AuthUserModel.fromSupabaseUser(User supabaseUser) {
    return AuthUserModel(
      id: supabaseUser.id,
      email: supabaseUser.email ?? 'unknown@google.com',
      username: supabaseUser.userMetadata?['username'] ?? 'unknown',
    );
  }
}
