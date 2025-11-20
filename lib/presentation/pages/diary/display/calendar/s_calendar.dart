part of 'p_calendar.dart';

class _Screen extends StatelessWidget {
  const _Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colorScheme.primary,
                  context.colorScheme.primaryContainer,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: 120,
            right: -40,
            child: Icon(
              Icons.auto_stories_outlined,
              size: 140,
              color: context.colorScheme.onPrimary.withAlpha(28),
            ),
          ),
          Positioned(
            bottom: 160,
            left: -28,
            child: Icon(
              Icons.calendar_today_rounded,
              size: 120,
              color: context.colorScheme.onPrimary.withAlpha(20),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        tooltip: '닫기',
                        style: IconButton.styleFrom(
                          backgroundColor: context.colorScheme.onPrimary
                              .withAlpha(32),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                        ),
                        icon: Icon(
                          Icons.close_rounded,
                          color: context.colorScheme.onPrimary,
                        ),
                        onPressed: () async {
                          await context.router.maybePop();
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '달력 보기',
                              style: context.textTheme.titleMedium?.copyWith(
                                color: context.colorScheme.onPrimary.withAlpha(
                                  230,
                                ),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                              ),
                            ),
                            Text(
                              '날짜별로 남겨둔 기록을 한눈에 확인해요.',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onPrimary.withAlpha(
                                  190,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: context.colorScheme.surface.withAlpha(245),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: context.colorScheme.primary.withAlpha(45),
                            blurRadius: 28,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const _Header(),
                          const SizedBox(height: 16),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: context.colorScheme.surfaceVariant
                                    .withAlpha(80),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                children: const [
                                  _CalendarGrid(),
                                  SizedBox(height: 12),
                                  Expanded(child: _Preview()),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
