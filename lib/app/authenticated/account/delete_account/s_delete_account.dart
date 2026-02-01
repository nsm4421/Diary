part of 'p_delete_account.dart';

class _Screen extends StatefulWidget {
  const _Screen({super.key});

  @override
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  static const String _confirmKeyword = '탈퇴';

  late final TextEditingController _confirmController;

  bool _acknowledgeDelete = false;
  bool _acknowledgeIrreversible = false;

  @override
  void initState() {
    super.initState();
    _confirmController = TextEditingController();
  }

  OutlineInputBorder _outlineBorder(BuildContext context, Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  InputDecoration _confirmDecoration(BuildContext context) {
    final colorScheme = context.colorScheme;
    final text = _confirmController.text.trim();
    final errorText = text.isEmpty || text == _confirmKeyword
        ? null
        : '문구가 일치하지 않아요.';

    return InputDecoration(
      labelText: '확인 문구',
      hintText: '"$_confirmKeyword"를 입력해주세요',
      helperText: '정확히 입력하면 버튼이 활성화돼요.',
      errorText: errorText,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: _outlineBorder(context, colorScheme.outlineVariant),
      enabledBorder: _outlineBorder(context, colorScheme.outlineVariant),
      focusedBorder: _outlineBorder(context, colorScheme.outline),
      errorBorder: _outlineBorder(context, colorScheme.error),
      focusedErrorBorder: _outlineBorder(context, colorScheme.error),
    );
  }

  bool get _canSubmit {
    final confirmText = _confirmController.text.trim();
    return _acknowledgeDelete &&
        _acknowledgeIrreversible &&
        confirmText == _confirmKeyword;
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();

    final shouldProceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('마지막 확인'),
        content: const Text('탈퇴를 진행하면 모든 기록이 삭제되고 복구할 수 없어요. 계속할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('탈퇴하기'),
          ),
        ],
      ),
    );

    if (!context.mounted || shouldProceed != true) return;
    ToastUtil.warning('회원 탈퇴 기능은 아직 준비 중이에요.');
  }

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('회원 탈퇴')),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          children: [
            const _WarningCard(),
            const SizedBox(height: 24),
            const _SectionTitle(
              title: '삭제되는 항목',
              subtitle: '탈퇴 즉시 아래 데이터가 영구 삭제됩니다.',
            ),
            RoundCard(
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.auto_stories_outlined,
                    title: '작성한 기록과 콘텐츠',
                    subtitle: '일기, 안건, 댓글 등 모든 활동 내역',
                  ),
                  Divider(height: 1, color: colorScheme.outlineVariant),
                  _InfoRow(
                    icon: Icons.image_outlined,
                    title: '업로드한 이미지와 첨부파일',
                    subtitle: '프로필 사진과 게시물 첨부 이미지',
                  ),
                  Divider(height: 1, color: colorScheme.outlineVariant),
                  _InfoRow(
                    icon: Icons.person_outline,
                    title: '프로필 및 계정 정보',
                    subtitle: '닉네임, 소개글, 연결된 계정 정보',
                  ),
                  Divider(height: 1, color: colorScheme.outlineVariant),
                  _InfoRow(
                    icon: Icons.settings_outlined,
                    title: '앱 내 설정',
                    subtitle: '테마, 알림 등 개인화 설정',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const _SectionTitle(
              title: '탈퇴 전 확인',
              subtitle: '아래 항목을 확인해야 탈퇴 버튼이 활성화돼요.',
            ),
            RoundCard(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CheckTile(
                      value: _acknowledgeDelete,
                      onChanged: (value) => setState(() {
                        _acknowledgeDelete = value ?? false;
                      }),
                      title: '작성한 기록과 콘텐츠가 모두 삭제되는 것을 확인했어요.',
                    ),
                    Divider(height: 1, color: colorScheme.outlineVariant),
                    _CheckTile(
                      value: _acknowledgeIrreversible,
                      onChanged: (value) => setState(() {
                        _acknowledgeIrreversible = value ?? false;
                      }),
                      title: '탈퇴 후에는 계정을 복구할 수 없음을 이해했어요.',
                    ),
                    const SizedBox(height: 16),
                    Text.rich(
                      TextSpan(
                        text: '확인을 위해 ',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        children: [
                          TextSpan(
                            text: '"$_confirmKeyword"',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(text: '를 입력해주세요.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmController,
                      textInputAction: TextInputAction.done,
                      maxLength: 6,
                      decoration: _confirmDecoration(context),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: FilledButton(
                onPressed: _canSubmit ? _handleSubmit : null,
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                  textStyle: textTheme.labelLarge,
                ),
                child: const Text('탈퇴하기'),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '탈퇴는 즉시 처리되며 이후에는 데이터를 복구할 수 없어요.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
