part of 'p_create_agenda.dart';

class _AgendaForm extends StatefulWidget {
  const _AgendaForm({super.key});

  @override
  State<_AgendaForm> createState() => _AgendaFormState();
}

class _AgendaFormState extends State<_AgendaForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final FocusNode _titleFocus;
  late final FocusNode _descriptionFocus;
  late final CreateAgendaCubit _cubit;
  bool _showDescription = false;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CreateAgendaCubit>();
    _titleController = TextEditingController()..text = _cubit.state.title;
    _descriptionController = TextEditingController()
      ..text = _cubit.state.description;
    _titleFocus = FocusNode()..addListener(_handleTitleFocus);
    _descriptionFocus = FocusNode()..addListener(_handleDescriptionFocus);
  }

  _handleTitleFocus() {
    if (_titleFocus.hasFocus) return;
    context.read<CreateAgendaCubit>().updateTitle(_titleController.text.trim());
  }

  _handleDescriptionFocus() {
    if (_descriptionFocus.hasFocus) return;
    _cubit.updateDescription(_descriptionController.text.trim());
  }

  _handleToggleShowDescription(bool value) {
    setState(() {
      _showDescription = value;
      if (!value) {
        _descriptionController.clear();
        _cubit.updateDescription('');
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _titleFocus
      ..removeListener(_handleTitleFocus)
      ..dispose();
    _descriptionFocus
      ..removeListener(_handleDescriptionFocus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// 제목
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.title,
                  size: 18,
                  color: context.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  '제목',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              focusNode: _titleFocus,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: '투표 제목 (필수)',
                hintText: '핵심을 한 줄로 요약해 주세요',
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
        const SizedBox(height: 12),

        /// 상세설명
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(
                '상세설명(선택)',
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              value: _showDescription,
              onChanged: _handleToggleShowDescription,
            ),
            AnimatedSize(
              duration: 200.durationInMilliSec,
              curve: Curves.easeOut,
              child: AnimatedSwitcher(
                duration: 200.durationInMilliSec,
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: _showDescription
                    ? TextField(
                        key: const ValueKey('description-field'),
                        focusNode: _descriptionFocus,
                        controller: _descriptionController,
                        minLines: 2,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: '자세한 설명을 적어주세요',
                        ),
                      )
                    : Padding(
                        key: const ValueKey('description-helper'),
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '설명 없이도 투표를 만들 수 있어요.',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
