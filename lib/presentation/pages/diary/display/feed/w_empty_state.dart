part of '../p_display_diary.dart';

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Icon(
          Icons.auto_stories_outlined,
          size: 72,
          color: colorScheme.onPrimary.withAlpha(153),
        ),
        const SizedBox(height: 24),
        Text(
          '아직 작성된 일기가 없어요',
          textAlign: TextAlign.center,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '오늘의 순간을 기록해보세요.',
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onPrimary.withAlpha(179),
          ),
        ),
        const SizedBox(height: 180),
      ],
    );
  }
}