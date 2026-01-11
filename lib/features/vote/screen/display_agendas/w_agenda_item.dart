part of 's_display_agendas.dart';

class _AgendaItem extends StatelessWidget {
  const _AgendaItem(this._agenda);

  final AgendaModel _agenda;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _agenda.title,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '작성시간 ${_agenda.createdAt.yyyymmddHHMM}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
