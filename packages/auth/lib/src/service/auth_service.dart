import 'package:auth/auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../core/value_object/auth_failure.dart';

part 'auth_service_impl.dart';

abstract interface class AuthService {
  TaskEither<AuthFailure, Stream<AuthUserModel?>> getAuthUserStream();

  TaskEither<AuthFailure, AuthUserModel> getCurrentUser();

  TaskEither<AuthFailure, AuthUserModel?> signInWithEmail({
    required String email,
    required String password,
  });

  TaskEither<AuthFailure, AuthUserModel?> signUpWithEmail({
    required String email,
    required String password,
    required String username,
    String? avatarUrl,
  });

  TaskEither<AuthFailure, void> signOut();

  TaskEither<AuthFailure, void> deleteUser();
}
