import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'dependency_injection.config.dart';
import 'package:supabase_repository/supabase_repository.dart';
import 'package:auth/auth.dart';
import 'package:vote/vote.dart';

@InjectableInit(
  includeMicroPackages: true,
  externalPackageModulesBefore: [
    ExternalModule(SupabaseRepositoryPackageModule),
    ExternalModule(AuthPackageModule),
    ExternalModule(VotePackageModule),
  ],
)
void configureDependencies() {
  GetIt.instance.init();
}
