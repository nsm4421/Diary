import 'package:diary/core/constant/diary_display_mode.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class DisplayDiaryModeCubit extends Cubit<DisplayDiaryMode> {
  DisplayDiaryModeCubit() : super(DisplayDiaryMode.calendar);

  Future<void> handleToggle([
    Duration duration = const Duration(milliseconds: 200),
  ]) async {
    await Future.delayed(duration);
    final opposite = state == DisplayDiaryMode.calendar
        ? DisplayDiaryMode.feed
        : DisplayDiaryMode.calendar;
    emit(opposite);
  }
}
