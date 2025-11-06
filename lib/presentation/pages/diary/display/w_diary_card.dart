part of 'p_display_diary.dart';

class _DiaryCard extends StatefulWidget {
  const _DiaryCard({required this.diary, required this.accent});

  final DiaryEntity diary;
  final Color accent;

  @override
  State<_DiaryCard> createState() => _DiaryCardState();
}

class _DiaryCardState extends State<_DiaryCard> {
  bool _showActions = false;

  Future<void> _handleModal(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              IconButton(
                onPressed: () => dialogContext.router.pop(),
                icon: Icon(Icons.clear, size: 18),
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
                // TODO: implement delete diary flow
              },
              child: const Text('수정'),
            ),

            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () {
                // TODO: implement delete diary flow
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final diary = widget.diary;
    final accent = widget.accent;
    final trimmedTitle = diary.title?.trim();
    final String? effectiveTitle =
        (trimmedTitle != null && trimmedTitle.isNotEmpty) ? trimmedTitle : null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => context.router.push(DiaryDetailRoute(diaryId: diary.id)),
        child: Ink(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                colorScheme.surface.withAlpha(245),
                colorScheme.surface.withAlpha(224),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withAlpha(46),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
            border: Border.all(color: colorScheme.onSurface.withAlpha(15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: accent.withAlpha(217),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        diary.createdAt.toLocal().yyyymmdd,
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant.withAlpha(184),
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),

                  Spacer(),

                  Tooltip(
                    message: '더보기',
                    child: Material(
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => _handleModal(context),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            Icons.more_vert_outlined,
                            size: 18,
                            color: accent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              if (effectiveTitle != null) ...[
                const SizedBox(height: 16),
                Text(
                  effectiveTitle,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                diary.content,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withAlpha(235),
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
