part of 's_sign_up.dart';

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> with UserInfoValidatorMixIn {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _usernameController;
  late final SignUpCubit _signUpCubit;
  bool _isPasswordObscure = true;

  @override
  void initState() {
    _signUpCubit = context.read<SignUpCubit>();
    super.initState();
    _emailController = TextEditingController()
      ..addListener(() {
        _signUpCubit.updateState(email: _emailController.text.trim());
      });
    _passwordController = TextEditingController()
      ..addListener(() {
        _signUpCubit.updateState(password: _passwordController.text.trim());
      });
    _usernameController = TextEditingController()
      ..addListener(() {
        _signUpCubit.updateState(username: _usernameController.text.trim());
      });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    return Form(
      key: _signUpCubit.formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withAlpha(120),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withAlpha(24),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create your account",
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Use a valid email and a unique username.",
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      validator: validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration(
                        label: "Email",
                        hint: "karma@example.com",
                        icon: Icons.email_outlined,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _usernameController,
                      maxLength: kMaxUsernameLength,
                      validator: validateUsername,
                      decoration: _inputDecoration(
                        label: "Username",
                        hint: "your nickname",
                        icon: Icons.person_outline,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _passwordController,
                      maxLength: kMaxPasswordLength,
                      validator: validatePassword,
                      obscureText: _isPasswordObscure,
                      decoration: _inputDecoration(
                        label: "Password",
                        hint: "at least $kMinPasswordLength characters",
                        icon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordObscure = !_isPasswordObscure;
                            });
                          },
                          icon: _isPasswordObscure
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    final colorScheme = context.colorScheme;
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: colorScheme.surfaceVariant.withAlpha(120),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.error, width: 1.6),
      ),
    );
  }
}
