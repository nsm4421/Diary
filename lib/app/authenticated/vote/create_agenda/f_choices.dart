part of 'p_create_agenda.dart';

class _ChoiceEditor extends StatefulWidget {
  const _ChoiceEditor({super.key});

  @override
  State<_ChoiceEditor> createState() => _ChoiceEditorState();
}

class _ChoiceEditorState extends State<_ChoiceEditor> {
  late final TextEditingController _controller;
  late final CreateAgendaCubit _cubit;
  late List<String> _choices;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _cubit = context.read<CreateAgendaCubit>();
    _choices = [..._cubit.state.choices];
  }

  void _handleAddChoice() {
    if (_choices.length >= kMaxChoiceCount) return;

    final value = _controller.text.trim();
    if (value.isEmpty) {
      setState(() {
        _errorText = '텍스트를 입력해주세요';
      });
      return;
    } else if (_choices.contains(value)) {
      setState(() {
        _errorText = '중복된 선택지 입니다';
      });
      return;
    }

    setState(() {
      _errorText = null;
      _choices.add(value);
      _controller.clear();
    });
    _cubit.updateChoices(_choices);
  }

  Function() _deleteChoice(int index) => () {
    setState(() {
      _choices.removeAt(index);
    });
    _cubit.updateChoices(_choices);
  };

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              Icons.format_list_numbered,
              size: 18,
              color: context.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Text(
              '선택지',
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '최소 $kMinChoiceCount개, 최대 $kMaxChoiceCount개까지 추가할 수 있어요.',
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          textInputAction: TextInputAction.done,
          onChanged: (_) => setState(() {
            _errorText = null;
          }),
          decoration: InputDecoration(
            errorText: _errorText,
            labelText: '새 choice',
            hintText: '예: 찬성',
            suffixIcon: _choices.length < kMaxChoiceCount
                ? IconButton(
                    onPressed: _handleAddChoice,
                    icon: const Icon(Icons.add),
                    tooltip: 'Choice 추가',
                  )
                : null,
          ),
        ),
        const SizedBox(height: 12),
        if (_choices.isEmpty)
          Text(
            '아직 추가된 choice가 없어요.',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ...List.generate(_choices.length, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: context.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_choices[index], overflow: TextOverflow.clip),
                ),
                IconButton(
                  onPressed: _deleteChoice(index),
                  icon: const Icon(Icons.close),
                  tooltip: 'Choice 삭제',
                ),
              ],
            ),
          );
        }),
        if (_choices.length < kMinChoiceCount)
          Text(
            'choice를 $kMinChoiceCount개 이상 추가해 주세요.',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.error,
            ),
          ),
      ],
    );
  }
}
