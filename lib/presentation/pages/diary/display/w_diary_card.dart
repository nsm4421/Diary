part of 'p_display_diary.dart';

class _DiaryCard extends StatelessWidget {
  const _DiaryCard({required this.diary, required this.accent});

  final DiaryEntity diary;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return DiaryPreviewCard(
      diary: diary,
      accent: accent,
      // 상세페이지로 이동
      onTap: () async =>
          await context.router.push<bool>(DiaryDetailRoute(diaryId: diary.id)),
      // 우측상단 아이콘 클릭
      onMoreTap: () async =>
          await showDialog<bool>(
            context: context,
            builder: (dialogContext) {
              return _EditDiaryDialog(diary.id);
            },
          ).then((isDeleted) => isDeleted ?? false).then((isDeleted) {
            if (!isDeleted || !context.mounted) return;
            context.read<DisplayDiaryBloc>().add(
              DisplayEvent.removed(diary.id),
            );
          }),
    );
  }
}
