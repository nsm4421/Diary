import 'dart:ui';

import 'palette.dart';

class LightPalette extends Palette {
  @override
  Brightness get brightness => Brightness.light;

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
