extension NumDurationExtension on num {
  Duration get ms => Duration(milliseconds: round());

  Duration get seconds => Duration(milliseconds: (this * 1000).round());

  Duration get minutes => Duration(milliseconds: (this * 60000).round());

  Duration get hours => Duration(milliseconds: (this * 3600000).round());

  Duration get days => Duration(milliseconds: (this * 86400000).round());
}

extension IntReadableSizeExtension on int {
  String toReadableFileSize({int precision = 1}) {
    final safePrecision = precision < 0 ? 0 : precision;
    if (this <= 0) return '0 B';

    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    double size = toDouble();
    var unitIndex = 0;

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    final fixed = size.toStringAsFixed(safePrecision);
    final trimmed =
        safePrecision > 0 ? fixed.replaceFirst(RegExp(r'\.?0+$'), '') : fixed;

    return '$trimmed ${units[unitIndex]}';
  }
}
