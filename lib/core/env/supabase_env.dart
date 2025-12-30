import 'package:envied/envied.dart';

part 'supabase_env.g.dart';

@Envied(path: '.env.local')
abstract class SupabaseEnv {
  @EnviedField(varName: 'SUPABASE_API_URL')
  static const String supabaseApiUrl = _SupabaseEnv.supabaseApiUrl;

  @EnviedField(varName: 'SUPABASE_PUBLISHABLE_KEY')
  static const String supabasePublishableKey =
      _SupabaseEnv.supabasePublishableKey;
}
