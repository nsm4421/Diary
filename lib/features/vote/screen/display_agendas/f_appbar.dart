part of 's_display_agendas.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("DISPLAY AGENDAS"),
      actions: [
        IconButton(
          onPressed: () async => await context.router.push(CreateAgendaRoute()),
          icon: Icon(Icons.add_circle_outline),
          tooltip: 'CREATE',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
