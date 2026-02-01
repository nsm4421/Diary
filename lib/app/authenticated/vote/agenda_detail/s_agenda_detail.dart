part of 'p_agenda_detail.dart';

class _AgendaDetailScreen extends StatelessWidget {
  const _AgendaDetailScreen(this._agenda, {super.key});

  final AgendaDetailModel _agenda;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.colorScheme.outlineVariant),
                ),
                child: _AgendaOverview(_agenda),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.colorScheme.outlineVariant),
                ),
                child: _ChoiceSection(),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.colorScheme.outlineVariant),
                ),
                child: _CommentSection(_agenda),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
