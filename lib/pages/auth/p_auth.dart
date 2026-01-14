import 'package:auto_route/auto_route.dart';
import 'package:diary/providers/authentication/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return state.isIdle
            ? Center(child: CircularProgressIndicator())
            : AutoRouter();
      },
    );
  }
}
