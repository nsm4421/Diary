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
      appBar: AppBar(title: Text(widget._diary.createdAt.toLocal().yyyymmdd)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget._diary.medias.isNotEmpty) ...[
                _MediaCarousel(
                  medias: widget._diary.medias,
                  controller: _pageController,
                  currentPage: _currentPage,
                  onPageChanged: _handlePageChanged,
                  onDotTapped: _animateTo,
                ),
                const SizedBox(height: 24),
              ],
              if (widget._diary.title?.trim().isNotEmpty == true) ...[
                Text(
                  widget._diary.title?.trim() ?? '일기',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              const SizedBox(height: 16),
              Text(
                widget._diary.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
