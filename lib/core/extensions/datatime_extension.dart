extension DateTimeExtension on DateTime {
  String get _seperator => '.';

  String get yyyymmdd {
    final local = toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year$_seperator$month$_seperator$day';
  }

  String get yyyymmddHHMM {
    final local = toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$yyyymmdd $hour:$minute';
  }
}
