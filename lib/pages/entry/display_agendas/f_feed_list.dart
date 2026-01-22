part of 'p_display_agendas.dart';

class _FeedList extends StatelessWidget {
  const _FeedList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayAgendasBloc, DisplayAgendasState>(
      builder: (context, state) {
        if (state.items.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                '조회된 리스트가 없습니다.',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }

        final hasMoreTrigger = !state.isEnd;

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index >= state.items.length) {
              if (state.canFetchMore && state.status.isSuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<DisplayAgendasBloc>().add(
                    DisplayAgendaEvent.fetch(),
                  );
                });
              }

              if (state.status.isLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AgendaCard(state.items[index]),
            );
          }, childCount: state.items.length + (hasMoreTrigger ? 1 : 0)),
        );
      },
    );
  }
}
