import 'package:diary/providers/auth/app_auth/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'core/core.dart';
import 'providers/setting/theme_mode/cubit.dart';
import 'router/app_router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              GetIt.instance<AuthenticationBloc>()
                ..add(AuthenticationEvent.start()),
        ),
        BlocProvider(create: (_) => GetIt.instance<ThemeModeCubit>()),
      ],
      child: BlocBuilder<ThemeModeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Vote App',
            theme: GetIt.instance<AppTheme>().lightThemeData,
            darkTheme: GetIt.instance<AppTheme>().darkThemeData,
            themeMode: themeMode,
            routerConfig: GetIt.instance<AppRouter>().config(),
            scaffoldMessengerKey: appScaffoldMessengerKey,
          );
        },
      ),
    );
  }
}
