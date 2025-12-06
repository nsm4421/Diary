import 'package:flutter/material.dart';

final lightPalette = _LightPalette();
final darkPalette = _DarkPalette();

abstract class _Palette {
  Color get primary;

  Color get onPrimary;

  Color get secondary;

  Color get onSecondary;

  Color get tertiary;

  Color get onTertiary;

  Color get surface;

  Color get error;
}

class _LightPalette extends _Palette {
  _LightPalette();

  @override
  Color get primary => const Color(0xFF1DB954);

  @override
  Color get onPrimary => const Color(0xFF0C1A10);

  @override
  Color get secondary => const Color(0xFF0F3B29);

  @override
  Color get onSecondary => const Color(0xFFE6EFE9);

  @override
  Color get tertiary => const Color(0xFF23C26B);

  @override
  Color get onTertiary => const Color(0xFF041008);

  @override
  Color get surface => const Color(0xFFE6EFE9);

  @override
  Color get error => const Color(0xFFE65F5F);
}

class _DarkPalette extends _Palette {
  @override
  Color get primary => const Color(0xFF1DB954);

  @override
  Color get onPrimary => const Color(0xFF041008);

  @override
  Color get secondary => const Color(0xFF0A2A1A);

  @override
  Color get onSecondary => const Color(0xFFC3E6CF);

  @override
  Color get tertiary => const Color(0xFF1AA759);

  @override
  Color get onTertiary => const Color(0xFF020805);

  @override
  Color get surface => const Color(0xFF0A0D11);

  @override
  Color get error => const Color(0xFFE65F5F);
}
