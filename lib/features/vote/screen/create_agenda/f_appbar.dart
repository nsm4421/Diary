part of 'p_create_agenda.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.colorScheme.surface,
      surfaceTintColor: context.colorScheme.surface,
      elevation: 0,
      title: Text(
        "투표 만들기",
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
