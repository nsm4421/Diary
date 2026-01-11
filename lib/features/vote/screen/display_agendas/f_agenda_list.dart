part of 's_display_agendas.dart';

class _AgendaList extends StatelessWidget {
  const _AgendaList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayAgendasBloc, DisplayState<AgendaModel>>(
      builder: (context, state) {
        if (state.items.isEmpty) {
          // 조회된 데이터가 없는 경우
          return SizedBox(
            height: 240,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 40,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '조회된 항목이 없어요',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: state.items.length,
          itemBuilder: (context, index) {
            final agenda = state.items[index];
            return GestureDetector(
              onTap: () async {
                if (context.mounted) {
                  // 상세페이지로 이동
                  context.router.push(AgendaDetailRoute(agendaId: agenda.id));
                }
              },
              child: _AgendaItem(agenda),
            );
          },
        );
      },
    );
  }
}
