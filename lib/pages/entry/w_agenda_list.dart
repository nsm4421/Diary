part of 'p_entry.dart';

class _AgendaList extends StatelessWidget {
  const _AgendaList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 50,
      itemBuilder: (context, index) {
        return ListTile(title: Text("TEST"));
      },
    );
  }
}
