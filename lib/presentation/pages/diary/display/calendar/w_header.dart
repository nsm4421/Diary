part of 'p_calendar.dart';

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayCalendarBloc, DisplayCalendarState>(
      builder: (context, state) {
        final monthLabel =
            '${state.normalizedMonth.year}년 ${state.normalizedMonth.month}월';
        final isLoading = state.isLoading;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceVariant.withAlpha(90),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            children: [
              _ArrowButton(
                icon: Icons.chevron_left,
                onPressed: isLoading
                    ? null
                    : () => _changeMonth(context, state.normalizedMonth, -1),
              ),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(32),
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
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          monthLabel,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          state.currentDate == null
                              ? '기록을 확인할 날짜를 선택하세요'
                              : '선택된 날짜: ${state.currentDate!.yyyymmdd}',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _ArrowButton(
                icon: Icons.chevron_right,
                onPressed: isLoading
                    ? null
                    : () => _changeMonth(context, state.normalizedMonth, 1),
              ),
            ],
          ),
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

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: context.colorScheme.surface.withAlpha(180),
        shape: const CircleBorder(),
      ),
      icon: Icon(icon),
    );
  }
}
