part of 'p_setting_entry.dart';

class _AccountCard extends StatelessWidget {
  const _AccountCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(title: '계정', subtitle: '보안 및 계정 관리'),
        RoundCard(
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: Icon(Icons.logout),
                title: const Text('로그아웃'),
                enabled: true,
                onTap: () {
                  context.read<AuthenticationBloc>().add(
                    AuthenticationEvent.signOut(),
                  );
                },
              ),
              Divider(height: 1, color: context.colorScheme.outlineVariant),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: Icon(
                  Icons.person_remove_outlined,
                  color: context.colorScheme.error,
                ),
                title: Text(
                  '회원 탈퇴',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.error,
                  ),
                ),
                subtitle: Text(
                  '모든 데이터가 삭제됩니다',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                onTap: () {
                  // 회원탈퇴 페이지로 라우팅
                  context.router.push(DeleteAccountRoute());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
