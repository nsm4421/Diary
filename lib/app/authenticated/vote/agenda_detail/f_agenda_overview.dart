part of 'p_agenda_detail.dart';

class _AgendaOverview extends StatelessWidget {
  const _AgendaOverview(this._agenda, {super.key});

  final AgendaDetailModel _agenda;

  @override
  Widget build(BuildContext context) {
    final description = _agenda.description?.trim() ?? '';
    final username = _agenda.authorUsername.trim();
    final fallback = username.isNotEmpty ? username.substring(0, 1) : '?';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _agenda.title,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ProfileAvatar(
              avatarUrl: _agenda.authorAvatarUrl,
              fallback: fallback,
              radius: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _agenda.authorUsername,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _agenda.createdAt.yyyymmdd,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (description.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            description,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
        const SizedBox(height: 12),
        AgendaReactionButtons(),
      ],
    );
  }
}
