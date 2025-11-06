part of 'p_settings.dart';

class _DarkModeSwitch extends StatelessWidget {
  const _DarkModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingCubit, AppSettingState>(
      builder: (context, state) {
        return _SettingTile(
          icon: Icons.dark_mode_rounded,
          title: '다크 모드',
          subtitle: '앱 전체를 어두운 테마로 전환해요.',
          trailing: Switch(
            value: state.isDarkMode,

            onChanged: state.isReady
                ? (value) async {
                    await context.read<AppSettingCubit>().updateDarkMode(value);
                  }
                : null,
          ),
        );
      },
    );
  }
}
