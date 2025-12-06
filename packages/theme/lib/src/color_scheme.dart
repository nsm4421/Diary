import 'package:flutter/material.dart';
import 'palette.dart';

final lightColorScheme = _buildColorScheme(Brightness.light);
final darkColorScheme = _buildColorScheme(Brightness.dark);

ColorScheme _buildColorScheme(Brightness brightness) {
  final palette = switch (brightness) {
    Brightness.light => lightPalette,
    Brightness.dark => darkPalette,
  };

  return ColorScheme.fromSeed(
    brightness: brightness,
    seedColor: palette.primary,
  ).copyWith(
    primary: palette.primary,
    onPrimary: palette.onPrimary,
    secondary: palette.secondary,
    onSecondary: palette.onSecondary,
    tertiary: palette.tertiary,
    onTertiary: palette.onTertiary,
    surface: palette.surface,
    surfaceTint: palette.primary,
    error: palette.error,
  );
}
