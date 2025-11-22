part of 'p_diary_detail.dart';

class _DiaryContent extends StatelessWidget {
  const _DiaryContent(this._diary, {super.key});

  final DiaryDetailEntity _diary;

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour < 12 ? '오전' : '오후';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$period ${hour12.toString().padLeft(2, '0')}:$minute';
  }

  String _weekdayLabel(DateTime dateTime) {
    const labels = ['월', '화', '수', '목', '금', '토', '일'];
    return labels[(dateTime.weekday - 1) % labels.length];
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = _diary.createdAt.yyyymmdd;
    final weekdayLabel = _weekdayLabel(_diary.createdAt);
    final hasTitle = _diary.title != null && _diary.title!.isNotEmpty;
    final hasUpdatedInfo =
        _diary.updatedAt.difference(_diary.createdAt).abs() >=
        const Duration(minutes: 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.circle,
              size: 8,
              color: context.colorScheme.secondary.withAlpha(220),
            ),
            const SizedBox(width: 10),
            Text(
              '$dateLabel ($weekdayLabel)',
              style: context.textTheme.labelMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant.withAlpha(191),
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _InfoPill(
              icon: Icons.schedule_rounded,
              label: _formatTime(_diary.createdAt),
            ),
            if (!_diary.mood.isNone)
              _InfoPill(
                icon: _diary.mood.meta.icons,
                label: _diary.mood.meta.label,
              ),
            if (hasUpdatedInfo)
              _InfoPill(
                icon: Icons.update_rounded,
                label: '수정 ${_diary.updatedAt.yyyymmdd}',
              ),
          ],
        ),
        if (hasTitle) ...[
          const SizedBox(height: 24),
          Text(
            _diary.title ?? '',
            style: context.textTheme.titleLarge?.copyWith(
              color: context.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
        const SizedBox(height: 20),
        const Divider(height: 24),
        Text(
          _diary.content,
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(242),
            height: 1.65,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
