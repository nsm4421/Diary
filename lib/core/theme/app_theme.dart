import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:injectable/injectable.dart';

part 'app_palette.dart';
part 'app_color_scheme.dart';
part 'app_typography.dart';

abstract class _AppThemeData {
  late final ColorScheme _colorScheme;
  late final TextTheme _textTheme;

  _AppThemeData({
    required _ColorScheme colorScheme,
    required _Typography typography,
  }) {
    this._colorScheme = colorScheme.instance;
    this._textTheme = typography.textTheme;
  }

  ThemeData get themeData => ThemeData(
    useMaterial3: true,
    colorScheme: _colorScheme,
    scaffoldBackgroundColor: _colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: _colorScheme.surface,
      foregroundColor: _colorScheme.onSurface,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: const CardThemeData(
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    textTheme: _textTheme,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _colorScheme.inverseSurface,
      contentTextStyle: _textTheme.bodyMedium?.copyWith(
        color: _colorScheme.onInverseSurface,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

@lazySingleton
class LightAppThemeData extends _AppThemeData {
  LightAppThemeData()
    : super(colorScheme: _LightColorScheme(), typography: _LightTypography());
}

@lazySingleton
class DarkAppThemeData extends _AppThemeData {
  DarkAppThemeData()
    : super(colorScheme: _DarkColorScheme(), typography: _DarkTypography());
}
