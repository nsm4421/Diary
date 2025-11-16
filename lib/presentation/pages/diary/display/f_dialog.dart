part of 'p_display_diary.dart';

class _EditDiaryDialog extends StatelessWidget {
  const _EditDiaryDialog(this._diaryId, {super.key});

  final String _diaryId;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (_) => GetIt.instance<DeleteDiaryCubit>(param1: _diaryId),
      child: BlocListener<DeleteDiaryCubit, DeleteDiaryState>(
        listener: (context, state) async {
          if (state.isFailure) {
            context
              ..showToast(state.errorMessage)
              ..read<DeleteDiaryCubit>().reset();
          } else if (state.isDeleted) {
            context
              ..showToast('일기가 삭제되었습니다')
              ..maybePop<bool>(true);
          }
        },
        child: BlocBuilder<DeleteDiaryCubit, DeleteDiaryState>(
          builder: (context, state) {
            return AlertDialog(
              title: Row(
                children: [
                  IconButton(
                    onPressed: () => context.router.pop(),
                    icon: const Icon(Icons.clear, size: 18),
                    tooltip: '취소',
                  ),
                  Text(
                    '더 보기',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              content: Text(
                '일기를 수정하거나 삭제할 수 있어요',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              actions: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: colorScheme.onSecondary,
                  ),
                  onPressed: () async {
                    await context.router.popAndPush(EditDiaryRoute());
                  },
                  child: const Text('수정'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                  ),
                  onPressed: state.isReady
                      ? () async {
                          // 삭제 요청
                          await context.read<DeleteDiaryCubit>().delete();
                        }
                      : null,
                  child: state.isReady
                      ? const Text('삭제')
                      : Transform.scale(
                          scale: 0.5,
                          child: CircularProgressIndicator(),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
