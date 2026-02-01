part of 'p_agenda_detail.dart';

class _OnChoiceUnSelected extends StatefulWidget {
  const _OnChoiceUnSelected({required this.agenda});

  final AgendaDetailModel agenda;

  @override
  State<_OnChoiceUnSelected> createState() => _OnChoiceUnSelectedState();
}

class _OnChoiceUnSelectedState extends State<_OnChoiceUnSelected> {
  int? _tappedIndex;

  _handleTap(int index) => () {
    setState(() {
      _tappedIndex = (_tappedIndex == index) ? null : index;
    });
  };

  void _handleSubmit() async {
    if (_tappedIndex == null) return;

    context.read<AgendaDetailBloc>().add(
      AgendaDetailEvent.choiceSelected(
        userChoiceId: widget.agenda.choices[_tappedIndex!].id,
        userId: context.read<AuthenticationBloc>().state.currentUser!.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '투표하기',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Column(
          children: List.generate(widget.agenda.choices.length, (index) {
            final choice = widget.agenda.choices[index];
            final isSelected = index == _tappedIndex;
            return ListTile(
              onTap: _handleTap(index),
              leading: index == _tappedIndex
                  ? Icon(Icons.check_circle_outline, size: 20)
                  : Icon(Icons.circle_outlined, size: 18),
              title: Text(
                choice.label,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isSelected ? context.colorScheme.primary : null,
                ),
                overflow: TextOverflow.clip,
              ),
              subtitle: choice.description == null
                  ? null
                  : Text(
                      choice.description ?? '',
                      style: context.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
              selected: isSelected,
              selectedColor: context.colorScheme.primary,
              selectedTileColor: context.colorScheme.primary.withAlpha(12),
            );
          }),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: BlocBuilder<AgendaDetailBloc, AgendaDetailState>(
            builder: (context, state) {
              final tappable = _tappedIndex != null && !state.isLoading;
              return ElevatedButton.icon(
                onPressed: tappable ? _handleSubmit : null,
                icon: const Icon(Icons.how_to_vote_outlined),
                label: const Text('선택하기'),
              );
            },
          ),
        ),
      ],
    );
  }
}
