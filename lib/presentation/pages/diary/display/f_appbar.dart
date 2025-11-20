part of 'p_display_diary.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 8,
      title: Row(
        children: [
          AppLogoHero(
            backgroundColor: context.colorScheme.onPrimary.withAlpha(31),
            borderColor: context.colorScheme.onPrimary.withAlpha(51),
            iconColor: context.colorScheme.onPrimary,
          ),
          const SizedBox(width: 12),
          Text(
            '나의 일기',
            style: context.textTheme.titleLarge?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () async {
            await context.router.push(CalendarRoute());
          },
          icon: Icon(Icons.calendar_month, color: colorScheme.onPrimary),
        ),
        IconButton(
          onPressed: () => context.router.push(const SearchDiaryRoute()),
          icon: Icon(Icons.search_rounded, color: colorScheme.onPrimary),
          tooltip: '일기 검색하기',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
