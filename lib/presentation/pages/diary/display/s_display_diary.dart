part of 'p_display_diary.dart';

class _Screen extends StatefulWidget {
  const _Screen({super.key});

  @override
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  static const _paginationThreshold = 200.0;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      debugPrint('scroll controller can not find its client');
      return;
    } else if (context.read<DisplayDiaryBloc>().state.isEnd ||
        context.read<DisplayDiaryBloc>().state.status !=
            DisplayStatus.paginated) {
      debugPrint('scroll request dropped');

      return;
    }
    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0 ||
        position.pixels < position.maxScrollExtent - _paginationThreshold) {
      debugPrint('scroll request dropped');
      return;
    }

    context.read<DisplayDiaryBloc>().add(
      DisplayEvent<DiaryEntity, FetchDiaryParam>.nextPageRequested(),
    );
  }

  Future<void> _handleRefresh() async {
    context.read<DisplayDiaryBloc>().add(
      DisplayEvent<DiaryEntity, FetchDiaryParam>.refreshed(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
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
              'My Diary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.router.push(const SearchDiaryRoute()),
            icon: Icon(Icons.search_rounded, color: colorScheme.onPrimary),
          ),
          IconButton(
            onPressed: () => context.router.push(const SettingsRoute()),
            icon: Icon(Icons.settings_rounded, color: colorScheme.onPrimary),
          ),
          IconButton(
            onPressed: () {
              context.router.push(CreateDiaryRoute());
            },
            icon: Icon(Icons.edit_note_rounded, color: colorScheme.onPrimary),
          ),
        ],
      ),
      body: Container(
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
        child: SafeArea(
          child:
              BlocBuilder<
                DisplayDiaryBloc,
                DisplayState<DiaryEntity, DateTime>
              >(
                builder: (context, state) {
                  if (state.status == DisplayStatus.initial ||
                      state.status == DisplayStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return RefreshIndicator(
                    color: colorScheme.onPrimary,
                    backgroundColor: colorScheme.primary,
                    onRefresh: _handleRefresh,
                    child: state.items.isEmpty
                        ? const _EmptyState()
                        : _DiariesList(
                            controller: _scrollController,
                            diaries: state.items,
                          ),
                  );
                },
              ),
        ),
      ),
    );
  }
}
