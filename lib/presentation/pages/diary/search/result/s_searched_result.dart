part of 'p_searched_result.dart';

class _Screen extends StatelessWidget {
  const _Screen(this._param, {super.key});

  final FetchDiaryParam _param;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          switch (_param.kind) {
            SearchDiaryKind.content => Icons.notes_rounded,
            SearchDiaryKind.dateRange => Icons.date_range_rounded,
            (_) => Icons.title_rounded,
          },
          size: 16,
          color: context.colorScheme.primary,
        ),
        title: Text(
          switch (_param.kind) {
            SearchDiaryKind.content =>
              (_param as FetchDiaryByContentParamValue).content,
            SearchDiaryKind.dateRange =>
              (_param as FetchDiaryByDateRangeParamValue).label,
            (_) => (_param as FetchDiaryByTitleParamValue).title,
          },
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(230),
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.router.pop();
            },
            icon: Icon(Icons.clear),
          ),
        ],
      ),
      body: BlocBuilder<DisplayDiaryBloc, DisplayState<DiaryEntity, DateTime>>(
        builder: (context, state) {
          if (state.status == DisplayStatus.loading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null && state.items.isEmpty) {
            final message = state.errorMessage ?? '문제가 발생했습니다.';
            return _FailureView(
              message: message,
              onRetry: () => context.read<DisplayDiaryBloc>().add(
                const DisplayEvent<DiaryEntity>.started(),
              ),
            );
          }

          if (state.items.isEmpty) {
            return const _EmptyResultView();
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DisplayDiaryBloc>().add(
                const DisplayEvent<DiaryEntity>.refreshed(),
              );
            },
            child: _DiariesList(state: state),
          );
        },
      ),
    );
  }
}
