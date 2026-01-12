import 'package:flutter/material.dart';

import '../palette/palette.dart';

class AppColorScheme {
  late final ColorScheme _instance;

  AppColorScheme(Palette palette) {
    _instance =
        ColorScheme.fromSeed(
          brightness: palette.brightness,
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

  ColorScheme get instance => _instance;
}
