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
                onTap: () => _confirmDelete(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('회원 탈퇴'),
        content: const Text('정말로 탈퇴하시겠어요? 이 작업은 되돌릴 수 없어요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),

          /// TODO : 회원탈퇴 기능 구현하기
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('탈퇴하기'),
          ),
        ],
      ),
    );

    if (!context.mounted || shouldDelete != true) return;
    ToastUtil.warning('회원 탈퇴 기능은 아직 준비 중이에요.');
  }
}
