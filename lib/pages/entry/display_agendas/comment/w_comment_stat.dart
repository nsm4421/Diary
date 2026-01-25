part of '../p_display_agendas.dart';

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

  void _handleNavigateToComment() async {
    // 인증여부 검사
    final currentUid = context.read<AuthenticationBloc>().state.currentUser?.id;
    if (currentUid == null) {
      ToastUtil.warning('로그인후에 사용할 수 있어요');
      return;
    }

    final commentCountDelta = await context.router.push<int>(
      DisplayAgendaCommentRoute(agendaId: widget._agenda.id),
    );
    if (commentCountDelta == null || !context.mounted) return;
    setState(() {
      _commentCount += commentCountDelta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleNavigateToComment,
      child: _StatItem(
        icon: Icons.chat_bubble_outline,
        label: _commentCount.toString(),
      ),
    );
  }
}
