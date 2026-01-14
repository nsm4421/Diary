part of 'p_sign_in.dart';

class _Form extends StatefulWidget {
  const _Form({super.key});

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocus;
  late final FocusNode _passwordFocus;
  bool _isPasswordObscured = true;
  OutlineInputBorder _outlineBorder(BuildContext context, Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  InputDecoration _decoration({
    required BuildContext context,
    required String label,
    required String hint,
    Widget? suffixIcon,
  }) {
    final colorScheme = context.colorScheme;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      suffixIcon: suffixIcon,
      border: _outlineBorder(context, colorScheme.outlineVariant),
      enabledBorder: _outlineBorder(context, colorScheme.outlineVariant),
      focusedBorder: _outlineBorder(context, colorScheme.outline),
    );
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocus = FocusNode()..addListener(_handleEmailFocus);
    _passwordFocus = FocusNode()..addListener(_handlePasswordFocus);
  }

  _handleEmailFocus() {
    if (_emailFocus.hasFocus) return;
    context.read<SignInCubit>().updateEmail(_emailController.text);
  }

  _handlePasswordFocus() {
    if (_passwordFocus.hasFocus) return;
    context.read<SignInCubit>().updatePassword(_passwordController.text);
  }

  _handleTogglePasswordObscured() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus
      ..removeListener(_handleEmailFocus)
      ..dispose();
    _passwordFocus
      ..removeListener(_handlePasswordFocus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            focusNode: _emailFocus,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.none,
            autofillHints: const [AutofillHints.email],
            decoration: _decoration(
              context: context,
              label: "이메일",
              hint: "name@example.com",
            ),
            onFieldSubmitted: (_) {
              _passwordFocus.requestFocus();
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            focusNode: _passwordFocus,
            controller: _passwordController,
            textInputAction: TextInputAction.done,
            obscureText: _isPasswordObscured,
            enableSuggestions: false,
            autocorrect: false,
            autofillHints: const [AutofillHints.password],
            decoration: _decoration(
              context: context,
              label: "비밀번호",
              hint: "비밀번호를 입력하세요",
              suffixIcon: IconButton(
                onPressed: _handleTogglePasswordObscured,
                icon: Icon(
                  _isPasswordObscured
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                tooltip: _isPasswordObscured ? "비밀번호 보기" : "비밀번호 숨기기",
                visualDensity: VisualDensity.compact,
              ),
            ),
            onFieldSubmitted: (_) {
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
    );
  }
}
