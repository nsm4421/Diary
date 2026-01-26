part of 'p_display_agenda_comment.dart';

class _CommentList extends StatelessWidget {
  const _CommentList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayAgendaCommentBloc, DisplayAgendaCommentState>(
      builder: (context, state) {
        return ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
          itemCount: state.items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final comment = state.items[index];
            return _CommentItem(comment);
          },
        );
      },
    );
  }
}

class _CommentItem extends StatelessWidget {
  const _CommentItem(this._comment, {super.key});

  final AgendaCommentModel _comment;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CommentAvatar(_comment),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _comment.author.username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _comment.createdAt.yyyymmddHHMM,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _ExpandableText(
                    _comment.content,
                    maxLines: 3,
                    style: context.textTheme.bodyMedium?.copyWith(
                      height: 1.45,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentAvatar extends StatelessWidget {
  const _CommentAvatar(this._comment, {super.key});

  final AgendaCommentModel _comment;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = _comment.author.avatarUrl?.trim();
    final username = _comment.author.username.trim();
    final fallback = username.isNotEmpty ? username.substring(0, 1) : '?';
    final baseColor = context.colorScheme.primary;

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: context.colorScheme.surfaceContainerHighest.withAlpha(
          90,
        ),
        backgroundImage: NetworkImage(avatarUrl),
      );
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: baseColor.withAlpha(18),
      child: Text(
        fallback,
        style: context.textTheme.titleSmall?.copyWith(
          color: baseColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ExpandableText extends StatefulWidget {
  const _ExpandableText(
    this.text, {
    super.key,
    this.style,
    this.maxLines = 3,
  });

  final String text;
  final TextStyle? style;
  final int maxLines;

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final trimmed = widget.text.trim();
    if (trimmed.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final textStyle = widget.style ?? context.textTheme.bodyMedium;
        final textSpan = TextSpan(text: trimmed, style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: widget.maxLines,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = textPainter.didExceedMaxLines;
        final content = Text(
          trimmed,
          style: textStyle,
          maxLines: _expanded ? null : widget.maxLines,
          overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
        );

        if (!isOverflowing) {
          return content;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            content,
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                _expanded ? 'Less' : 'More',
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
