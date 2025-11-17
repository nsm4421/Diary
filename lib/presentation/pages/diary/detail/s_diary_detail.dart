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
    final diary = widget._diary;
    final title = diary.title?.trim();
    final hasTitle = title != null && title.isNotEmpty;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Row(
          children: [
            AppLogoHero(
              backgroundColor: context.colorScheme.onPrimary.withAlpha(31),
              borderColor: context.colorScheme.onPrimary.withAlpha(51),
              iconColor: context.colorScheme.onPrimary,
            ),
            const SizedBox(width: 12),
            Text(
              diary.createdAt.toLocal().yyyymmdd,
              style: context.textTheme.titleLarge?.copyWith(
                color: context.colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: context.colorScheme.onPrimary),
      ),
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
                  if (diary.medias.isNotEmpty) ...[
                    _MediaCarousel(
                      medias: diary.medias,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 10,
                              color: context.colorScheme.secondary.withAlpha(
                                204,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              diary.createdAt.toLocal().yyyymmdd,
                              style: context.textTheme.labelMedium?.copyWith(
                                color: context.colorScheme.onSurfaceVariant
                                    .withAlpha(191),
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                        if (hasTitle) ...[
                          const SizedBox(height: 16),
                          Text(
                            title!,
                            style: context.textTheme.headlineSmall?.copyWith(
                              color: context.colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        Text(
                          diary.content,
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: context.colorScheme.onSurface.withAlpha(242),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.edit_note_rounded,
                        color: context.colorScheme.onPrimary.withAlpha(179),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '당신의 하루가 소중한 이야기로 남았어요.',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onPrimary.withAlpha(191),
                          ),
                        ),
                      ),
                    ],
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
