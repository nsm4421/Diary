import 'package:dartz/dartz.dart';
import 'package:diary/core/error/failure.dart';
import 'package:diary/domain/usecase/setting/setting_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'app_setting_state.dart';

part 'app_setting_cubit.g.dart';

@lazySingleton
class AppSettingCubit extends Cubit<AppSettingState> {
  AppSettingCubit(this._settingUseCases) : super(const AppSettingState());

  final SettingUseCases _settingUseCases;

  Future<void> init() async {
    await _loadDarkMode();
  }

  Future<void> _loadDarkMode() async {
    emit(state.copyWith(status: _SettingStatus.loading, failure: null));

    final Either<Failure, bool> result = await _settingUseCases
        .getDarkModeEnabled();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: _SettingStatus.failure,
          themeMode: ThemeMode.system,
          failure: failure,
        ),
      ),
      (isEnabled) => emit(
        state
            .copyWith(
              status: _SettingStatus.ready,
              themeMode: isEnabled ? ThemeMode.dark : ThemeMode.light,
            )
            .copyWithNull(failure: true),
      ),
    );
  }

  Future<void> updateDarkMode(bool isEnabled) async {
    emit(
      state
          .copyWith(status: _SettingStatus.updating)
          .copyWithNull(failure: true),
    );

    await _settingUseCases
        .setDarkModeEnabled(isEnabled: isEnabled)
        .then(
          (res) => res.fold(
            (failure) => emit(
              state.copyWith(status: _SettingStatus.failure, failure: failure),
            ),
            (_) => emit(
              state
                  .copyWith(
                    status: _SettingStatus.ready,
                    themeMode: isEnabled ? ThemeMode.dark : ThemeMode.light,
                  )
                  .copyWithNull(failure: true),
            ),
          ),
        );
  }

  void clearFailure() {
    if (state.failure == null) return;

    final nextStatus = state.status == _SettingStatus.failure
        ? _SettingStatus.ready
        : state.status;
    emit(state.copyWith(status: nextStatus, failure: null));
  }
}
