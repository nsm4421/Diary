part of 'p_splash.dart';

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Logo(),
        const SizedBox(height: 20),
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Text(
              '익명 투표',
              style: context.textTheme.labelLarge?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '애매할 땐 투표',
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          '혼자 고민될 때\n사람들의 의견으로 결정하세요',
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
