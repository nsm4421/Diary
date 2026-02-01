part of 'p_vote_entry.dart';

class _NavigateToCreatePageButton extends StatelessWidget {
  const _NavigateToCreatePageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        // 인증여부 검사
        final currentUserProfile = context
            .read<AuthenticationBloc>()
            .state
            .currentUser
            ?.toProfile();

        // 인증되지 않은 경우
        if (currentUserProfile == null) {
          final shouldLogin = await AuthRequiredDialog.show(context);
          if (!context.mounted || !shouldLogin) return;
          await context.router.push(const AuthRoute());
          return;
        }

        // 인증된 경우
        final feed = await context.router
            .push<AgendaWithChoicesModel>(const CreateAgendaRoute())
            .then((created) => created?.toFeed(currentUserProfile));
        if (!context.mounted || feed == null) return;

        // 뷰 업데이트
        context.read<DisplayAgendasBloc>().add(DisplayAgendaEvent.append(feed));
      },
      icon: const Icon(Icons.add),
      tooltip: '투표 만들기',
    );
  }
}
