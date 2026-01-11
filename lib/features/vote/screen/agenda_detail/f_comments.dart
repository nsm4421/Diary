part of 'p_agenda_detail.dart';

class _Comments extends StatelessWidget {
  const _Comments();

  @override
  Widget build(BuildContext context) {
    const comments = [
      _CommentData("Alex", "2h", "Looks good to me."),
      _CommentData("Jamie", "1h", "I like option two."),
      _CommentData("Morgan", "10m", "Can we add another choice?"),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Comments (${comments.length})",
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.colorScheme.outlineVariant.withAlpha(120),
            ),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.primary.withAlpha(10),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: comments.asMap().entries.map((entry) {
              final comment = entry.value;
              final isLast = entry.key == comments.length - 1;
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceContainerHighest
                              .withAlpha(160),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.colorScheme.outlineVariant.withAlpha(
                              120,
                            ),
                          ),
                        ),
                        child: Text(
                          comment.initial,
                          style: context.textTheme.labelMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  comment.name,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  comment.time,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color:
                                        context.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              comment.message,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!isLast) ...[
                    const SizedBox(height: 12),
                    Divider(
                      height: 1,
                      color: context.colorScheme.outlineVariant.withAlpha(100),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _CommentData {
  const _CommentData(this.name, this.time, this.message);

  final String name;
  final String time;
  final String message;

  String get initial => name.isNotEmpty ? name[0].toUpperCase() : "?";
}
