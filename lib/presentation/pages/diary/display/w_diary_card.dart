part of 'p_display_diary.dart';

class _DiaryCard extends StatelessWidget {
  const _DiaryCard({required this.diary, required this.accent});

  final DiaryEntity diary;
  final Color accent;

  Future<void> _handleModal(BuildContext context) async {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              IconButton(
                onPressed: () => dialogContext.router.pop(),
                icon: const Icon(Icons.clear, size: 18),
                tooltip: '취소',
              ),
              Text(
                '더 보기',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Text(
            '일기를 수정하거나 삭제할 수 있어요',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                foregroundColor: colorScheme.onSecondary,
              ),
              onPressed: () {
                // TODO: implement edit flow
              },
              child: const Text('수정'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () {
                // TODO: implement delete flow
              },
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DiaryPreviewCard(
      diary: diary,
      accent: accent,
      onTap: () => context.router.push(DiaryDetailRoute(diaryId: diary.id)),
      onMoreTap: () => _handleModal(context),
    );
  }
}
