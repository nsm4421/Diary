part of 'app_theme.dart';

abstract class _ColorScheme {
  final _Palette palette;

  _ColorScheme(this.palette);

  ColorScheme get instance;
}

class _LightColorScheme extends _ColorScheme {
  _LightColorScheme() : super(_LightPalette());

  @override
  ColorScheme get instance =>
      ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: super.palette.primary,
      ).copyWith(
        primary: super.palette.primary,
        secondary: super.palette.secondary,
        tertiary: super.palette.tertiary,
        surface: super.palette.surface,
        surfaceTint: super.palette.primary,
        error: super.palette.error,
      );
}

class _DarkColorScheme extends _ColorScheme {
  _DarkColorScheme() : super(_DarkPalette());

  @override
  ColorScheme get instance =>
      ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: super.palette.primary,
      ).copyWith(
        primary: super.palette.primary,
        secondary: super.palette.secondary,
        tertiary: super.palette.tertiary,
        surface: super.palette.surface,
        surfaceTint: super.palette.primary,
        error: super.palette.error,
      );
}
