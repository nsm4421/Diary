part of 'p_create_agenda.dart';

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAgendaCubit, CreateAgendaState>(
      builder: (context, state) {
        final tappable = state.status.isInitial;
        final colorScheme = context.colorScheme;
        return SizedBox(
          height: 44,
          child: OutlinedButton(
            onPressed: tappable
                ? () async {
                    await Future.delayed(200.durationInMilliSec, () async {
                      if (!context.mounted) return;
                      await context.read<CreateAgendaCubit>().submit();
                    });
                  }
                : null,
            style: ButtonStyle(
              textStyle: WidgetStateProperty.resolveWith(
                (_) => context.textTheme.labelLarge,
              ),
              padding: WidgetStateProperty.resolveWith(
                (_) => const EdgeInsets.symmetric(horizontal: 16),
              ),
              shape: WidgetStateProperty.resolveWith(
                (_) => RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              side: WidgetStateProperty.resolveWith((states) {
                final color = states.contains(WidgetState.disabled)
                    ? colorScheme.outlineVariant.withValues(alpha: 0.4)
                    : colorScheme.outlineVariant;
                return BorderSide(color: color, width: 1);
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                return states.contains(WidgetState.disabled)
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.onSurface;
              }),
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return colorScheme.onSurface.withValues(alpha: 0.04);
                }
                if (states.contains(WidgetState.hovered)) {
                  return colorScheme.onSurface.withValues(alpha: 0.02);
                }
                return null;
              }),
            ),
            child: const Text('등록하기'),
          ),
        );
      },
    );
  }
}
