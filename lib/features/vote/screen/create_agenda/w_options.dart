part of 'p_create_agenda.dart';

class _Options extends StatefulWidget {
  const _Options();

  @override
  State<_Options> createState() => _OptionsState();
}

class _OptionsState extends State<_Options> {
  static const int _maxOptionCount = 4;
  static const int _minOptionTextLength = 2;

  late final TextEditingController _controller;
  late final CreateAgendaBloc _bloc;
  late List<String> _options;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_handleChange);
    _bloc = context.read<CreateAgendaBloc>();
    _options = _bloc.state.data.options;
  }

  _handleChange() {
    _errorText = null;
  }

  _handleAddOption() {
    // 옵션개수 검사
    if (_options.length >= _maxOptionCount) return;

    // 텍스트 길이 검사
    final text = _controller.text.trim();
    if (text.length < _minOptionTextLength) {
      setState(() {
        _errorText = '최소 $_minOptionTextLength자 이상 입력해 주세요.';
      });
      return;
    }
    // 중복여부 검사
    final temp = [..._bloc.state.data.options, text];
    if (temp.length != temp.toSet().length) {
      setState(() {
        _errorText = '이미 추가된 항목이에요.';
      });
      return;
    }

    // update view
    setState(() {
      _options = temp;
      _errorText = null;
    });
    _controller.clear();

    // update bloc state
    _bloc.add(CreateEvent.update(_bloc.state.data.copyWith(options: _options)));
  }

  _handleRemoveOption(int index) => () {
    setState(() {
      _options.removeAt(index);
      _errorText = null;
    });
    _bloc.add(CreateEvent.update(_bloc.state.data.copyWith(options: _options)));
  };

  @override
  void dispose() {
    _controller
      ..removeListener(_handleChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMaxed = _options.length >= _maxOptionCount;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "선택지",
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              "${_options.length}/$_maxOptionCount",
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          enabled: !_bloc.state.isLoading,
          controller: _controller,
          decoration: InputDecoration(
            labelText: "항목 추가",
            hintText: "예: 찬성, 반대, 보류",
            helperText: '항목은 최소 $_minOptionTextLength자 이상 입력해 주세요.',
            helperStyle: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
            errorText: _errorText,
            suffixIcon: isMaxed
                ? null
                : IconButton(
                    onPressed: _handleAddOption,
                    icon: Icon(
                      Icons.add,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: context.colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: context.colorScheme.primary,
                width: 1.6,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        if (_options.isNotEmpty) ...[
          const SizedBox(height: 14),
          Column(
            children: _options.asMap().entries.map((entry) {
              final index = entry.key;
              final isLast = index == _options.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          "${index + 1}",
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant
                                .withAlpha(140),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _handleRemoveOption(entry.key),
                          icon: const Icon(Icons.close),
                          color: context.colorScheme.onSurfaceVariant.withAlpha(
                            150,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      color: context.colorScheme.outlineVariant.withAlpha(120),
                    ),
                ],
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
