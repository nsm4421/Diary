import 'dart:ui';

abstract class Palette {
  Brightness get brightness;

  Color get primary;

  Color get onPrimary;

  Color get secondary;

  Color get onSecondary;

  Color get tertiary;

  Color get onTertiary;

  Color get surface;

  Color get error;
}
