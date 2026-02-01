import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'dependency_injection.config.dart';

@InjectableInit(includeMicroPackages: true, externalPackageModulesBefore: [])
void configureDependencies() {
  GetIt.instance.init();
}
