part of 'p_search_diary.dart';

class _SearchTitle extends StatefulWidget {
  const _SearchTitle({super.key});

  @override
  State<_SearchTitle> createState() => _SearchTitleState();
}

class _SearchTitleState extends State<_SearchTitle> {
  late final TextEditingController _controller;
  late bool _isReady;

  @override
  void initState() {
    super.initState();
    final state = context.read<SearchDiaryCubit>().state;
    final initialText = state is FetchDiaryByTitleParamValue ? state.title : '';
    _controller = TextEditingController(text: initialText);
    _isReady = initialText.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClear() {
    if (_controller.text.isEmpty) return;
    _controller.clear();
    context.read<SearchDiaryCubit>().updateTitle('');
    setState(() {
      _isReady = false;
    });
  }

  void _handleChange(String text) {
    context.read<SearchDiaryCubit>().updateTitle(text);
    final ready = text.trim().isNotEmpty;
    if (_isReady != ready) {
      setState(() {
        _isReady = ready;
      });
    }
  }

  void _handleSearch() async {
    final param = context.read<SearchDiaryCubit>().state;
    if (!_isReady || param is! FetchDiaryByTitleParamValue) return;
    FocusScope.of(context).unfocus();
    await context.router.push(SearchedResultRoute(param: param));
  }

  @override
  Widget build(BuildContext context) {
    final helperStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
    return BlocListener<SearchDiaryCubit, FetchDiaryParam>(
      listenWhen: (previous, current) =>
          previous != current && current is FetchDiaryByTitleParamValue,
      listener: (context, state) {
        if (state is! FetchDiaryByTitleParamValue) return;
        if (state.title == _controller.text) return;
        _controller.value = TextEditingValue(
          text: state.title,
          selection: TextSelection.collapsed(offset: state.title.length),
        );
        final ready = state.title.trim().isNotEmpty;
        if (_isReady != ready) {
          setState(() {
            _isReady = ready;
          });
        }
      },
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '제목으로 검색',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text('찾고 싶은 일기의 제목이나 키워드를 입력해 주세요.', style: helperStyle),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: '예) 여행, 첫 출근, 오늘의 일기',
                  prefixIcon: const Icon(Icons.title_rounded),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          tooltip: '지우기',
                          icon: const Icon(Icons.close_rounded),
                          onPressed: _handleClear,
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.8,
                    ),
                  ),
                ),
                onChanged: _handleChange,
                onSubmitted: (_) => _handleSearch(),
              ),
              const SizedBox(height: 8),
              Text('띄어쓰기/대소문자를 구분하지 않고 제목 전체를 검색해요.', style: helperStyle),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _isReady ? _handleSearch : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                icon: const Icon(Icons.search_rounded),
                label: const Text('제목 검색'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
