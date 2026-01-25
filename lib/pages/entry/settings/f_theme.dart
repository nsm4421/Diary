part of 'p_setting_entry.dart';

class _ThemeCard extends StatelessWidget {
  const _ThemeCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(title: '디스플레이', subtitle: '테마를 선택할 수 있어요'),
        BlocBuilder<ThemeModeCubit, ThemeMode>(
          builder: (context, themeMode) {
            final isDark = themeMode == ThemeMode.dark;
            return RoundCard(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: Icon(
                  isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                ),
                title: const Text('테마'),
                subtitle: Text(isDark ? '다크 모드 사용 중' : '라이트 모드 사용 중'),
                trailing: Switch(
                  value: isDark,
                  onChanged: (isDark) {
                    final nextThemeMode = isDark
                        ? ThemeMode.dark
                        : ThemeMode.light;
                    context.read<ThemeModeCubit>().setThemeMode(nextThemeMode);
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
