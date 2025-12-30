part of 'p_splash.dart';

class _Screen extends StatelessWidget {
  const _Screen();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.surface,
              colorScheme.surface,
              colorScheme.primary.withAlpha(31),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final shortestSide = constraints.biggest.shortestSide;
              final logoSize = shortestSide * 0.3;
              final contentPadding = shortestSide * 0.08;

              return Stack(
                children: [
                  _GlowSpot(
                    alignment: const Alignment(-0.8, -0.9),
                    color: colorScheme.primary.withAlpha(46),
                    size: shortestSide * 0.75,
                  ),
                  _GlowSpot(
                    alignment: const Alignment(0.9, 0.8),
                    color: colorScheme.tertiary.withAlpha(36),
                    size: shortestSide * 0.9,
                  ),

                  /// 로고와 Title
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: contentPadding),
                      child: _Body(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
