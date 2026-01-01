import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../repository/auth_repository.dart';
import '../../service/auth_service.dart';
import '../../provider/app_auth/app_auth_bloc.dart';
import '../../provider/sign_up/sign_up_cubit.dart';
import '../../provider/sign_in/sign_in_cubit.dart';

@module
abstract class AuthModule {
  final _logger = Logger();

  @lazySingleton
  AuthRepository get _authRepository =>
      AuthRepositoryImpl(Supabase.instance.client);

  @lazySingleton
  AuthService get _authService => AuthServiceImpl(_authRepository, _logger);

  @lazySingleton
  AppAuthBloc get appAuthBloc => AppAuthBloc(_authService);

  @injectable
  SignInCubit get signInCubit => SignInCubit(_authService);

  @injectable
  SignUpCubit get signUpCubit => SignUpCubit(_authService);
}
