part of 'app_setting_cubit.dart';

@CopyWith(copyWithNull: true)
class AppSettingState extends Equatable {
  const AppSettingState({
    this.status = SettingStatus.initial,
    this.themeMode = ThemeMode.system,
    this.errorMessage,
  });

  final SettingStatus status;
  final ThemeMode themeMode;
  final String? errorMessage;

  bool get isInitial => status == SettingStatus.initial;

  bool get isLoading => status == SettingStatus.loading;

  bool get isReady => status == SettingStatus.ready;

  bool get isUpdating => status == SettingStatus.updating;

  bool get isFailure => status == SettingStatus.failure;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  @override
  List<Object?> get props => [status, themeMode, errorMessage];
}
