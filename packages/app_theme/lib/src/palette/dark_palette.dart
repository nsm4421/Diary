import 'dart:ui';

import 'palette.dart';

class DarkPalette extends Palette {
  @override
  Brightness get brightness => Brightness.dark;

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
