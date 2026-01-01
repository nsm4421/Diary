import 'package:diary/app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_codegen/supabase_codegen.dart';
import 'core/core.dart';
import 'features/auth/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseEnv.supabaseApiUrl,
    anonKey: SupabaseEnv.supabasePublishableKey,
  ).then((res) => res.client).then(setClient);

  configureDependencies();

  runApp(const _MainApp());
}

class _MainApp extends StatelessWidget {
  const _MainApp();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<AppAuthBloc>(),
      child: MaterialApp.router(
        title: 'Dating App',
        theme: GetIt.instance<LightAppTheme>().themeData,
        darkTheme: GetIt.instance<DarkAppTheme>().themeData,
        routerConfig: GetIt.instance<AppRouter>().config(),
      ),
    );
  }
}
