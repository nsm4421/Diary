import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../model/auth_user_model.dart';
import '../repository/auth_repository.dart';
import 'auth_failure.dart';

part 'auth_service_impl.dart';

abstract interface class AuthService {
  Stream<AuthUserModel?> get authUserStream;

  TaskEither<AuthFailure, AuthUserModel?> getCurrentUser();

  TaskEither<AuthFailure, AuthUserModel> signInWithEmail({
    required String email,
    required String password,
  });

  TaskEither<AuthFailure, AuthUserModel> signUpWithEmail({
    required String email,
    required String password,
    String? clientUsername,
  });

  TaskEither<AuthFailure, void>  signOut();
}
