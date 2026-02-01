part of 'p_display_agenda_comment.dart';

class _ShowCommentEditorButton extends StatelessWidget {
  const _ShowCommentEditorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: TextFormField(
          onTap: () async {
            // 인증여부 검사
            final isAuth = await context
                .read<AuthenticationBloc>()
                .resolveIsAuth();
            if (!isAuth || !context.mounted) return;

            final profile = context
                .read<AuthenticationBloc>()
                .state
                .currentUser
                ?.toProfile();
            if (profile == null) return;
            final created = await showModalBottomSheet<AgendaCommentModel>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              barrierColor: Colors.black.withAlpha(30),
              builder: (_) => BlocProvider(
                create: (_) {
                  final displayBloc = context.read<DisplayAgendaCommentBloc>();
                  final CreateAgendaCommentParam params = (
                    agendaId: displayBloc.agendaId,
                    parentCommentId: displayBloc.parentCommentId,
                    profile: profile,
                  );
                  return GetIt.instance<CreateAgendaCommentCubit>(
                    param1: params,
                  );
                },
                child: const _CommentEditor(),
              ),
            );
            if (created == null || !context.mounted) return;
            context.read<DisplayAgendaCommentBloc>().add(
              DisplayAgendaCommentEvent.append(created),
            );
          },
          readOnly: true,
          enableInteractiveSelection: false,
          decoration: InputDecoration(
            hintText: '댓글을 작성하세요',
            prefixIcon: const Icon(Icons.mode_comment_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
          ),
        ),
      ),
    );
  }
}
