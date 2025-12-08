import 'package:app_theme/export.dart';
import 'package:diary/presentation/provider/auth/auth_bloc.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'core/dependency_injection/dependency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();
  runApp(const _MainApp());
}

class _MainApp extends StatelessWidget {
  const _MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<AuthBloc>()..add(AuthEvent.init()),
      child: MaterialApp.router(
        title: 'Karma-Diary',
        theme: lightThemeData,
        darkTheme: darkThemeData,
        routerConfig: GetIt.instance<AppRouter>().config(),
      ),
    );
  }
}
