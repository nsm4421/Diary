import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'dependency_injection.config.dart';
import 'package:supabase_repository/supabase_repository.dart';
import 'package:auth/auth.dart';

@InjectableInit(
  includeMicroPackages: true,
  externalPackageModulesBefore: [
    ExternalModule(SupabaseRepositoryPackageModule),
    ExternalModule(AuthPackageModule),
  ],
)
void configureDependencies() {
  GetIt.instance.init();
}
