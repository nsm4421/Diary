part of 'p_display_agendas.dart';

class _ReactionStat extends StatefulWidget {
  final AgendaFeedModel _agenda;

  const _ReactionStat(this._agenda);

  @override
  State<_ReactionStat> createState() => _ReactionStatState();
}

class _ReactionStatState extends State<_ReactionStat> {
  late VoteReactionCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<VoteReactionCubit>();
  }

  Function() _handleReaction(VoteReaction tapped) => () async {
    // 인증여부 검사
    final currentUid = context.read<AuthenticationBloc>().state.currentUser?.id;
    if (currentUid == null) {
      ToastUtil.warning('로그인후에 사용할 수 있어요');
      return;
    }

    await _cubit.handleReaction(tapped: tapped, currentUid: currentUid);
  };

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoteReactionCubit, VoteReactonState>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _handleReaction(VoteReaction.like),
              child: _StatItem(
                icon: state.isLike ? Icons.thumb_up : Icons.thumb_up_outlined,
                label: state.likeCount.toString(),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _handleReaction(VoteReaction.dislike),
              child: _StatItem(
                icon: state.isDislike
                    ? Icons.thumb_down
                    : Icons.thumb_down_outlined,
                label: state.dislikeCount.toString(),
              ),
            ),
          ],
        );
      },
    );
  }
}
