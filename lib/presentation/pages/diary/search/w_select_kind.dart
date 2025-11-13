part of 'p_search_diary.dart';

class _SearchKindSelector extends StatelessWidget {
  const _SearchKindSelector({required this.selectedKind});

  final SearchDiaryKind selectedKind;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '검색 기준',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: SearchDiaryKind.values
                  .where((e) => e != SearchDiaryKind.none)
                  .map(
                    (kind) => ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(switch (kind) {
                            SearchDiaryKind.content => Icons.notes_rounded,
                            SearchDiaryKind.dateRange =>
                              Icons.date_range_rounded,
                            _ => Icons.title_rounded,
                          }, size: 16),
                          const SizedBox(width: 6),
                          Text(switch (kind) {
                            SearchDiaryKind.content => '본문',
                            SearchDiaryKind.dateRange => '기간',
                            _ => '제목',
                          }),
                        ],
                      ),
                      selected: selectedKind == kind,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onSelected: (isSelected) {
                        if (!isSelected || kind == selectedKind) return;
                        context.read<SearchDiaryCubit>().switchKind(kind);
                      },
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }
}
