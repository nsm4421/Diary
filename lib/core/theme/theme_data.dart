part of 'app_theme.dart';

ColorScheme _buildColorScheme(Brightness brightness) {
  final palette = switch (brightness) {
    Brightness.light => _LightPalette(),
    Brightness.dark => _DarkPalette(),
  };
  return ColorScheme.fromSeed(
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

TextTheme _buildTextTheme(ColorScheme colorScheme) {
  final base = GoogleFonts.interTextTheme();
  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(color: colorScheme.onSurface),
    displayMedium: base.displayMedium?.copyWith(color: colorScheme.onSurface),
    displaySmall: base.displaySmall?.copyWith(color: colorScheme.onSurface),
    headlineLarge: base.headlineLarge?.copyWith(color: colorScheme.onSurface),
    headlineMedium: base.headlineMedium?.copyWith(color: colorScheme.onSurface),
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
    labelSmall: base.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
  );
}

ThemeData _buildThemeData(Brightness brightness) {
  final ColorScheme colorScheme = _buildColorScheme(brightness);
  final TextTheme textTheme = _buildTextTheme(colorScheme);

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
