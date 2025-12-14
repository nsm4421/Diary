part of 'sign_up_page.dart';

class _SignUpFormFragment extends StatefulWidget {
  const _SignUpFormFragment({super.key});

  @override
  State<_SignUpFormFragment> createState() => _SignUpFormFragmentState();
}

class _SignUpFormFragmentState extends State<_SignUpFormFragment>
    with ClientValidatorMixIn {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;
  late final TextEditingController _displayNameController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>(debugLabel: 'SIGN_UP_FORM');
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
    _displayNameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  SignUpCubit get _signUpCubit => context.read<SignUpCubit>();

  void _handleTogglePasswordVisibility() {
    _signUpCubit.updateState(
      isPasswordObscure: !_signUpCubit.state.isPasswordObscure,
    );
  }

  void _handleTogglePasswordConfirmVisibility() {
    _signUpCubit.updateState(
      isPasswordConfirmObscure: !_signUpCubit.state.isPasswordConfirmObscure,
    );
  }

  String? _handleValidatePasswordConfirm(String? value) {
    if (value == null || value.isEmpty) {
      return ' Confirm is required';
    }
    if (_passwordController.text.trim() !=
        _passwordConfirmController.text.trim()) {
      return 'Password is not matched';
    }
    return null;
  }

  void _handleSubmit() {
    FocusScope.of(context).unfocus();

    // validate
    _formKey.currentState?.save();
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    // update state
    _signUpCubit
      ..updateState(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        passwordConfirm: _passwordConfirmController.text.trim(),
        displayName: _displayNameController.text.trim(),
      )
      ..submit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Card(
            elevation: 0,
            color: context.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: context.colorScheme.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Email Sign Up',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _displayNameController,
                    enabled: !_signUpCubit.state.isLoading,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Display name',
                      hintText: 'Alex Writer',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: validateDisplayName,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _emailController,
                    enabled: !_signUpCubit.state.isLoading,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'name@email.com',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: validateEmail,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _passwordController,
                    enabled: !_signUpCubit.state.isLoading,
                    obscureText: _signUpCubit.state.isPasswordObscure,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      helperText: 'At least 6 characters.',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        onPressed: _handleTogglePasswordVisibility,
                        icon: Icon(
                          _signUpCubit.state.isPasswordObscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: validatePassword,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _passwordConfirmController,
                    enabled: !_signUpCubit.state.isLoading,
                    obscureText: _signUpCubit.state.isPasswordConfirmObscure,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      helperText: 'At least 6 characters.',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        onPressed: _handleTogglePasswordConfirmVisibility,
                        icon: Icon(
                          _signUpCubit.state.isPasswordConfirmObscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: _handleValidatePasswordConfirm,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _signUpCubit.state.isLoading
                          ? null
                          : _handleSubmit,
                      child: _signUpCubit.state.isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  context.colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : const Text('Create Account'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
