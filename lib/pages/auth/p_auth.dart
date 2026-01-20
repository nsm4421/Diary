import 'package:auto_route/auto_route.dart';
import 'package:diary/providers/authentication/bloc.dart';
import 'package:diary/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listenWhen: (prev, curr) => !prev.isAuth & curr.isAuth,
      listener: (context, state) {
        if (context.router.canPop()) {
          context.router.maybePop();
        } else {
          context.replaceRoute(EntryRoute());
        }
      },
      child: AutoRouter(),
    );
  }
}
