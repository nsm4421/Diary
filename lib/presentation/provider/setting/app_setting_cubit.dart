import 'package:dartz/dartz.dart';
import 'package:diary/core/constant/error_code.dart';
import 'package:diary/core/value_objects/error/failure.dart';
import 'package:diary/core/constant/status.dart';
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
    emit(state.copyWith(status: SettingStatus.loading, errorMessage: null));

    final Either<Failure, bool> result = await _settingUseCases
        .getDarkModeEnabled();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SettingStatus.failure,
          themeMode: ThemeMode.system,
          errorMessage: _failureMessage(failure),
        ),
      ),
      (isEnabled) => emit(
        state
            .copyWith(
              status: SettingStatus.ready,
              themeMode: isEnabled ? ThemeMode.dark : ThemeMode.light,
            )
            .copyWithNull(errorMessage: true),
      ),
    );
  }

  Future<void> updateDarkMode(bool isEnabled) async {
    emit(
      state
          .copyWith(status: SettingStatus.updating)
          .copyWithNull(errorMessage: true),
    );

    await _settingUseCases
        .setDarkModeEnabled(isEnabled: isEnabled)
        .then(
          (res) => res.fold(
            (failure) => emit(
              state.copyWith(
                status: SettingStatus.failure,
                errorMessage: _failureMessage(failure),
              ),
            ),
            (_) => emit(
              state
                  .copyWith(
                    status: SettingStatus.ready,
                    themeMode: isEnabled ? ThemeMode.dark : ThemeMode.light,
                  )
                  .copyWithNull(errorMessage: true),
            ),
          ),
        );
  }

  void clearFailure() {
    if (state.errorMessage == null) return;

    final nextStatus = state.status == SettingStatus.failure
        ? SettingStatus.ready
        : state.status;
    emit(state.copyWith(status: nextStatus, errorMessage: null));
  }

  String _failureMessage(Failure failure) {
    return switch (failure.code) {
      ErrorCode.validation => failure.description,
      ErrorCode.network || ErrorCode.timeout =>
        '네트워크 연결을 확인하고 다시 시도해주세요.',
      ErrorCode.storage ||
      ErrorCode.cache ||
      ErrorCode.database =>
        '설정 정보를 처리하지 못했습니다. 잠시 후 다시 시도해주세요.',
      _ => failure.description,
    };
  }
}
