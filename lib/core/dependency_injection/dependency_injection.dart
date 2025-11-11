import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'dependency_injection.config.dart';

@InjectableInit()
Future<void> configureDependencies() async {
  await GetIt.instance.init();
}
