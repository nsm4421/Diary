part of 'p_create_diary.dart';

class _Screen extends StatefulWidget {
  const _Screen({super.key});

  @override
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
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
              '새 일기 작성',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
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
              top: 90,
              right: -36,
              child: Icon(
                Icons.auto_stories_outlined,
                size: 140,
                color: colorScheme.onPrimary.withAlpha(20),
              ),
            ),
            Positioned(
              bottom: 120,
              left: -28,
              child: Icon(
                Icons.edit_note_outlined,
                size: 120,
                color: colorScheme.onPrimary.withAlpha(20),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '오늘의 마음을 기록해볼까요?',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary.withAlpha(230),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '감정과 순간을 솔직하게 남겨보세요.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary.withAlpha(179),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(child: _Form(_formKey)),
                    const SizedBox(height: 20),
                    _SubmitButton(_formKey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
