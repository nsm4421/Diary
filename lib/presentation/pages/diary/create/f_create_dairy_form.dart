part of 'p_create_diary.dart';

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
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (value.trim().length > kDiaryEntryMaxTitleLength) {
      return '제목은 최대 $kDiaryEntryMaxTitleLength자까지 입력할 수 있어요.';
    }
    return null;
  }

  String? _validateContent(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return '일기 내용을 입력해주세요.';
    }
    if (text.length > kDiaryEntryMaxContentLength) {
      return '일기 내용은 최대 $kDiaryEntryMaxContentLength자까지 작성할 수 있어요.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '제목 (선택)',
                hintText: '오늘의 기분을 한 단어로 남겨볼까요?',
              ),
              textInputAction: TextInputAction.next,
              maxLength: kDiaryEntryMaxTitleLength,
              validator: _validateTitle,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: '내용',
                hintText: '오늘 하루를 기록해보세요.',
                alignLabelWithHint: true,
              ),
              maxLines: null,
              minLines: 10,
              maxLength: kDiaryEntryMaxContentLength,
              keyboardType: TextInputType.multiline,
              validator: _validateContent,
            ),
          ],
        ),
      ),
    );
  }
}
