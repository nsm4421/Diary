import 'package:flutter/material.dart';

enum DiaryMood {
  happy(
    _MoodMeta(
      label: '행복해요',
      icons: Icons.sentiment_satisfied_alt_rounded,
      hint: '설레고 즐거운 순간이었나요?',
    ),
  ),
  sad(
    _MoodMeta(
      label: '우울해요',
      icons: Icons.sentiment_dissatisfied_rounded,
      hint: '속상했던 기분을 적어보세요.',
    ),
  ),
  soso(
    _MoodMeta(
      label: '잔잔해요',
      icons: Icons.sentiment_neutral_rounded,
      hint: '담담하게 지나간 하루도 소중해요.',
    ),
  ),
  none(
    _MoodMeta(
      label: '선택 안 함',
      icons: Icons.do_not_disturb_on_outlined,
      hint: '이번엔 기분을 남기지 않을게요.',
    ),
  );

  final _MoodMeta meta;

  const DiaryMood(this.meta);

  bool get isNone => this == DiaryMood.none;
}

class _MoodMeta {
  const _MoodMeta({
    required this.label,
    required this.icons,
    required this.hint,
  });

  final String label;
  final IconData icons;
  final String hint;
}
