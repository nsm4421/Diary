part of 'display_calendar_bloc.dart';

class DisplayCalendarState extends Equatable {
  final DisplayCalendarStatus status;
  late final DateTime currentDate;
  late final DateTime normalizedMonth;
  final List<DiaryEntity> diaries;
  final String errorMessage;

  DisplayCalendarState({
    this.status = DisplayCalendarStatus.idle,
    DateTime? currentDate,
    DateTime? targetDate,
    this.diaries = const [],
    this.errorMessage = '',
  }) {
    this.currentDate = currentDate ?? DateTime.now();
    this.normalizedMonth = (targetDate ?? DateTime.now()).normalizedMonth;
  }

  List<DiaryEntity> get currentDiaries =>
      diaries.where((e) => e.date == currentDate.yyyymmdd).toList();

  bool get isLoading => status == DisplayCalendarStatus.loading;

  bool get isFetched => status == DisplayCalendarStatus.fetched;

  DisplayCalendarState copyWith({
    DisplayCalendarStatus? status,
    DateTime? currentDate,
    DateTime? targetDate,
    List<DiaryEntity>? diaries,
    String? errorMessage,
  }) {
    return DisplayCalendarState(
      status: status ?? this.status,
      currentDate: currentDate ?? this.currentDate,
      targetDate: targetDate ?? this.normalizedMonth,
      diaries: diaries ?? this.diaries,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentDate,
    normalizedMonth,
    diaries,
    errorMessage,
  ];
}
