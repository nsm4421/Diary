part of 'p_searched_result.dart';

class _DiariesList extends StatefulWidget {
  const _DiariesList({required this.state});

  final DisplayState<DiaryEntity, DateTime> state;

  @override
  State<_DiariesList> createState() => _DiariesListState();
}

class _DiariesListState extends State<_DiariesList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.extentAfter > 320) return;

    final bloc = context.read<DisplayDiaryBloc>();
    final state = bloc.state;
    if (state.isEnd ||
        state.status == DisplayStatus.loading ||
        state.status == DisplayStatus.refreshing ||
        state.status == DisplayStatus.paginated) {
      return;
    }

    bloc.add(const DisplayEvent<DiaryEntity>.nextPageRequested());
  }

  Future<void> _openDetail(DiaryEntity diary) async {
    await context.router.push(DiaryDetailRoute(diaryId: diary.id));
  }

  @override
  Widget build(BuildContext context) {
    final diaries = widget.state.items;
    final isLoadingMore =
        widget.state.status == DisplayStatus.paginated && diaries.isNotEmpty;
    final paddingBottom = 16 + context.padding.bottom;

    return ListView.separated(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16, 16, 16, paddingBottom),
      itemCount: diaries.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index >= diaries.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final diary = diaries[index];
        final subtitle = diary.content.isEmpty
            ? '내용이 없습니다.'
            : diary.content.trim();
        final dateLabel = diary.createdAt.yyyymmdd;

        return Card(
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            onTap: () => _openDetail(diary),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          diary.title?.trim().isEmpty ?? true
                              ? '제목 없음'
                              : diary.title!.trim(),
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateLabel,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha(204),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
