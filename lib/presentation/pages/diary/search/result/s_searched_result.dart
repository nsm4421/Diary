part of '../p_search_diary.dart';

class _SearchedResult extends StatelessWidget {
  const _SearchedResult({
    required this.criteriaSummary,
    required this.option,
    required this.diaries,
  });

  final String criteriaSummary;
  final _SearchOption option;
  final List<DiaryEntity> diaries;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final icon = option == _SearchOption.content
        ? Icons.text_snippet_outlined
        : Icons.calendar_view_month_outlined;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          '검색 결과',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primaryContainer,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: colorScheme.surface.withOpacity(0.85),
                      border: Border.all(
                        color: colorScheme.onSurface.withOpacity(0.08),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(icon, color: colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            criteriaSummary,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: diaries.isEmpty
                        ? _ResultEmpty(option: option)
                        : ListView.separated(
                            itemCount: diaries.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16),
                            padding: const EdgeInsets.only(bottom: 32),
                            itemBuilder: (_, index) {
                              final diary = diaries[index];
                              return DiaryPreviewCard(
                                diary: diary,
                                accent: colorScheme.secondary,
                                onTap: () => context.router.push(
                                  DiaryDetailRoute(diaryId: diary.id),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultEmpty extends StatelessWidget {
  const _ResultEmpty({required this.option});

  final _SearchOption option;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final icon = option == _SearchOption.content
        ? Icons.search_off_rounded
        : Icons.event_busy_rounded;

    final message = option == _SearchOption.content
        ? '입력한 단어와 일치하는 일기를 찾지 못했어요.'
        : '선택한 기간에 작성된 일기가 없어요.';

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 72, color: colorScheme.onPrimary.withAlpha(160)),
          const SizedBox(height: 16),
          Text(
            '검색 결과가 없습니다',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimary.withAlpha(200),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
