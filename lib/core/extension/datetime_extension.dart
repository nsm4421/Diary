extension DateTimeExtension on DateTime {
  String get yyyymmdd {
    final mm = month.toString().padLeft(2, '0');
    final dd = day.toString().padLeft(2, '0');
    return '$year-$mm-$dd';
  }

  DateTime get normalizedMonth => DateTime(year, month);
}
