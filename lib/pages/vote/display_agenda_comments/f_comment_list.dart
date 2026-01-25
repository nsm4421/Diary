part of 'p_display_agenda_comment.dart';

class _CommentList extends StatelessWidget {
  const _CommentList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayAgendaCommentBloc, DisplayAgendaCommentState>(
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: state.items.length,
          itemBuilder: (context, index) {
            final comment = state.items[index];
            return ListTile(
              title: Text(comment.content, overflow: TextOverflow.clip),
            );
          },
        );
      },
    );
  }
}
