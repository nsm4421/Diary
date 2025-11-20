part of 'p_search_diary.dart';

class _SearchKindSelector extends StatelessWidget {
  const _SearchKindSelector({required this.selectedKind});

  final SearchDiaryKind selectedKind;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.colorScheme.surface.withAlpha(230),
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
              children: [SearchDiaryKind.title, SearchDiaryKind.content]
                  .map(
                    (kind) => ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          switch (kind) {
                            SearchDiaryKind.title => Icon(
                              Icons.title_rounded,
                              size: 16,
                            ),
                            SearchDiaryKind.content => Icon(
                              Icons.notes_rounded,
                              size: 16,
                            ),
                            _ => SizedBox.shrink(),
                          },
                          const SizedBox(width: 6),
                          switch (kind) {
                            SearchDiaryKind.title => Text("제목"),
                            SearchDiaryKind.content => Text("본문"),
                            _ => SizedBox.shrink(),
                          },
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
