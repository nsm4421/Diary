part of 'display_diaries_page.dart';

class _DisplayDiariesScreen extends StatelessWidget {
  const _DisplayDiariesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              final title = await showDialog<String>(
                context: context,
                builder: (_) => const _CreateDiaryModalFragment(),
              );
              if (title == null || !context.mounted) return;
              context.read<CreateDiaryCubit>().submit(
                title.isEmpty ? null : title,
              );
            },
            icon: Icon(Icons.add_circle_outline),
            tooltip: 'CREATE',
          ),
        ],
        title: Text("Display Diaries"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [_DiariesListFragment()]),
        ),
      ),
    );
  }
}
