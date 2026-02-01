part of 'p_vote_entry.dart';

class _ReactionStat extends StatelessWidget {
  const _ReactionStat(this._agenda);

  final AgendaFeedModel _agenda;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final VoteReactionParams params = (
          agendaId: _agenda.id,
          likeCount: _agenda.likeCount,
          dislikeCount: _agenda.dislikeCount,
          myReaction: _agenda.reaction,
        );
        return GetIt.instance<VoteReactionCubit>(param1: params);
      },
      child: _ReactionButtons(),
    );
  }
}
