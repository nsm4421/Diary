part of 'p_edit_profile.dart';

class _EditUsername extends StatefulWidget {
  const _EditUsername({
    super.key,
    required this.initialUsername,
  });

  final String initialUsername;

  @override
  State<_EditUsername> createState() => _EditUsernameState();
}

class _EditUsernameState extends State<_EditUsername> {
  late final TextEditingController _controller;
  late final String _initialUsername;

  OutlineInputBorder _outlineBorder(BuildContext context, Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  InputDecoration _decoration(BuildContext context) {
    final colorScheme = context.colorScheme;

    return InputDecoration(
      labelText: '유저명',
      hintText: '공개 프로필에 표시될 이름',
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: _outlineBorder(context, colorScheme.outlineVariant),
      enabledBorder: _outlineBorder(context, colorScheme.outlineVariant),
      focusedBorder: _outlineBorder(context, colorScheme.outline),
    );
  }

  @override
  void initState() {
    super.initState();
    _initialUsername = widget.initialUsername;
    _controller = TextEditingController()..text = _initialUsername;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '유저명',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        RoundCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '앱에서 표시될 이름이에요.',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _controller,
                  textInputAction: TextInputAction.done,
                  maxLength: 20,
                  decoration: _decoration(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
