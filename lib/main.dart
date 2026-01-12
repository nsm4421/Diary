import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_repository/supabase_repository.dart';

import 'utils/dependency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabaseRepositoryMicroPackage();

  configureDependencies();

  runApp(const _MainApp());
}

class _MainApp extends StatelessWidget {
  const _MainApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vote App',
      theme: lightAppThemeData,
      darkTheme: darkAppThemeData,
      home: Text("TEST"),
      // routerConfig: GetIt.instance<AppRouter>().config(),
      // scaffoldMessengerKey: appScaffoldMessengerKey,
    );
  }
}
