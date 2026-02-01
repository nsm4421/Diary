import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class ThemeModeCubit extends Cubit<ThemeMode> {
  final SharedPreferences _sp;
  static const String _kThemeModeKey = 'THEME_MODE';

  ThemeModeCubit(this._sp) : super(ThemeMode.system) {
    emit(_getThemeMode());
  }

  @lazySingleton
  ThemeData get lightThemeData => AppThemeData(Brightness.light).instance;

  @lazySingleton
  ThemeData get darkThemeData => AppThemeData(Brightness.dark).instance;

  ThemeMode _getThemeMode() {
    final value = _sp.getString(_kThemeModeKey);
    if (value == 'light') {
      return ThemeMode.light;
    } else if (value == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  void setThemeMode(ThemeMode nextThemeMode) {
    final value = switch (nextThemeMode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'light',
    };
    _sp.setString(_kThemeModeKey, value);
    emit(nextThemeMode);
  }
}
