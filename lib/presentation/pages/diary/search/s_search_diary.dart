part of 'p_search_diary.dart';

class _Screen extends StatefulWidget {
  const _Screen({super.key});

  @override
  State<_Screen> createState() => __ScreenState();
}

class __ScreenState extends State<_Screen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Row(
          children: [
            Hero(
              tag: 'diary-logo',
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.onPrimary.withAlpha(31),
                  border: Border.all(
                    color: colorScheme.onPrimary.withAlpha(51),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  color: colorScheme.onPrimary,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '일기 검색',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primaryContainer,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: 110,
            right: -36,
            child: Icon(
              Icons.search_rounded,
              size: 140,
              color: colorScheme.onPrimary.withAlpha(20),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SearchField(controller: _controller),
                  const SizedBox(height: 24),
                  Expanded(child: _SearchPlaceholder()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
