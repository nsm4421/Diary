part of 'app_setting_cubit.dart';

enum _SettingStatus { initial, loading, ready, updating, failure }

@CopyWith(copyWithNull: true)
class AppSettingState extends Equatable {
  const AppSettingState({
    this.status = _SettingStatus.initial,
    this.themeMode = ThemeMode.system,
    this.failure,
  });

  final _SettingStatus status;
  final ThemeMode themeMode;
  final Failure? failure;

  bool get isInitial => status == _SettingStatus.initial;
  bool get isLoading => status == _SettingStatus.loading;
  bool get isReady => status == _SettingStatus.ready;
  bool get isUpdating => status == _SettingStatus.updating;
  bool get isFailure => status == _SettingStatus.failure;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  @override
  List<Object?> get props => [status, themeMode, failure];
}
