part of 'p_searched_result.dart';

class _EmptyResultView extends StatelessWidget {
  const _EmptyResultView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              '조회된 일기가 없어요',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '검색 조건을 조금 더 완화하거나 다른 키워드로 검색해 보세요.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
