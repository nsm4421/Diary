part of 'p_display_agenda_comment.dart';

class _Screen extends StatelessWidget {
  const _Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // 유저가 작성한 댓글과 수를 원래 화면으로 보냄
            final commentCountDelta = context
                .read<DisplayAgendaCommentBloc>()
                .commentCountDelta;
            final commentWrittenContent = context
                .read<DisplayAgendaCommentBloc>()
                .commentWrittenContent;
            context.router.pop<AgendaCommentPageResult>((
              commentCountDelta: commentCountDelta,
              commentWrittenContent: commentWrittenContent,
            ));
          },
          icon: Icon(Icons.clear),
        ),
        title: Text('댓글'),
      ),
      body: _CommentList(),
      bottomNavigationBar: _ShowCommentEditorButton(),
    );
  }
}
