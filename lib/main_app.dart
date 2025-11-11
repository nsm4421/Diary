import 'package:diary/presentation/provider/security/password_lock/password_lock_cubit.dart';
import 'package:diary/presentation/provider/setting/app_setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'presentation/router/app_router.dart';
import 'core/theme/app_theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppSettingCubit>(
          create: (_) => GetIt.instance<AppSettingCubit>()..init(),
        ),
        BlocProvider<PasswordLockCubit>(
          create: (_) => GetIt.instance<PasswordLockCubit>()..init(),
        ),
      ],
      child: BlocBuilder<AppSettingCubit, AppSettingState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Diary',
            theme: GetIt.instance<LightAppThemeData>().themeData,
            darkTheme: GetIt.instance<DarkAppThemeData>().themeData,
            themeMode: state.themeMode,
            routerConfig: GetIt.instance<AppRouter>().config(),
          );
        },
      ),
    );
  }
}
