part of 'p_diary_detail.dart';

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceVariant.withAlpha(120),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: context.colorScheme.onSurface.withAlpha(26)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: context.colorScheme.secondary.withAlpha(210),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurface.withAlpha(220),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
