part of 'p_display_diary.dart';

class _DiariesList extends StatelessWidget {
  const _DiariesList({required this.controller, required this.diaries});

  final ScrollController controller;
  final List<DiaryEntity> diaries;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ListView.builder(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 32 + context.padding.bottom),
      itemCount: diaries.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
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
              border: Border.all(color: colorScheme.onPrimary.withAlpha(56)),
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

        final diary = diaries[index - 1];
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: _DiaryCard(diary: diary, accent: colorScheme.secondary),
        );
      },
    );
  }
}
