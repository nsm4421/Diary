part of 'p_setting_entry.dart';

class _OnUnAuthScreen extends StatelessWidget {
  const _OnUnAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const _Appbar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate(const [
                _GuestIntroCard(),
                SizedBox(height: 18),
                _ThemeCard(),
                SizedBox(height: 18),
                _GuestNoticeCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuestIntroCard extends StatelessWidget {
  const _GuestIntroCard();

  @override
  Widget build(BuildContext context) {
    return RoundCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_open_outlined,
                    color: context.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '게스트 모드',
                        style: context.textTheme.labelMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '로그인하고 기록을 안전하게 보관하세요',
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '계정을 연결하면 기기 변경 시에도 기록이 유지돼요.',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: const [
                _GuestBenefitRow(
                  icon: Icons.cloud_done_outlined,
                  label: '자동 백업 및 동기화',
                ),
                SizedBox(height: 8),
                _GuestBenefitRow(
                  icon: Icons.history_toggle_off_outlined,
                  label: '작성 기록을 오래 보관',
                ),
                SizedBox(height: 8),
                _GuestBenefitRow(
                  icon: Icons.security_outlined,
                  label: '계정으로 안전하게 보호',
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.router.push(const AuthRoute()),
              child: const Text('로그인 / 회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestBenefitRow extends StatelessWidget {
  const _GuestBenefitRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: context.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _GuestNoticeCard extends StatelessWidget {
  const _GuestNoticeCard();

  @override
  Widget build(BuildContext context) {
    return RoundCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '로그인 없이 사용할 수 있는 기능',
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '지금은 테마 설정만 변경할 수 있어요. 로그인하면 '
              '프로필과 계정 관리 기능을 사용할 수 있습니다.',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
