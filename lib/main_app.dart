import 'package:diary/providers/authentication/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'core/core.dart';
import 'router/app_router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<AuthenticationBloc>()
            ..add(AuthenticationEvent.start()),
      child: MaterialApp.router(
        title: 'Vote App',
        theme: GetIt.instance<AppTheme>().lightThemeData,
        darkTheme: GetIt.instance<AppTheme>().darkThemeData,
        routerConfig: GetIt.instance<AppRouter>().config(),
        scaffoldMessengerKey: appScaffoldMessengerKey,
      ),
    );
  }
}
