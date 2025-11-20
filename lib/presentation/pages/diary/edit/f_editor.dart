part of 'p_edit_diary.dart';

class _Form extends StatefulWidget {
  const _Form(this._formKey, {super.key});

  final GlobalKey<FormState> _formKey;

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController()
      ..addListener(_handleChangeTitle)
      ..text = context.read<EditDiaryCubit>().state.title;
    _contentController = TextEditingController()
      ..addListener(_handleChangeContent)
      ..text = context.read<EditDiaryCubit>().state.content;
  }

  @override
  void dispose() {
    super.dispose();
    _titleController
      ..removeListener(_handleChangeTitle)
      ..dispose();
    _contentController
      ..removeListener(_handleChangeContent)
      ..dispose();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (value.trim().length > diaryEntryMaxTitleLength) {
      return '제목은 최대 $diaryEntryMaxTitleLength자까지 입력할 수 있어요.';
    }
    return null;
  }

  String? _validateContent(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return '일기 내용을 입력해주세요.';
    }
    if (text.length > diaryMaxContentLength) {
      return '일기 내용은 최대 $diaryMaxContentLength자까지 작성할 수 있어요.';
    }
    return null;
  }

  _handleChangeTitle() {
    context.read<EditDiaryCubit>().handleChange(
      title: _titleController.text.trim(),
    );
  }

  _handleChangeContent() {
    context.read<EditDiaryCubit>().handleChange(
      content: _contentController.text.trimRight(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: context.colorScheme.surface.withAlpha(242),
              border: Border.all(
                color: context.colorScheme.onSurface.withAlpha(13),
              ),
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.primary.withAlpha(41),
                  blurRadius: 26,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '제목 (선택)',
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.onSurfaceVariant.withAlpha(230),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: '오늘의 기분을 한 단어로 남겨볼까요?',
                    hintStyle: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurface.withAlpha(90),
                    ),
                    filled: true,
                    fillColor: context.colorScheme.surfaceContainerHighest
                        .withAlpha(77),
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(
                        color: context.colorScheme.primary.withAlpha(20),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(
                        color: context.colorScheme.primary.withAlpha(179),
                      ),
                    ),
                  ),
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                  textInputAction: TextInputAction.next,
                  maxLength: diaryEntryMaxTitleLength,
                  validator: _validateTitle,
                ),
                const SizedBox(height: 20),
                Text(
                  '내용',
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.onSurfaceVariant.withAlpha(230),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: '오늘 하루를 기록해보세요.',
                    hintStyle: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurface.withAlpha(90),
                    ),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: context.colorScheme.surfaceContainerHighest
                        .withAlpha(77),
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide(
                        color: context.colorScheme.primary.withAlpha(20),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide(
                        color: context.colorScheme.primary.withAlpha(179),
                      ),
                    ),
                  ),
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSurface.withAlpha(242),
                    height: 1.5,
                  ),
                  maxLines: null,
                  minLines: 10,
                  maxLength: diaryMaxContentLength,
                  keyboardType: TextInputType.multiline,
                  validator: _validateContent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
