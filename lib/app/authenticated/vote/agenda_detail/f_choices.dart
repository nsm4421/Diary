part of 'p_agenda_detail.dart';

class _ChoiceSection extends StatelessWidget {
  const _ChoiceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgendaDetailBloc, AgendaDetailState>(
      buildWhen: (prev, curr) =>
          prev.agenda?.myChoiceId != curr.agenda?.myChoiceId,
      builder: (context, state) {
        final agenda = state.agenda;
        final myChoiceId = state.agenda?.myChoiceId;

        if (agenda == null) return SizedBox.shrink();

        return myChoiceId == null
            ? _OnChoiceUnSelected(agenda: agenda)
            : _OnChoiceSelected(agenda: agenda, myChoiceId: myChoiceId);
      },
    );
  }
}
