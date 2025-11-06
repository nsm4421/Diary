part of 'p_search_diary.dart';

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: colorScheme.surface.withAlpha(242),
        border: Border.all(color: colorScheme.onSurface.withAlpha(13)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withAlpha(31),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: colorScheme.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: const InputDecoration(
                hintText: '제목 또는 내용으로 검색해보세요',
                border: InputBorder.none,
              ),
              onChanged: (_) {
                // TODO: trigger search logic
              },
            ),
          ),
          IconButton(
            tooltip: '검색어 지우기',
            onPressed: () => controller.clear(),
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}

class _SearchPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 72,
            color: colorScheme.onPrimary.withAlpha(153),
          ),
          const SizedBox(height: 24),
          Text(
            '검색 결과가 여기에 표시돼요',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '검색 기능은 곧 추가될 예정입니다.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimary.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }
}
