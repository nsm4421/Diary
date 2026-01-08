import 'package:supabase_flutter/supabase_flutter.dart';

class AuthUserModel {
  final String id;
  final String email;
  final String username;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AuthUserModel({
    required this.id,
    required this.email,
    required this.username,
    this.createdAt,
    this.updatedAt,
  });

  factory AuthUserModel.fromSupabaseUser(User supabaseUser) {
    return AuthUserModel(
      id: supabaseUser.id,
      email: supabaseUser.email ?? 'unknown@google.com',
      username: supabaseUser.userMetadata?['username'] ?? 'unknown',
      createdAt: DateTime.tryParse(supabaseUser.createdAt),
      updatedAt: DateTime.tryParse(supabaseUser.updatedAt ?? ''),
    );
  }
}
