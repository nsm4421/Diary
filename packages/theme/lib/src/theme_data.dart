import 'package:flutter/material.dart';
import 'text_theme.dart';
import 'color_scheme.dart';

ThemeData buildThemeData(Brightness brightness) {
  final ColorScheme colorScheme = switch (brightness) {
    Brightness.light => lightColorScheme,
    Brightness.dark => darkColorScheme,
  };
  final TextTheme textTheme = switch (brightness) {
    Brightness.light => lightTextTheme,
    Brightness.dark => darkTextTheme,
  };

  final Color bottomNavSelectedColor = switch (brightness) {
    Brightness.light => colorScheme.primary,
    Brightness.dark => colorScheme.onSurface,
  };
  final Color bottomNavUnselectedColor = switch (brightness) {
    Brightness.light => colorScheme.onSurfaceVariant,
    Brightness.dark => colorScheme.onSurface.withAlpha(179),
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
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: bottomNavSelectedColor,
      unselectedItemColor: bottomNavUnselectedColor,
      selectedIconTheme: IconThemeData(color: bottomNavSelectedColor),
      unselectedIconTheme: IconThemeData(color: bottomNavUnselectedColor),
      selectedLabelStyle: textTheme.labelMedium?.copyWith(
        color: bottomNavSelectedColor,
      ),
      unselectedLabelStyle: textTheme.labelMedium?.copyWith(
        color: bottomNavUnselectedColor,
      ),
      showUnselectedLabels: true,
    ),
  );
}
