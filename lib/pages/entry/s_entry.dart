part of 'p_entry.dart';

class _Screen extends StatelessWidget {
  const _Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entry"),
        actions: [
          IconButton(
            onPressed: () {
              context.router.push(VoteRoute());
            },
            icon: Icon(Icons.how_to_vote),
          ),
          IconButton(
            onPressed: () {
              context.router.push(SignInRoute());
            },
            icon: Icon(Icons.login),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.logout)),
        ],
      ),
      body: _AgendaList(),
    );
  }
}
