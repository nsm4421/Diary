import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

part 'palette.dart';

part 'theme_data.dart';

abstract class _AppTheme {
  ThemeData get themeData;
}

class LightAppTheme extends _AppTheme {
  @override
  ThemeData get themeData => _buildThemeData(Brightness.light);
}

class DarkAppTheme extends _AppTheme {
  @override
  ThemeData get themeData => _buildThemeData(Brightness.dark);
}
