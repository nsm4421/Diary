import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/dependency_injection/dependency_injection.dart';
import 'presentation/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/provider/theme/app_theme_cubit.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppThemeCubit>(create: (_) => getIt<AppThemeCubit>()),
      ],
      child: BlocBuilder<AppThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Diary',
            theme: GetIt.instance<LightAppThemeData>().themeData,
            darkTheme: GetIt.instance<DarkAppThemeData>().themeData,
            themeMode: themeMode,
            routerConfig: GetIt.instance<AppRouter>().config(),
          );
        },
      ),
    );
  }
}
