part of 'p_search_diary.dart';

class _ContentCriteriaBody extends StatelessWidget {
  const _ContentCriteriaBody({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: '제목이나 내용을 입력하세요',
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _DateCriteriaBody extends StatelessWidget {
  const _DateCriteriaBody({
    required this.range,
    required this.onPickRange,
    this.onClearRange,
  });

  final DateTimeRange? range;
  final VoidCallback onPickRange;
  final VoidCallback? onClearRange;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasRange = range != null;
    final title = hasRange
        ? '${range!.start.yyyymmdd}~${range!.end.yyyymmdd}'
        : '날짜 범위를 선택해서 검색하세요';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            IconButton(
              tooltip: '날짜 선택',
              onPressed: onPickRange,
              icon: const Icon(Icons.date_range),
            ),
            if (hasRange)
              IconButton(
                tooltip: '선택 해제',
                onPressed: onClearRange,
                icon: const Icon(Icons.close_rounded),
              ),
          ],
        ),
      ],
    );
  }
}
