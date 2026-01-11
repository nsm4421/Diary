part of 'p_agenda_detail.dart';

class _FetchedScreen extends StatelessWidget {
  const _FetchedScreen(this._agenda);

  final AgendaModel _agenda;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _Appbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: _Agenda(_agenda),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _Comments(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
