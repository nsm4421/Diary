import 'package:auto_route/auto_route.dart';
import 'package:diary/core/extension/build_context_extension.dart';
import 'package:diary/domain/entity/diary_entity.dart';
import 'package:diary/presentation/provider/diary/delete/delete_diary_cubit.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class EditDiaryDialog extends StatelessWidget {
  const EditDiaryDialog(this._diaryId, {super.key, this.onEdited});

  final String _diaryId;
  final void Function(DiaryEntity diary)? onEdited;

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
                    onPressed: () => context.router.maybePop(),
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
                    await context.router
                        .popAndPush<DiaryEntity, dynamic>(
                          EditDiaryRoute(diaryId: _diaryId),
                        )
                        .then((diary) {
                          debugPrint('[EditDiaryDialog]modal closed');
                          if (diary == null || onEdited == null) return;
                          debugPrint('[EditDiaryDialog]diary edited');
                          onEdited!(diary);
                        });
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
