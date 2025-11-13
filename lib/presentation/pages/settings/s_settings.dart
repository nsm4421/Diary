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
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final passwordState = context.watch<PasswordLockCubit>().state;
    final isPasswordBusy = passwordState.isLoading;

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
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        _DarkModeSwitch(),
                        _SettingTile(
                          icon: Icons.lock_outline_rounded,
                          title: '비밀번호 잠금',
                          subtitle: passwordState.isLocked
                              ? '앱 실행 시 비밀번호가 설정되어 있어요.'
                              : '앱 실행 시 비밀번호로 보호해요.',
                          trailing: IconButton(
                            onPressed: isPasswordBusy
                                ? null
                                : () async {
                                    await context.router.push(
                                      const PasswordSetupRoute(),
                                    );
                                  },
                            tooltip: '잠금설정',
                            icon: Icon(Icons.arrow_forward_outlined),
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
