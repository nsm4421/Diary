part of 'page.dart';

class _Screen extends StatelessWidget {
  const _Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("로그인")),
      body: _Form(),
      floatingActionButton: _SubmitButton(),
    );
  }
}
