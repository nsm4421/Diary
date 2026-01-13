import 'package:flutter/material.dart';
import 'package:supabase_repository/supabase_repository.dart';

import 'core/core.dart';
import 'main_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabaseRepositoryMicroPackage();

  configureDependencies();

  runApp(const MainApp());
}
