import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:injectable/injectable.dart';

part 'palette.dart';

part 'theme_data.dart';

abstract class _AppTheme {
  ThemeData get themeData;
}

@lazySingleton
class LightAppTheme extends _AppTheme {
  @override
  @lazySingleton
  ThemeData get themeData => _buildThemeData(Brightness.light);
}

@lazySingleton
class DarkAppTheme extends _AppTheme {
  @override
  @lazySingleton
  ThemeData get themeData => _buildThemeData(Brightness.dark);
}
