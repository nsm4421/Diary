import 'dart:ui';

import 'dark_palette.dart';
import 'light_palette.dart';
import 'palette.dart';

class AppPalette {
  late final Palette _instance;

  AppPalette(Brightness brightness) {
    _instance = switch (brightness) {
      Brightness.light => LightPalette(),
      Brightness.dark => DarkPalette(),
    };
  }

  Palette get instance => _instance;
}
