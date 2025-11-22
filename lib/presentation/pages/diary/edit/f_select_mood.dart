part of 'p_edit_diary.dart';

class _SelectMood extends StatelessWidget {
  const _SelectMood({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditDiaryCubit, EditDiaryState>(
      buildWhen: (previous, current) =>
          (previous.status != current.status) || previous.mood != current.mood,
      builder: (context, state) {
        return InkWell(
          onTap: state.isSubmitting
              ? null
              : () async {
                  await showModalBottomSheet<DiaryMood?>(
                    context: context,
                    backgroundColor: context.colorScheme.surface,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(26),
                      ),
                    ),
                    builder: (_) =>
                        _MoodDialog(context.read<EditDiaryCubit>().state.mood),
                  ).then((selected) {
                    debugPrint(selected?.meta.label);
                    if (selected == null ||
                        !context.mounted ||
                        state.mood == selected)
                      return;
                    context.read<EditDiaryCubit>().handleChange(mood: selected);
                  });
                },
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: context.colorScheme.surface.withAlpha(242),
              border: Border.all(
                color: context.colorScheme.onSurface.withAlpha(13),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -8,
                  top: -8,
                  child: Icon(
                    state.mood.meta.icons,
                    size: 52,
                    color: context.colorScheme.primary.withAlpha(40),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.colorScheme.primary.withAlpha(40),
                          ),
                          child: Icon(
                            Icons.emoji_emotions_rounded,
                            color: context.colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '오늘의 기분',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: state.mood.isNone
                                ? context.colorScheme.surfaceContainerHighest
                                : context.colorScheme.primary.withAlpha(32),
                            border: Border.all(
                              color: state.mood.isNone
                                  ? context.colorScheme.onSurface.withAlpha(40)
                                  : context.colorScheme.primary.withAlpha(96),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                state.mood.meta.icons,
                                size: 16,
                                color: state.mood.isNone
                                    ? context.colorScheme.onSurfaceVariant
                                    : context.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                state.mood.meta.label,
                                style: context.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: state.mood.isNone
                                      ? context.colorScheme.onSurfaceVariant
                                      : context.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.mood.meta.hint,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurfaceVariant.withAlpha(
                          210,
                        ),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
