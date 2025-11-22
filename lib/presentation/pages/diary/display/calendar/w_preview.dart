part of 'p_calendar.dart';

class _Preview extends StatelessWidget {
  const _Preview();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayCalendarBloc, DisplayCalendarState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.currentDiaries.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 48,
                color: context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                '이 날에는 기록이 없어요.',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '감정을 기록하고 싶은 날을 터치해 새로운 이야기를 남겨보세요.',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: state.currentDiaries.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final diary = state.currentDiaries[index];
            return GestureDetector(
              onTap: () async {
                await context.router.push(DiaryDetailRoute(diaryId: diary.id));
              },
              child: DiaryPreviewCard(
                diary: diary,
                accent: context.colorScheme.primary,
                // 우측상단 아이콘 클릭
                onMoreTap: () async =>
                    await showDialog<bool>(
                      context: context,
                      builder: (_) => EditDiaryDialog(
                        diary.id,
                        onEdited: (diary) {
                          context.read<DisplayCalendarBloc>().add(
                            DisplayCalendarEvent.modified(diary),
                          );
                        },
                      ),
                    ).then((isDeleted) => isDeleted ?? false).then((isDeleted) {
                      if (!isDeleted || !context.mounted) return;
                      context.read<DisplayCalendarBloc>().add(
                        DisplayCalendarEvent.removed(diary.id),
                      );
                    }),
              ),
            );
          },
        );
      },
    );
  }
}
