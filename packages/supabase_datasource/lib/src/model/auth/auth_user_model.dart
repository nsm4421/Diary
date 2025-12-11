import 'package:supabase_flutter/supabase_flutter.dart';

class AuthUserModel {
  final String id;
  final String? email;
  final String? displayName;

  const AuthUserModel._({required this.id, this.email, this.displayName});

  factory AuthUserModel.fromSupabaseUser(User user) {
    return AuthUserModel._(
      id: user.id,
      email: user.email,
      displayName: user.userMetadata?['display_name'],
    );
  }
}
