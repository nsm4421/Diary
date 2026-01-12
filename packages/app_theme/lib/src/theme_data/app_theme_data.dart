import 'package:app_theme/src/color_scheme/app_color_scheme.dart';
import 'package:app_theme/src/palette/app_palette.dart';
import 'package:app_theme/src/text_theme/app_text_theme.dart';
import 'package:flutter/material.dart';

class AppThemeData {
  late final ThemeData _instance;

  AppThemeData(Brightness brightness) {
    final appPalette = AppPalette(brightness);

    final appColorScheme = AppColorScheme(appPalette.instance);
    final colorScheme = appColorScheme.instance;

    final appTextTheme = AppTextTheme(colorScheme);
    final textTheme = appTextTheme.instance;

    final Color bottomNavSelectedColor = switch (colorScheme.brightness) {
      Brightness.light => colorScheme.primary,
      Brightness.dark => colorScheme.onSurface,
    };
    final Color bottomNavUnselectedColor = switch (colorScheme.brightness) {
      Brightness.light => colorScheme.onSurfaceVariant,
      Brightness.dark => colorScheme.onSurface.withAlpha(179),
    };

    _instance = ThemeData(
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

  ThemeData get instance => _instance;
}
