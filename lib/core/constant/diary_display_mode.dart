import 'package:flutter/material.dart';

enum DisplayDiaryMode {
  feed(Icons.list_rounded),
  calendar(Icons.calendar_month_rounded);

  final IconData iconData;

  const DisplayDiaryMode(this.iconData);
}
