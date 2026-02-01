part of 'p_agenda_detail.dart';

class _CommentSection extends StatefulWidget {
  const _CommentSection(this._agenda, {super.key});

  final AgendaDetailModel _agenda;

  @override
  State<_CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<_CommentSection> {
  late int _commentCount;
  late String? _latestComment;

  @override
  void initState() {
    super.initState();
    _commentCount = widget._agenda.commentCount;
    _latestComment = widget._agenda.latestComment;
  }

  _handleNavigateToCommentPage(BuildContext ctx) async {
    // 댓글 페이지 보여주기
    final result = await showModalBottomSheet<AgendaCommentPageResult>(
      context: ctx,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) {
        return DisplayAgendaCommentPage(agendaId: widget._agenda.id);
      },
    );

    // 유저가 댓글을 작성한 경우 optimistic update
    if (result != null && context.mounted) {
      ctx.read<AgendaDetailBloc>().add(
        AgendaDetailEvent.optimisticUpdateComment(
          commentCountDelta: result.commentCountDelta,
          lastestCommentContent: result.commentWrittenContent,
        ),
      );
      setState(() {
        _commentCount = _commentCount + result.commentCountDelta;
        _latestComment = result.commentWrittenContent ?? _latestComment;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '댓글',
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$_commentCount개',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _handleNavigateToCommentPage(context),
            borderRadius: BorderRadius.circular(12),
            child: Ink(
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHighest.withAlpha(
                  70,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.colorScheme.outlineVariant),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.mode_comment_outlined,
                          size: 18,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _latestComment ?? '아직 댓글이 없어요. 첫 댓글을 남겨보세요.',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
