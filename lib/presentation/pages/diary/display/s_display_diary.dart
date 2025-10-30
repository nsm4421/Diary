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
      DisplayEvent<DiaryEntry, FetchDiaryParam>.nextPageRequested(),
    );
  }

  Future<void> _handleRefresh() async {
    context.read<DisplayDiaryBloc>().add(
      DisplayEvent<DiaryEntry, FetchDiaryParam>.refreshed(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('일기 목록'),
        actions: [
          IconButton(
            onPressed: () {
              context.router.push(CreateDiaryRoute());
            },
            icon: const Icon(Icons.add_circle_outline_rounded),
          ),
        ],
      ),
      body: BlocBuilder<DisplayDiaryBloc, DisplayState<DiaryEntry, DateTime>>(
        builder: (context, state) {
          return (state.status == DisplayStatus.initial ||
                  state.status == DisplayStatus.loading)
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: state.items.isEmpty
                      ? Center(child: Text("작성된 일기가 없습니다"))
                      : _DiariesListFragment(
                          controller: _scrollController,
                          diaries: state.items,
                        ),
                );
        },
      ),
    );
  }
}
