import 'package:injectable/injectable.dart';
import 'package:supabase_codegen/supabase_codegen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../env/env.dart';

@InjectableInit.microPackage()
Future<void> initSupabaseRepositoryMicroPackage() async {
  await Supabase.initialize(
    url: SupabaseEnv.supabaseApiUrl,
    anonKey: SupabaseEnv.supabasePublishableKey,
    authOptions: const FlutterAuthClientOptions(autoRefreshToken: true),
  ).then((supabase) => setClient(supabase.client));
}
