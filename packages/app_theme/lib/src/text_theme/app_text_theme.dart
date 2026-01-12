import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  late final TextTheme _instance;

  AppTextTheme(ColorScheme colorScheme) {
    final base = GoogleFonts.interTextTheme();
    _instance = base.copyWith(
      displayLarge: base.displayLarge?.copyWith(color: colorScheme.onSurface),
      displayMedium: base.displayMedium?.copyWith(color: colorScheme.onSurface),
      displaySmall: base.displaySmall?.copyWith(color: colorScheme.onSurface),
      headlineLarge: base.headlineLarge?.copyWith(color: colorScheme.onSurface),
      headlineMedium: base.headlineMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      headlineSmall: base.headlineSmall?.copyWith(color: colorScheme.onSurface),
      titleLarge: base.titleLarge?.copyWith(color: colorScheme.onSurface),
      titleMedium: base.titleMedium?.copyWith(color: colorScheme.onSurface),
      titleSmall: base.titleSmall?.copyWith(color: colorScheme.onSurface),
      bodyLarge: base.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
        height: 1.4,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
        height: 1.4,
      ),
      bodySmall: base.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
      labelLarge: base.labelLarge?.copyWith(color: colorScheme.onSurface),
      labelMedium: base.labelMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      labelSmall: base.labelSmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  TextTheme get instance => _instance;
}
