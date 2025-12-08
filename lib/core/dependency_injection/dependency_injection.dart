import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_datasource/export.dart';

import 'dependency_injection.config.dart';

@InjectableInit(
  includeMicroPackages: true,
  externalPackageModulesBefore: [
    ExternalModule(SupabaseDatasourcePackageModule),
  ],
)
Future<void> configureDependencies() async {
  await initSupabaseDataSourceMicroPackage();
  await GetIt.instance.init();
}
