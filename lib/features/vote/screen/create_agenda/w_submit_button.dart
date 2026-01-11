part of 'p_create_agenda.dart';

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAgendaBloc, CreateState<CreateAgendaData>>(
      builder: (context, state) {
        final bloc = context.read<CreateAgendaBloc>();
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: state.isLoading
                  ? null
                  : () {
                      bloc.add(CreateEvent.submit());
                    },
              style: FilledButton.styleFrom(
                backgroundColor: context.colorScheme.surfaceContainerHighest,
                foregroundColor: context.colorScheme.onSurface,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.isLoading) ...[
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          context.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(state.isLoading ? "등록 중..." : "제출하기"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
