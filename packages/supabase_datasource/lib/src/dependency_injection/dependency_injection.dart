import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@InjectableInit.microPackage()
Future<void> initSupabaseDataSourceMicroPackage() async {
  await Supabase.initialize(
    url: SupabaseEnv.supabaseApiUrl,
    anonKey: SupabaseEnv.supabasePublishableKey,
  );
}
