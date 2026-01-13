import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Brightness get brightness => colorScheme.brightness;

  TextTheme get textTheme => Theme.of(this).textTheme;
}
