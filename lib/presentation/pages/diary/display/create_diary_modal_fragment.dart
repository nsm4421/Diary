part of 'display_diaries_page.dart';

class _CreateDiaryModalFragment extends StatefulWidget {
  const _CreateDiaryModalFragment({super.key});

  @override
  State<_CreateDiaryModalFragment> createState() =>
      _CreateDiaryModalFragmentState();
}

class _CreateDiaryModalFragmentState extends State<_CreateDiaryModalFragment> {
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _handleSave() {
    FocusScope.of(context).unfocus();
    final text = _titleController.text.trim();
    context.router.pop<String>(text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create Diary'),
      content: Form(
        child: TextField(
          controller: _titleController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Title',
            hintText: '(optional)',
            hintStyle: context.textTheme.labelMedium?.copyWith(
              color: context.colorScheme.tertiary,
            ),
          ),
          textInputAction: TextInputAction.done,
          maxLength: kMaxDiaryTitleLength,
        ),
      ),
      actions: [
        TextButton(
          onPressed: context.router.maybePop,
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _handleSave, child: const Text('Save')),
      ],
    );
  }
}
