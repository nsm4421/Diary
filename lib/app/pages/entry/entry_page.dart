import 'package:auto_route/auto_route.dart';
import 'package:diary/app/router/app_router.dart';
import 'package:diary/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppAuthBloc, AppAuthState>(
      listenWhen: (prev, curr) => !curr.isAuth,
      listener: (context, state) {
        context.router.replaceAll([AuthRoute()]);
      },
      child: AutoRouter(),
    );
  }
}
