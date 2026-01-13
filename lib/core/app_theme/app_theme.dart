import 'dart:ui';

import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppTheme {
  @lazySingleton
  ThemeData get lightThemeData => AppThemeData(Brightness.light).instance;

  @lazySingleton
  ThemeData get darkThemeData => AppThemeData(Brightness.dark).instance;
}
