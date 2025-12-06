import 'package:flutter/material.dart';
import 'text_theme.dart';
import 'color_scheme.dart';

final lightThemeData = _buildThemeData(Brightness.light);
final darkThemeData = _buildThemeData(Brightness.dark);

ThemeData _buildThemeData(Brightness brightness) {
  final ColorScheme colorScheme = switch (brightness) {
    Brightness.light => lightColorScheme,
    Brightness.dark => darkColorScheme,
  };
  final TextTheme textTheme = switch (brightness) {
    Brightness.light => lightTextTheme,
    Brightness.dark => darkTextTheme,
  };

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: const CardThemeData(
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    textTheme: textTheme,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onInverseSurface,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
