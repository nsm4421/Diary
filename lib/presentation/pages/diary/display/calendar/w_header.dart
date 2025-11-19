part of '../p_display_diary.dart';

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayCalendarBloc, DisplayCalendarState>(
      builder: (context, state) {
        final monthLabel =
            '${state.normalizedMonth.year}년 ${state.normalizedMonth.month}월';
        final isLoading = state.isLoading;

        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: isLoading
                  ? null
                  : () => _changeMonth(context, state.normalizedMonth, -1),
            ),
            Expanded(
              child: Center(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: isLoading
                      ? null
                      : () async {
                          final selected = await showModalBottomSheet<DateTime>(
                            context: context,
                            showDragHandle: true,
                            builder: (_) => _MonthPickerSheet(
                              initialMonth: state.normalizedMonth,
                            ),
                          );
                          if (selected == null ||
                              selected.normalizedMonth ==
                                  state.normalizedMonth ||
                              !context.mounted) {
                            return;
                          }
                          context.read<DisplayCalendarBloc>().add(
                            DisplayCalendarEvent.monthChanged(selected),
                          );
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      monthLabel,
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: isLoading
                  ? null
                  : () => _changeMonth(context, state.normalizedMonth, 1),
            ),
          ],
        );
      },
    );
  }

  void _changeMonth(BuildContext context, DateTime currentMonth, int offset) {
    final target = DateTime(currentMonth.year, currentMonth.month + offset);
    context.read<DisplayCalendarBloc>().add(
      DisplayCalendarEvent.monthChanged(target),
    );
  }
}
