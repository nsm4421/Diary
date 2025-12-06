import 'package:supabase_flutter/supabase_flutter.dart';

class AuthUserModel {
  final String id;
  final String? email;
  final String? displayName;
  final String? avatarUrl;
  final String? bio;

  const AuthUserModel._({
    required this.id,
    this.email,
    this.displayName,
    this.avatarUrl,
    this.bio,
  });

  factory AuthUserModel.fromSupabaseUser(User user) {
    return AuthUserModel._(
      id: user.id,
      email: user.email,
      displayName: user.userMetadata?['display_name'],
      avatarUrl: user.userMetadata?['avatar_url'],
      bio: user.userMetadata?['bio'],
    );
  }
}
