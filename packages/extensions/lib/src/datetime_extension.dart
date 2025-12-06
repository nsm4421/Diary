extension DateTimeExtension on DateTime {
  String get yyyymmdd {
    final mm = month.toString().padLeft(2, '0');
    final dd = day.toString().padLeft(2, '0');
    return '$year-$mm-$dd';
  }

  DateTime get normalizedMonth => DateTime(year, month);

  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get endOfDay => startOfDay
      .add(const Duration(days: 1))
      .subtract(const Duration(microseconds: 1));

  bool isSameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  bool isSameMonth(DateTime other) => year == other.year && month == other.month;

  bool get isToday => isSameDate(DateTime.now());
}
