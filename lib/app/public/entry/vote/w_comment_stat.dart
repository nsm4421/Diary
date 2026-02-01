part of 'p_vote_entry.dart';

class _CommentStat extends StatefulWidget {
  const _CommentStat(this._agenda, {super.key});

  final AgendaFeedModel _agenda;

  @override
  State<_CommentStat> createState() => _CommentStatState();
}

class _CommentStatState extends State<_CommentStat> {
  late int _commentCount;

  @override
  void initState() {
    super.initState();
    _commentCount = widget._agenda.commentCount;
  }

  void _handleNavigateToComment(BuildContext ctx) async {
    // 인증여부 검사
    final isAuth = await ctx.read<AuthenticationBloc>().resolveIsAuth();
    if (!isAuth) {
      ToastUtil.warning('로그인후에 사용할 수 있어요');
      return;
    }
    if (!ctx.mounted) return;

    final result = await ctx.router.push<AgendaCommentPageResult>(
      DisplayAgendaCommentRoute(agendaId: widget._agenda.id),
    );
    if (result == null || !ctx.mounted) return;
    setState(() {
      _commentCount += result.commentCountDelta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleNavigateToComment(context),
      child: IconWithTextWidget(
        icon: Icons.chat_bubble_outline,
        label: _commentCount.toString(),
      ),
    );
  }
}

