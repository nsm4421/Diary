part of 'p_agenda_detail.dart';

class _Agenda extends StatelessWidget {
  const _Agenda(this._agenda);

  final AgendaModel _agenda;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withAlpha(120),
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withAlpha(16),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _agenda.title,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _agenda.options.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 16,
                    color: context.colorScheme.outlineVariant.withAlpha(120),
                  ),
                  itemBuilder: (context, index) {
                    final option = _agenda.options[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                            Text(
                              "${index + 1}",
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onSurfaceVariant
                                    .withAlpha(140),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                option.content,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: context.colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
