part of '../p_display_diary.dart';

class _Preview extends StatelessWidget {
  const _Preview();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayCalendarBloc, DisplayCalendarState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.currentDiaries.isEmpty) {
          return Center(
            child: Text(
              '이 날에는 기록이 없어요.',
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: state.currentDiaries.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final diary = state.currentDiaries[index];
            return DiaryPreviewCard(
              diary: diary,
              accent: context.colorScheme.primary,
            );
          },
        );
      },
    );
  }
}
