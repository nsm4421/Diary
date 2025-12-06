import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/dependency_injection/dependency_injection.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const _MainApp());
}

class _MainApp extends StatelessWidget {
  const _MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Karma-Diary',
      theme: GetIt.instance<LightAppThemeData>().themeData,
      darkTheme: GetIt.instance<DarkAppThemeData>().themeData,
      routerConfig: GetIt.instance<AppRouter>().config(),
    );
  }
}
