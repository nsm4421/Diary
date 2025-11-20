part of 'p_display_diary.dart';

class _FeedStyleDiariesList extends StatefulWidget {
  const _FeedStyleDiariesList();

  @override
  State<_FeedStyleDiariesList> createState() => _FeedStyleDiariesListState();
}

class _FeedStyleDiariesListState extends State<_FeedStyleDiariesList> {
  static const _paginationThreshold = 200.0;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      debugPrint('scroll controller can not find its client');
      return;
    } else {
      final current = context.read<DisplayDiaryBloc>().state;
      if (current.isEnd ||
          current.status == DisplayStatus.paginated ||
          current.status == DisplayStatus.loading ||
          current.status == DisplayStatus.refreshing) {
        debugPrint('scroll request dropped1');
        return;
      }
    }
    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0 ||
        position.pixels < position.maxScrollExtent - _paginationThreshold) {
      debugPrint('scroll request dropped2');
      return;
    }

    debugPrint('next page requested');
    context.read<DisplayDiaryBloc>().add(
      DisplayEvent<DiaryEntity>.nextPageRequested(),
    );
  }

  Future<void> _handleRefresh() async {
    context.read<DisplayDiaryBloc>().add(DisplayEvent<DiaryEntity>.refreshed());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<DisplayDiaryBloc, DisplayState<DiaryEntity, DateTime>>(
      builder: (context, state) {
        if (state.isEmpty) {
          return (state.isLoading || state.isInitial)
              ? const Center(child: CircularProgressIndicator())
              : _EmptyState();
        }

        return RefreshIndicator(
          color: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          onRefresh: _handleRefresh,
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              32 + context.padding.bottom,
            ),
            itemCount: state.items.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 28,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.onPrimary.withAlpha(36),
                        colorScheme.onPrimary.withAlpha(20),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: colorScheme.onPrimary.withAlpha(56),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '오늘의 기억',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '감정과 순간을 간직할 수 있도록\n매일의 이야기를 기록해보세요.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimary.withAlpha(209),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final diary = state.items[index - 1];
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: _DiaryCard(diary: diary, accent: colorScheme.secondary),
              );
            },
          ),
        );
      },
    );
  }
}
