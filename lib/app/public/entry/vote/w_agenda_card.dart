part of 'p_vote_entry.dart';

class _AgendaCard extends StatelessWidget {
  final AgendaFeedModel _agenda;

  const _AgendaCard(this._agenda);

  @override
  Widget build(BuildContext context) {
    final description = _agenda.description ?? '';
    final latestComment = _agenda.latestComment;

    return GestureDetector(
      onTap: () async {
        // 인증여부 검사
        final isAuth = await context.read<AuthenticationBloc>().resolveIsAuth();
        if (!isAuth) {
          ToastUtil.warning('로그인후에 사용할 수 있어요');
          return;
        }
        // 상세페이지로 라우팅
        if (context.mounted) {
          await context.router.push(AgendaDetailRoute(agendaId: _agenda.id));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _agenda.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${_agenda.author.username} | ${_agenda.createdAt.yyyymmdd}',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            if (description.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                _ReactionStat(_agenda),
                const SizedBox(width: 10),
                _CommentStat(_agenda),
              ],
            ),
            if (latestComment != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest.withAlpha(
                    70,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '최신 댓글',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      latestComment.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
