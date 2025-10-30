part of 'p_display_diary.dart';

class _DiariesListFragment extends StatelessWidget {
  const _DiariesListFragment({required this.controller, required this.diaries});

  final ScrollController controller;
  final List<DiaryEntry> diaries;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: diaries.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index >= diaries.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final diary = diaries[index];
        final trimmedTitle = diary.title?.trim();
        final String? effectiveTitle =
            (trimmedTitle != null && trimmedTitle.isNotEmpty)
            ? trimmedTitle
            : null;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (effectiveTitle != null) ...[
                Text(
                  effectiveTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
              ],
              Text(
                diary.content,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  diary.createdAt.toLocal().yyyymmdd,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
