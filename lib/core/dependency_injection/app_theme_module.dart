import 'package:injectable/injectable.dart';

import '../theme/app_theme.dart';

@module
abstract class AppThemeModule {
  @lazySingleton
  LightAppTheme get lightTheme => LightAppTheme();

  @lazySingleton
  DarkAppTheme get darkTheme => DarkAppTheme();
}