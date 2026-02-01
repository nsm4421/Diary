import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'router/app_router.dart';
import 'core/core.dart';
import 'providers/providers.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.instance<ThemeModeCubit>()),
      ],
      child: BlocBuilder<ThemeModeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Vote App',
            theme: GetIt.instance<ThemeModeCubit>().lightThemeData,
            darkTheme: GetIt.instance<ThemeModeCubit>().darkThemeData,
            themeMode: themeMode,
            routerConfig: GetIt.instance<AppRouter>().config(),
            scaffoldMessengerKey: appScaffoldMessengerKey,
          );
        },
      ),
    );
  }
}
