part of 'p_agenda_detail.dart';

class _OnChoiceSelected extends StatefulWidget {
  const _OnChoiceSelected({required this.myChoiceId, required this.agenda});

  final String myChoiceId;
  final AgendaDetailModel agenda;

  @override
  State<_OnChoiceSelected> createState() => _OnChoiceSelectedState();
}

class _OnChoiceSelectedState extends State<_OnChoiceSelected> {

  late int _totalVoteCount = 0;
  late int _maxVotedChoiceCount = 0;

  Widget _buildTag(
    BuildContext context, {
    required String label,
    required Color textColor,
    required Color borderColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.agenda.choices.forEach((choice) {
      _totalVoteCount += choice.voteCount;
      _maxVotedChoiceCount = max<int>(choice.voteCount, _maxVotedChoiceCount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Text(
                '투표 결과',
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '총 $_totalVoteCount표',
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        ...List.generate(widget.agenda.choices.length, (index) {
          final choice = widget.agenda.choices[index];
          final userSelected = choice.id == widget.myChoiceId;
          final isMax = choice.voteCount == _maxVotedChoiceCount;
          final showTags = isMax || userSelected;
          final percent = _totalVoteCount == 0
              ? 0
              : ((choice.voteCount / _totalVoteCount) * 100).round();
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  choice.label,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: userSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (showTags) const SizedBox(height: 6),
                if (showTags)
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (isMax)
                        _buildTag(
                          context,
                          label: '최다 득표',
                          textColor: context.colorScheme.primary,
                          borderColor: context.colorScheme.primary.withAlpha(90),
                          backgroundColor:
                              context.colorScheme.primary.withAlpha(12),
                        ),
                      if (userSelected)
                        _buildTag(
                          context,
                          label: '내 선택',
                          textColor: context.colorScheme.onSurfaceVariant,
                          borderColor: context.colorScheme.outlineVariant,
                          backgroundColor: context
                              .colorScheme.surfaceContainerHighest
                              .withAlpha(
                            70,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
            subtitle: choice.description == null
                ? null
                : Text(
                    choice.description ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${choice.voteCount}표',
                  style: isMax
                      ? context.textTheme.labelLarge?.copyWith(
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        )
                      : context.textTheme.labelMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$percent%',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            isThreeLine: choice.description != null,
            selected: userSelected,
            selectedColor: context.colorScheme.onSurface,
            selectedTileColor:
                context.colorScheme.surfaceContainerHighest.withAlpha(50),
          );
        }),
      ],
    );
  }
}
