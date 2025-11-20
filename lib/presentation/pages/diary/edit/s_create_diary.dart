part of 'p_edit_diary.dart';

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () async {
            await context.router.maybePop();
          },
          icon: Icon(Icons.clear),
        ),
        title: Row(
          children: [
            Text(
              switch (context.read<EditDiaryCubit>().mode) {
                EditDiaryMode.create => '새 일기 작성',
                EditDiaryMode.modify => '일기 수정',
              },
              style: context.textTheme.titleLarge?.copyWith(
                color: context.colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: context.colorScheme.onPrimary),
      ),

      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
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
              top: 90,
              right: -36,
              child: Icon(
                Icons.auto_stories_outlined,
                size: 140,
                color: context.colorScheme.onPrimary.withAlpha(20),
              ),
            ),
            Positioned(
              bottom: 120,
              left: -28,
              child: Icon(
                Icons.edit_note_outlined,
                size: 120,
                color: context.colorScheme.onPrimary.withAlpha(20),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '오늘의 마음을 기록해볼까요?',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.onPrimary.withAlpha(230),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '감정과 순간을 솔직하게 남겨보세요.',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onPrimary.withAlpha(179),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 32),

                        child: Column(
                          children: [
                            _Form(_formKey),
                            const SizedBox(height: 18),
                            const _SelectMedia(),
                          ],
                        ),
                      ),
                    ),
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
