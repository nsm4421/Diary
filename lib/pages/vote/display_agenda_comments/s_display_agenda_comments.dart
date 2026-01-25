part of 'p_display_agenda_comment.dart';

class _Screen extends StatelessWidget {
  const _Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('댓글')),
      body: _CommentList(),
      bottomNavigationBar: _ShowCommentEditorButton(),
    );
  }
}
