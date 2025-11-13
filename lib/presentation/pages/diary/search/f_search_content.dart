part of 'p_search_diary.dart';

class _SearchContent extends StatefulWidget {
  const _SearchContent({super.key});

  @override
  State<_SearchContent> createState() => _SearchContentState();
}

class _SearchContentState extends State<_SearchContent> {
  late final TextEditingController _controller;
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<SearchDiaryCubit>().state;
    final initialText = state is FetchDiaryByContentParamValue
        ? state.content
        : '';
    _controller = TextEditingController(text: initialText);
    _canSubmit = initialText.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitSearch() async {
    if (!_canSubmit) return;
    final param = context.read<SearchDiaryCubit>().state;
    if (param is! FetchDiaryByContentParamValue || param.content.isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    await context.router.push(SearchedResultRoute(param: param));
  }

  @override
  Widget build(BuildContext context) {
    final helperStyle = context.textTheme.bodySmall?.copyWith(
      color: context.colorScheme.onSurfaceVariant,
    );

    return BlocListener<SearchDiaryCubit, FetchDiaryParam>(
      listenWhen: (previous, current) =>
          previous != current && current is FetchDiaryByContentParamValue,
      listener: (context, state) {
        if (state is! FetchDiaryByContentParamValue) return;
        if (state.content == _controller.text) return;
        _controller.value = TextEditingValue(
          text: state.content,
          selection: TextSelection.collapsed(offset: state.content.length),
        );
        final canSubmit = state.content.trim().isNotEmpty;
        if (_canSubmit != canSubmit) {
          setState(() {
            _canSubmit = canSubmit;
          });
        }
      },
      child: Card(
        elevation: 0,
        color: context.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '본문으로 검색',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text('일기에 적힌 내용을 키워드로 찾을 수 있어요.', style: helperStyle),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                maxLines: 5,
                minLines: 3,
                decoration: InputDecoration(
                  hintText: '예) 오늘 본 노을, 점심 약속, 기억하고 싶은 순간',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: context.colorScheme.outlineVariant,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: context.colorScheme.primary,
                      width: 1.8,
                    ),
                  ),
                ),
                onChanged: (value) {
                  context.read<SearchDiaryCubit>().updateContent(value);
                  final canSubmit = value.trim().isNotEmpty;
                  if (_canSubmit != canSubmit) {
                    setState(() {
                      _canSubmit = canSubmit;
                    });
                  }
                },
                onSubmitted: (_) => _submitSearch(),
              ),
              const SizedBox(height: 8),
              Text('검색어는 공백을 기준으로 분리되어 부분 일치로 검색돼요.', style: helperStyle),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _canSubmit ? _submitSearch : null,
                icon: const Icon(Icons.notes_rounded),
                label: const Text('본문 검색'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
