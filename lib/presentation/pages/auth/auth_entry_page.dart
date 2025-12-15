import 'package:auto_route/auto_route.dart';
import 'package:diary/presentation/provider/auth/app_auth/auth_bloc.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AuthEntryPage extends StatelessWidget {
  const AuthEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isAuth) {
          context.router.replace(HomeEntryRoute());
        }
      },
      child: const AutoRouter(),
    );
  }
}
