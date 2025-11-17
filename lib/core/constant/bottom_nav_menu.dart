import 'package:flutter/material.dart';

enum HomeBottomNavMenu {
  displayDiaries(
    label: '일기',
    iconData: Icons.menu_book_outlined,
    activeIconData: Icons.menu_book,
  ),
  createDiary(
    label: '일기작성',
    iconData: Icons.add_circle_outline,
    activeIconData: Icons.add_circle,
  ),
  setting(
    label: '설정',
    iconData: Icons.settings_outlined,
    activeIconData: Icons.settings,
  );

  final String label;
  final IconData iconData;
  final IconData activeIconData;

  const HomeBottomNavMenu({
    required this.label,
    required this.iconData,
    required this.activeIconData,
  });
}
