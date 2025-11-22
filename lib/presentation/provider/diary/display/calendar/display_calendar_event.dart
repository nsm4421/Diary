part of 'display_calendar_bloc.dart';

@freezed
abstract class DisplayCalendarEvent with _$DisplayCalendarEvent {
  const factory DisplayCalendarEvent.started() = _Started;

  const factory DisplayCalendarEvent.currentChanged(DateTime currentDate) =
      _CurrentChanged;

  const factory DisplayCalendarEvent.monthChanged(DateTime targetDate) =
      _MonthChanged;

  const factory DisplayCalendarEvent.refreshed(String id) = _Refreshed;


  const factory DisplayCalendarEvent.modified(DiaryEntity diary) = _Modified;

  const factory DisplayCalendarEvent.removed(String id) = _Removed;
}
