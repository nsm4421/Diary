part of 'p_calendar.dart';

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid();

  static const _weekdayLabels = ['일', '월', '화', '수', '목', '금', '토'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayCalendarBloc, DisplayCalendarState>(
      builder: (context, state) {
        final colorScheme = context.colorScheme;
        final textTheme = context.textTheme;
        final month = state.normalizedMonth;
        final today = DateUtils.dateOnly(DateTime.now());
        final selectedDate = state.currentDate;
        final diaryDayKeys = state.diaries
            .map(_diaryDate)
            .map(DateUtils.dateOnly)
            .map((date) => date.yyyymmdd)
            .toSet();

        return TableCalendar<DiaryEntity>(
          firstDay: DateTime.utc(2000, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          focusedDay: month,
          currentDay: today,
          calendarFormat: CalendarFormat.month,
          headerVisible: false,
          availableGestures: AvailableGestures.none,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          rowHeight: 56,
          daysOfWeekHeight: 32,
          onDaySelected: (selectedDay, _) {
            context.read<DisplayCalendarBloc>().add(
              DisplayCalendarEvent.currentChanged(selectedDay),
            );
          },
          selectedDayPredicate: (day) => _isSameDay(day, selectedDate),
          daysOfWeekStyle: DaysOfWeekStyle(
            decoration: const BoxDecoration(),
            weekdayStyle:
                textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ) ??
                const TextStyle(),
            weekendStyle:
                textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ) ??
                const TextStyle(),
          ),
          calendarStyle: const CalendarStyle(
            outsideDaysVisible: true,
            tablePadding: EdgeInsets.zero,
            cellMargin: EdgeInsets.symmetric(vertical: 6),
          ),
          calendarBuilders: CalendarBuilders(
            dowBuilder: (context, day) {
              final label = _weekdayLabels[day.weekday % 7];
              return Center(
                child: Text(
                  label,
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            },
            defaultBuilder: (context, day, _) => _buildDayCell(
              context,
              day,
              hasDiary: diaryDayKeys.contains(day.yyyymmdd),
              isSelected: _isSameDay(day, selectedDate),
              isOutsideMonth: !_isSameMonth(day, month),
              isToday: _isSameDay(day, today),
            ),
            todayBuilder: (context, day, _) => _buildDayCell(
              context,
              day,
              hasDiary: diaryDayKeys.contains(day.yyyymmdd),
              isSelected: _isSameDay(day, selectedDate),
              isOutsideMonth: !_isSameMonth(day, month),
              isToday: true,
            ),
            selectedBuilder: (context, day, _) => _buildDayCell(
              context,
              day,
              hasDiary: diaryDayKeys.contains(day.yyyymmdd),
              isSelected: true,
              isOutsideMonth: !_isSameMonth(day, month),
              isToday: _isSameDay(day, today),
            ),
            outsideBuilder: (context, day, _) => _buildDayCell(
              context,
              day,
              hasDiary: diaryDayKeys.contains(day.yyyymmdd),
              isSelected: _isSameDay(day, selectedDate),
              isOutsideMonth: true,
              isToday: _isSameDay(day, today),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDayCell(
    BuildContext context,
    DateTime day, {
    required bool hasDiary,
    required bool isSelected,
    required bool isOutsideMonth,
    required bool isToday,
  }) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final textColor = isSelected
        ? colorScheme.onPrimary
        : isOutsideMonth
        ? colorScheme.onSurfaceVariant.withOpacity(0.4)
        : colorScheme.onSurface;

    Border? border;
    if (hasDiary) {
      border = Border.all(
        color: isSelected ? colorScheme.onPrimary : colorScheme.primary,
        width: 1.6,
      );
    } else if (isToday && !isSelected) {
      border = Border.all(
        color: colorScheme.primary.withOpacity(0.4),
        width: 1,
      );
    }

    final decoration = BoxDecoration(
      shape: BoxShape.circle,
      color: isSelected ? colorScheme.primary : Colors.transparent,
      border: border,
    );

    return Center(
      child: Container(
        width: 40,
        height: 40,
        decoration: decoration,
        alignment: Alignment.center,
        child: Text(
          '${day.day}',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime? b) =>
      b != null && a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  DateTime _diaryDate(DiaryEntity entity) {
    return DateTime.tryParse(entity.date) ?? entity.createdAt;
  }
}
