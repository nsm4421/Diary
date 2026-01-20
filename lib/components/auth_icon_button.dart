import 'package:auto_route/auto_route.dart';
import 'package:diary/providers/authentication/bloc.dart';
import 'package:diary/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_required_dialog.dart';

class LoginAndOutButton extends StatelessWidget {
  const LoginAndOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (_, state) {
        return state.isAuth
            ? IconButton(
                onPressed: () {
                  context.read<AuthenticationBloc>().add(
                    AuthenticationEvent.signOut(),
                  );
                },
                icon: Icon(Icons.logout),
                tooltip: '로그아웃',
              )
            : IconButton(
                onPressed: () {
                  context.router.push(AuthRoute());
                },
                icon: Icon(Icons.login),
                tooltip: '로그인',
              );
      },
    );
  }
}
