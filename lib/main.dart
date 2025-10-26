import 'package:flutter/material.dart';

import 'core/dependency_injection/dependency_injection.dart';
import 'main_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MainApp());
}
