part of 'p_display_agendas.dart';

class _FeedHeader extends StatelessWidget {
  final int totalCount;

  const _FeedHeader({
    super.key,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '안건 피드',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                context.router.push(const CreateAgendaRoute());
              },
              icon: const Icon(Icons.add),
              tooltip: '안건 만들기',
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '총 $totalCount건의 안건이 공유되고 있어요.',
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
