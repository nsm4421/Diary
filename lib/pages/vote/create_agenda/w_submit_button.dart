part of 'p_create_agenda.dart';

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAgendaCubit, CreateAgendaState>(
      builder: (context, state) {
        final tappable = state.status.isInitial
        // state.title.trim().isNotEmpty &&
        // state.choices.length >= kMinChoiceCount
        ;
        return FilledButton(
          onPressed: tappable
              ? () async {
                  await Future.delayed(200.durationInMilliSec, () {
                    if (!context.mounted) return;
                    context.read<CreateAgendaCubit>().submit();
                  });
                }
              : null,
          child: const Text('등록하기'),
        );
      },
    );
  }
}
