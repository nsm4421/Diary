part of 'p_search_diary.dart';

class _SearchActionBar extends StatelessWidget {
  const _SearchActionBar({
    required this.canSearch,
    required this.onSearch,
    required this.onReset,
    required this.label,
  });

  final bool canSearch;
  final VoidCallback onSearch;
  final VoidCallback onReset;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: canSearch ? onSearch : null,
            icon: const Icon(Icons.search_rounded),
            label: Text(label),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _ActionIconButton(
          icon: Icons.refresh_rounded,
          tooltip: '조건 초기화',
          onPressed: onReset,
          background: colorScheme.surfaceVariant.withOpacity(0.6),
          foreground: colorScheme.primary,
          outlined: true,
          height: 56,
          width: 56,
          borderRadius: BorderRadius.circular(18),
        ),
      ],
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.background,
    required this.foreground,
    this.height = 48,
    this.width,
    this.elevated = false,
    this.outlined = false,
    this.borderRadius,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color background;
  final Color foreground;
  final double height;
  final double? width;
  final bool elevated;
  final bool outlined;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(18);
    final enabled = onPressed != null;
    final resolvedBackground = outlined
        ? Colors.transparent
        : (enabled ? background : background.withOpacity(0.4));
    final resolvedForeground = enabled
        ? foreground
        : foreground.withOpacity(0.5);
    final side = outlined
        ? BorderSide(color: background.withOpacity(enabled ? 0.8 : 0.4))
        : BorderSide.none;

    final child = SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: Center(child: Icon(icon, size: 26, color: resolvedForeground)),
    );

    return Tooltip(
      message: tooltip,
      child: Material(
        color: resolvedBackground,
        elevation: elevated && enabled ? 4 : 0,
        shape: RoundedRectangleBorder(borderRadius: radius, side: side),
        child: InkWell(borderRadius: radius, onTap: onPressed, child: child),
      ),
    );
  }
}
