part of 'p_settings.dart';

class _Screen extends StatefulWidget {
  const _Screen();

  @override
  State<_Screen> createState() => __ScreenState();
}

class __ScreenState extends State<_Screen> {
  bool _backupReminder = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final passwordState = context.watch<PasswordLockCubit>().state;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Row(
          children: [
            Hero(
              tag: 'diary-logo',
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.onPrimary.withAlpha(31),
                  border: Border.all(
                    color: colorScheme.onPrimary.withAlpha(51),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  color: colorScheme.onPrimary,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '설정',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primaryContainer,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: 120,
            right: -36,
            child: Icon(
              Icons.settings_rounded,
              size: 140,
              color: colorScheme.onPrimary.withAlpha(20),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Diary 환경설정',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary.withAlpha(230),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        _DarkModeSwitch(),
                        _SettingTile(
                          icon: Icons.lock_outline_rounded,
                          title: '비밀번호 잠금',
                          subtitle: passwordState.hasPassword
                              ? '앱 실행 시 비밀번호가 설정되어 있어요.'
                              : '앱 실행 시 비밀번호로 보호해요.',
                          trailing: FilledButton.tonal(
                            onPressed: passwordState.isBusy
                                ? null
                                : () async {
                                    await context.router.push(
                                      const PasswordSetupRoute(),
                                    );
                                  },
                            child: Text('설정하기'),
                          ),
                        ),

                        _SettingTile(
                          icon: Icons.cloud_upload_outlined,
                          title: '백업 알림',
                          subtitle: '주기적으로 다이어리를 백업하도록 안내받아요.',
                          trailing: Switch(
                            value: _backupReminder,
                            onChanged: (value) {
                              setState(() => _backupReminder = value);
                              // TODO: implement backup reminder scheduling
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        _GradientButton(
                          label: '데이터 내보내기',
                          icon: Icons.ios_share_rounded,
                          onPressed: () {
                            // TODO: implement export flow
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
