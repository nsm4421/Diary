import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseEnv.supabaseApiUrl,
    anonKey: SupabaseEnv.supabasePublishableKey,
  );

  configureDependencies();

  runApp(const _MainApp());
}

class _MainApp extends StatelessWidget {
  const _MainApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dating App',
      theme: GetIt.instance<LightAppTheme>().themeData,
      darkTheme: GetIt.instance<DarkAppTheme>().themeData,
      home: Scaffold(appBar: AppBar(title: Text("APP"))),
    );
  }
}
