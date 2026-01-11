part of 'p_create_agenda.dart';

class _Screen extends StatelessWidget {
  const _Screen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: _AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: _Form(),
              ),
            ),
            _SubmitButton(),
          ],
        ),
      ),
    );
  }
}
