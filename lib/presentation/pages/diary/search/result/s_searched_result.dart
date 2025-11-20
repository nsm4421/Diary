part of 'p_searched_result.dart';

class _Screen extends StatelessWidget {
  const _Screen(this._param, {super.key});

  final FetchDiaryParam _param;

  String? _queryLabel() {
    final param = _param;
    if (param is FetchDiaryByTitleParamValue) {
      final keyword = param.title.trim();
      return keyword.isEmpty ? '제목 검색' : '제목: $keyword';
    }
    if (param is FetchDiaryByContentParamValue) {
      final keyword = param.content.trim();
      return keyword.isEmpty ? '본문 검색' : '본문: $keyword';
    }
    if (param is FetchDiaryByDateRangeParamValue) {
      return '기간: ${param.label}';
    }
    return '전체 일기';
  }

  @override
  Widget build(BuildContext context) {
    final onPrimaryColor = context.colorScheme.onPrimary;
    final queryLabel = _queryLabel();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () async => context.router.maybePop(),
          icon: const Icon(Icons.close_rounded),
        ),
        iconTheme: IconThemeData(color: onPrimaryColor),
        title: Row(
          children: [
            AppLogoHero(
              backgroundColor: onPrimaryColor.withAlpha(28),
              borderColor: onPrimaryColor.withAlpha(48),
              iconColor: onPrimaryColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '검색 결과',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: onPrimaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (queryLabel != null)
                    Text(
                      queryLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: onPrimaryColor.withAlpha(210),
                      ),
                    ),
                ],
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
            top: 96,
            right: -20,
            child: Icon(
              Icons.search_rounded,
              size: 120,
              color: onPrimaryColor.withAlpha(18),
            ),
          ),
          Positioned(
            bottom: 160,
            left: -24,
            child: Icon(
              Icons.book_outlined,
              size: 150,
              color: onPrimaryColor.withAlpha(16),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: kToolbarHeight + 16, bottom: 16),
              child:
                  BlocBuilder<
                    DisplayDiaryBloc,
                    DisplayState<DiaryEntity, DateTime>
                  >(
                    builder: (context, state) {
                      if (state.status == DisplayStatus.loading &&
                          state.items.isEmpty) {
                        return Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                onPrimaryColor,
                              ),
                            ),
                          ),
                        );
                      }

                      if (state.errorMessage != null && state.items.isEmpty) {
                        final message = state.errorMessage ?? '문제가 발생했습니다.';
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _FailureView(
                            message: message,
                            onRetry: () => context.read<DisplayDiaryBloc>().add(
                              const DisplayEvent<DiaryEntity>.started(),
                            ),
                          ),
                        );
                      }

                      if (state.items.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: _EmptyResultView(),
                        );
                      }

                      return RefreshIndicator(
                        color: onPrimaryColor,
                        backgroundColor: context.colorScheme.primaryContainer
                            .withAlpha(220),
                        onRefresh: () async {
                          context.read<DisplayDiaryBloc>().add(
                            const DisplayEvent<DiaryEntity>.refreshed(),
                          );
                        },
                        child: _DiariesList(state: state),
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
