part of 'p_setting_entry.dart';

class _OnAuthScreen extends StatelessWidget {
  const _OnAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _Appbar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate(const [
                Padding(
                  padding: EdgeInsets.only(bottom: 18),
                  child: _ProfileCard(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 18),
                  child: _ThemeCard(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 18),
                  child: _AccountCard(),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
