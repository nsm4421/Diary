part of 'p_search_diary.dart';

class _Screen extends StatelessWidget {
  const _Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final onPrimaryColor = context.colorScheme.onPrimary;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        iconTheme: IconThemeData(color: onPrimaryColor),
        title: Row(
          children: [
            AppLogoHero(
              backgroundColor: onPrimaryColor.withAlpha(28),
              borderColor: onPrimaryColor.withAlpha(48),
              iconColor: onPrimaryColor,
            ),
            const SizedBox(width: 12),
            Text(
              '일기 찾기',
              style: context.textTheme.titleLarge?.copyWith(
                color: onPrimaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colorScheme.primary,
                  context.colorScheme.primaryContainer,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: 84,
            right: -16,
            child: Icon(
              Icons.search_rounded,
              size: 120,
              color: onPrimaryColor.withAlpha(22),
            ),
          ),
          Positioned(
            bottom: 140,
            left: -20,
            child: Icon(
              Icons.menu_book_rounded,
              size: 140,
              color: onPrimaryColor.withAlpha(18),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: BlocBuilder<SearchDiaryCubit, FetchDiaryParam>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      top: kToolbarHeight + 16,
                      bottom: 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '찾고 싶은 기록이 있나요?',
                                style: context.textTheme.titleMedium?.copyWith(
                                  color: onPrimaryColor.withAlpha(235),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '검색 기준을 선택하고 원하는 조건을 입력해보세요.',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: onPrimaryColor.withAlpha(190),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _SearchKindSelector(selectedKind: state.kind),
                        const SizedBox(height: 24),
                        switch (state.kind) {
                          SearchDiaryKind.title => const _SearchTitle(),
                          SearchDiaryKind.content => const _SearchContent(),
                          (_) => SizedBox.shrink(),
                        },
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
