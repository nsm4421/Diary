part of 'app_theme.dart';

abstract class _Palette {
  Color get primary;
  Color get secondary;
  Color get tertiary;
  Color get surface;
  Color get error;
}

class _LightPalette extends _Palette {
  @override
  Color get primary => const Color(0xFF6750A4);
  @override
  Color get secondary => const Color(0xFF625B71);
  @override
  Color get tertiary => const Color(0xFF7D5260);
  @override
  Color get surface => const Color(0xFFFFFBFE);
  @override
  Color get error => const Color(0xFFB3261E);
}

class _DarkPalette extends _Palette {
  @override
  Color get primary => const Color(0xFFD0BCFF);
  @override
  Color get secondary => const Color(0xFFCCC2DC);
  @override
  Color get tertiary => const Color(0xFFEFB8C8);
  @override
  Color get surface => const Color(0xFF1C1B1F);
  @override
  Color get error => const Color(0xFFF2B8B5);
}
