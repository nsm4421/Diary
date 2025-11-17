part of 'p_search_diary.dart';

class _Screen extends StatelessWidget {
  const _Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Row(
          children: [
            AppLogoHero(
              backgroundColor: context.colorScheme.onPrimary.withAlpha(31),
              borderColor: context.colorScheme.onPrimary.withAlpha(51),
              iconColor: context.colorScheme.onPrimary,
            ),
            const SizedBox(width: 12),
            Text(
              '일기 검색',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      body: BlocBuilder<SearchDiaryCubit, FetchDiaryParam>(
        builder: (context, state) {
          final topInset = context.padding.top + kToolbarHeight;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16, topInset + 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SearchKindSelector(selectedKind: state.kind),
                const SizedBox(height: 24),
                switch (state.kind) {
                  SearchDiaryKind.content => _SearchContent(),
                  SearchDiaryKind.dateRange => _PickDateRange(),
                  (_) => _SearchTitle(),
                },
              ],
            ),
          );
        },
      ),
    );
  }
}
