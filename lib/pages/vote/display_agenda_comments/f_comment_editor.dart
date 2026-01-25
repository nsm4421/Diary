part of 'p_display_agenda_comment.dart';

class _CommentEditor extends StatefulWidget {
  const _CommentEditor({super.key});

  @override
  State<_CommentEditor> createState() => _CommentEditorState();
}

class _CommentEditorState extends State<_CommentEditor> {
  late final TextEditingController _controller;
  late final CreateAgendaCommentCubit _cubit;
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);
    _cubit = context.read<CreateAgendaCommentCubit>();
  }

  void _onTextChanged() {
    final canSubmit = _controller.text.trim().isNotEmpty;
    if (canSubmit == _canSubmit) return;
    setState(() {
      _canSubmit = canSubmit;
    });
  }

  void _handlePop() {
    context.router.pop();
  }

  void _handleSubmit() async {
    FocusScope.of(context).unfocus();
    final text = _controller.text.trim();
    await _cubit.submit(text);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTextChanged)
      ..dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateAgendaCommentCubit, CreateAgendaCommentState>(
      listenWhen: (prev, curr) => curr.isSuccess && curr.created != null,
      listener: (context, state) async {
        context.router.pop<AgendaCommentModel?>(state.created);
      },
      child: AnimatedPadding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        child: SafeArea(
          top: false,
          child: Material(
            color: context.colorScheme.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '댓글 작성',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _handlePop,
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    TextField(
                      controller: _controller,
                      autofocus: true,
                      minLines: 3,
                      maxLines: 6,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: '댓글을 작성하세요',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _canSubmit ? _handleSubmit : null,
                        child: const Text('등록'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
