part of 'p_display_agendas.dart';

class _ReactionStat extends StatelessWidget {
  final AgendaFeedModel _agenda;

  const _ReactionStat(this._agenda);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AgendaReactionCubit, AgendaReactionState>(
      listener: (context, state) {
        context.read<DisplayAgendasBloc>().add(
          DisplayAgendaEvent.reaction(
            agendaId: _agenda.id,
            reaction: state.current,
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              print("tap");
              // if (context.read<AgendaReactionCubit>().state.isLoading) return;
              context.read<AgendaReactionCubit>().addReaction(
                VoteReaction.like,
              );
            },
            child: _StatItem(
              icon: Icons.thumb_up_outlined,
              // TODO : 숫자 증가 optimistic update
              label: _agenda.likeCount.toString(),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              if (context.read<AgendaReactionCubit>().state.isLoading) return;
              context.read<AgendaReactionCubit>().addReaction(
                VoteReaction.dislike,
              );
            },
            child: _StatItem(
              icon: Icons.thumb_down_outlined,
              label: _agenda.dislikeCount.toString(),
            ),
          ),
        ],
      ),
    );
  }
}
