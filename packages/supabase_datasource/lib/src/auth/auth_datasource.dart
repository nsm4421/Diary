import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/auth/auth_user_model.dart';
import '../mapper/user_mapper.dart';
import '../utils/datasource_exception_handler.dart';

part 'auth_datasource_impl.dart';

abstract interface class SupabaseAuthDataSource {
  Stream<AuthUserModel?> get authStream;

  AuthUserModel? get currentUser;

  Future<AuthUserModel?> signInWithPassword({
    required String email,
    required String password,
  });

  Future<AuthUserModel?> signUpWithPassword({
    required String email,
    required String password,
    required String displayName,
    String? avatarUrl,
    String? bio,
  });

  Future<void> signOut();

  Future<AuthUserModel?> setUserAttribute({
    required String displayName,
  });
}
