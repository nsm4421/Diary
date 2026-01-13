part of 'page.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(focusNode: _emailFocus, controller: _emailController),
        TextFormField(
          focusNode: _passwordFocus,
          controller: _passwordController,
        ),
      ],
    );
  }
}
