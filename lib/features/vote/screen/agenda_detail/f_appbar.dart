part of 'p_agenda_detail.dart';

class _Appbar extends StatelessWidget implements PreferredSizeWidget {
  const _Appbar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: context.router.canPop()
          ? IconButton(
              onPressed: () => context.router.pop(),
              icon: const Icon(Icons.clear),
              tooltip: "Back",
            )
          : null,
      title: const Text("DETAIL"),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
