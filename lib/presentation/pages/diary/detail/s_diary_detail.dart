part of 'p_diary_detail.dart';

class _Screen extends StatefulWidget {
  const _Screen(this._diary, {super.key});

  final DiaryDetailEntity _diary;

  @override
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  late final PageController _pageController;
  late final ValueNotifier<int> _currentPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentPage = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  void _animateTo(int index) {
    if (!_pageController.hasClients) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  void _handlePageChanged(int index) {
    _currentPage.value = index;
  }

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
              color: context.colorScheme.onPrimary.withAlpha(20),
            ),
          ),
          Positioned(
            bottom: 140,
            left: -28,
            child: Icon(
              Icons.edit_note_outlined,
              size: 120,
              color: context.colorScheme.onPrimary.withAlpha(20),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          AppLogoHero(
                            backgroundColor: Colors.transparent,
                            borderColor: Colors.transparent,
                            iconColor: Colors.transparent,
                          ),
                          IconButton(
                            tooltip: '닫기',
                            style: IconButton.styleFrom(
                              backgroundColor: context.colorScheme.onPrimary
                                  .withAlpha(36),
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
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '오늘의 기록',
                              style: context.textTheme.labelLarge?.copyWith(
                                color: context.colorScheme.onPrimary.withAlpha(
                                  220,
                                ),
                                letterSpacing: 0.8,
                              ),
                            ),
                            Text(
                              '감정과 생각을 있는 그대로 담아보았어요.',
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
                  const SizedBox(height: 28),
                  if (widget._diary.medias.isNotEmpty) ...[
                    _MediaCarousel(
                      medias: widget._diary.medias,
                      controller: _pageController,
                      currentPage: _currentPage,
                      onPageChanged: _handlePageChanged,
                      onDotTapped: _animateTo,
                    ),
                    const SizedBox(height: 28),
                  ],
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: context.colorScheme.surface.withAlpha(245),
                      border: Border.all(
                        color: context.colorScheme.onSurface.withAlpha(15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: context.colorScheme.primary.withAlpha(41),
                          blurRadius: 28,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: _DiaryContent(widget._diary),
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
