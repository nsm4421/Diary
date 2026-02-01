part of 'p_setting_entry.dart';

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(title: '프로필', subtitle: '로그인한 계정 정보를 확인하세요'),

        BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            final authUser = state.currentUser;
            return authUser == null
                ? _ProfileCardOnUnAuth()
                : _ProfileCardOnAuth(authUser);
          },
        ),
      ],
    );
  }
}

class _ProfileCardOnUnAuth extends StatelessWidget {
  const _ProfileCardOnUnAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return RoundCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '로그인이 필요해요',
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '프로필을 표시하고 설정을 저장하려면 로그인하세요.',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                context.router.push(const AuthRoute());
              },
              child: const Text('로그인하기'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCardOnAuth extends StatelessWidget {
  const _ProfileCardOnAuth(this._authUser);

  final AuthUserModel _authUser;

  @override
  Widget build(BuildContext context) {
    final displayName = _authUser.username.trim().isEmpty
        ? '익명'
        : _authUser.username.trim();
    final initial = displayName.isNotEmpty ? displayName[0] : '?';

    return RoundCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ProfileAvatar(
                  avatarUrl: _authUser.avatarUrl,
                  fallback: initial,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _authUser.email,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (_authUser.createdAt != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '가입일 ${_authUser.createdAt!.yyyymmdd}',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: () async {
                final profile = await context.router.push<ProfileModel>(
                  const EditProfileRoute(),
                );
                if (profile == null || !context.mounted) return;
                context.read<AuthenticationBloc>().add(
                  AuthenticationEvent.profileUpdated(profile),
                );
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text('프로필 수정'),
            ),
          ],
        ),
      ),
    );
  }
}
