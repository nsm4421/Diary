import 'package:app_extensions/export.dart';
import 'package:auto_route/auto_route.dart';
import 'package:diary/presentation/provider/auth/auth_bloc.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_screen.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (_, curr) => curr.isProcessed,
      listener: (context, state) async {
        await Future.delayed(Duration(milliseconds: 1500), () {
          context.replaceRoute(
            state.isAuth ? HomeEntryRoute() : AuthEntryRoute(),
          );
        });
      },
      child: _Screen(),
    );
  }
}
