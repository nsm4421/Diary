import 'package:auth/auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

extension UserMapper on User {
  AuthUserModel toModel() => AuthUserModel(
    id: id,
    email: this.email ?? 'unknown@google.com',
    username: this.userMetadata?['username'] ?? 'unknown',
    createdAt: DateTime.tryParse(this.createdAt),
    updatedAt: DateTime.tryParse(this.updatedAt ?? ''),
  );
}