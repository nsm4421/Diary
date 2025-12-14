import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

part 'home_bottom_nav_state.dart';

@injectable
class HomeBottomNavCubit extends Cubit<HomeBottomNav> {
  final Logger _logger;

  HomeBottomNavCubit(this._logger) : super(HomeBottomNav.display);

  HomeBottomNav? _getByIndex(int index) {
    if (index < 0 || index >= HomeBottomNav.values.length) {
      _logger.w('index is invalid|index:$index');
      return null;
    }
    return HomeBottomNav.values[index];
  }

  void switchByIndex(int index) {
    final next = _getByIndex(index);
    if (next != null && next != state) {
      emit(next);
    }
  }
}
