part of 'p_edit_diary.dart';

class _AddMediaTile extends StatelessWidget {
  const _AddMediaTile({
    required this.remaining,
    required this.onTap,
    required this.accent,
    required this.textTheme,
  });

  final int remaining;
  final VoidCallback? onTap;
  final Color accent;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 104,
        height: 104,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: accent.withAlpha(102), width: 1.5),
          color: accent.withAlpha(20),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_photo_alternate_rounded, color: accent),
              const SizedBox(height: 6),
              Text(
                '추가',
                style: textTheme.labelMedium?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '남은 ${remaining}장',
                style: textTheme.labelSmall?.copyWith(
                  color: accent.withAlpha(179),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
