import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'dependency_injection.config.dart';
import 'package:supabase_repository/supabase_repository.dart'
    as supabase_di;

@InjectableInit(
  includeMicroPackages: true,
  externalPackageModulesBefore: [
    ExternalModule(supabase_di.SupabaseRepositoryPackageModule),
  ],
)
void configureDependencies() {
  GetIt.instance.init();
}
