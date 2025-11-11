part of 'p_search_diary.dart';

enum _SearchOption { content, dateRange }

class _Screen extends StatefulWidget {
  const _Screen({super.key});

  @override
  State<_Screen> createState() => __ScreenState();
}

class __ScreenState extends State<_Screen> {
  late final TextEditingController _controller;
  _SearchOption _mode = _SearchOption.content;
  DateTimeRange? _selectedRange;
  String _keyword = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_handleKeywordChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleKeywordChanged)
      ..dispose();
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
                  _SearchOptionCard(
                    value: _SearchOption.content,
                    groupValue: _mode,
                    icon: Icons.article_outlined,
                    title: '본문으로 검색',
                    subtitle: '제목이나 본문에 포함된 단어로 찾아요.',
                    onSelected: () => _onModeChanged(_SearchOption.content),
                    body: _ContentCriteriaBody(controller: _controller),
                  ),
                  const SizedBox(height: 12),
                  _SearchOptionCard(
                    value: _SearchOption.dateRange,
                    groupValue: _mode,
                    icon: Icons.calendar_today_outlined,
                    title: '날짜로 검색',
                    subtitle: '특정 기간 동안 작성된 일기를 찾아요.',
                    onSelected: () => _onModeChanged(_SearchOption.dateRange),
                    body: _DateCriteriaBody(
                      range: _selectedRange,
                      onPickRange: _pickDateRange,
                      onClearRange: _selectedRange == null
                          ? null
                          : _clearDateRange,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SearchActionBar(
                    canSearch: _canSearch,
                    onSearch: _performSearch,
                    onReset: _resetCriteria,
                    label: _searchButtonLabel,
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _SearchPlaceholder(
                      icon: _placeholderIcon,
                      title: _placeholderTitle,
                      message: _placeholderMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleKeywordChanged() {
    final nextKeyword = _controller.text.trim();
    if (nextKeyword == _keyword) return;
    setState(() => _keyword = nextKeyword);
  }

  void _onModeChanged(_SearchOption mode) {
    if (_mode == mode) return;
    setState(() => _mode = mode);
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final defaultRange = DateTimeRange(
      start: now.subtract(const Duration(days: 7)),
      end: now,
    );
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      initialDateRange: _selectedRange ?? defaultRange,
      helpText: '검색할 날짜 범위를 선택하세요',
      saveText: '적용',
      cancelText: '취소',
    );
    if (picked == null) return;
    setState(() => _selectedRange = picked);
  }

  void _clearDateRange() {
    setState(() => _selectedRange = null);
  }

  IconData get _placeholderIcon {
    if (_mode == _SearchOption.content) {
      return _keyword.isEmpty
          ? Icons.notes_outlined
          : Icons.manage_search_rounded;
    }
    return _selectedRange == null
        ? Icons.calendar_month_outlined
        : Icons.event_available_outlined;
  }

  String get _placeholderTitle {
    if (_mode == _SearchOption.content) {
      return _keyword.isEmpty ? '본문에서 검색할 단어를 입력하세요' : '"$_keyword" 검색 결과';
    }
    if (_selectedRange == null) {
      return '검색할 날짜 범위를 선택하세요';
    }
    return '${_selectedRange!.start.yyyymmdd}~${_selectedRange!.end.yyyymmdd} 검색 결과';
  }

  String get _placeholderMessage {
    if (_mode == _SearchOption.content) {
      return _keyword.isEmpty
          ? '제목이나 본문에 포함된 단어로 일기를 찾아보세요.'
          : '해당 단어가 포함된 일기가 여기에 표시돼요.';
    }
    if (_selectedRange == null) {
      return '기간을 선택하면 해당 날짜의 일기들이 표시됩니다.';
    }
    final days = _selectedRange!.duration.inDays + 1;
    return '$days일 동안 작성된 일기를 찾아서 보여드릴게요.';
  }

  bool get _canSearch {
    return switch (_mode) {
      _SearchOption.content => _keyword.isNotEmpty,
      _SearchOption.dateRange => _selectedRange != null,
    };
  }

  Future<void> _performSearch() async {
    if (!_canSearch) return;
    final summary = _mode == _SearchOption.content
        ? '본문 검색: "$_keyword"'
        : '날짜 검색: ${_selectedRange!.start.yyyymmdd}~${_selectedRange!.end.yyyymmdd}';
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _SearchedResult(
          criteriaSummary: summary,
          option: _mode,
          diaries: const [],
        ),
      ),
    );
  }

  void _resetCriteria() {
    setState(() {
      _mode = _SearchOption.content;
      _keyword = '';
      _controller.clear();
      _selectedRange = null;
    });
  }

  String get _searchButtonLabel =>
      _mode == _SearchOption.content ? '본문으로 검색하기' : '날짜로 검색하기';
}
