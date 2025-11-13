part of 'p_search_diary.dart';

class _PickDateRange extends StatefulWidget {
  const _PickDateRange({super.key});

  @override
  State<_PickDateRange> createState() => _PickDateRangeState();
}

class _PickDateRangeState extends State<_PickDateRange> {
  late DateTimeRange _range;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _range = DateTimeRange(
      start: now.subtract(const Duration(days: 6)),
      end: now,
    );
    final state = context.read<SearchDiaryCubit>().state;
    if (state is FetchDiaryByDateRangeParamValue) {
      _range = DateTimeRange(start: state.start, end: state.end);
    }
  }

  Future<void> _pickRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _range,
      helpText: '검색 기간 선택',
      saveText: '완료',
    );

    if (picked == null) return;
    setState(() {
      _range = picked;
    });
    context.read<SearchDiaryCubit>().updateDateRange(
      start: picked.start,
      end: picked.end,
    );
  }

  Future<void> _submitSearch() async {
    final param = context.read<SearchDiaryCubit>().state;
    if (param is! FetchDiaryByDateRangeParamValue) return;
    FocusScope.of(context).unfocus();
    await context.router.push(SearchedResultRoute(param: param));
  }

  @override
  Widget build(BuildContext context) {
    final helperStyle = context.textTheme.bodySmall?.copyWith(
      color: context.colorScheme.onSurfaceVariant,
    );

    return BlocListener<SearchDiaryCubit, FetchDiaryParam>(
      listenWhen: (previous, current) =>
          previous != current && current is FetchDiaryByDateRangeParamValue,
      listener: (context, state) {
        if (state is! FetchDiaryByDateRangeParamValue) return;
        setState(() {
          _range = DateTimeRange(start: state.start, end: state.end);
        });
      },
      child: Card(
        elevation: 0,
        color: context.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '기간으로 검색',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text('시작일과 종료일을 모두 포함해서 결과를 보여드려요.', style: helperStyle),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _DatePreview(
                      label: '시작',
                      dateLabel: _range.start.yyyymmdd,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.east_rounded,
                      color: context.colorScheme.outline,
                    ),
                  ),
                  Expanded(
                    child: _DatePreview(
                      label: '종료',
                      dateLabel: _range.end.yyyymmdd,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pickRange,
                icon: const Icon(Icons.date_range_rounded),
                label: const Text('기간 선택하기'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('최대 1년 범위까지 선택할 수 있어요.', style: helperStyle),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _submitSearch,
                icon: const Icon(Icons.search_rounded),
                label: const Text('기간 검색'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DatePreview extends StatelessWidget {
  const _DatePreview({required this.label, required this.dateLabel});

  final String label;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            dateLabel,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
