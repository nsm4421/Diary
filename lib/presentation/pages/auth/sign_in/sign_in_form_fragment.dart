part of 'sign_in_page.dart';

class _SignInFormFragment extends StatefulWidget {
  const _SignInFormFragment({super.key});

  @override
  State<_SignInFormFragment> createState() => _SignInFormFragmentState();
}

class _SignInFormFragmentState extends State<_SignInFormFragment>
    with ClientValidatorMixIn {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  SignInCubit get _signInCubit => context.read<SignInCubit>();

  void _handleTogglePasswordVisibility() {
    _signInCubit.updateState(
      isPasswordObscure: !_signInCubit.state.isPasswordObscure,
    );
  }

  void _handleSubmit() {
    FocusScope.of(context).unfocus();

    // validate
    _formKey.currentState?.save();
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    // update state
    _signInCubit
      ..updateState(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      )
      ..submit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
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
                    'Email Sign In',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _emailController,
                    enabled: !_signInCubit.state.isLoading,
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
                    enabled: !_signInCubit.state.isLoading,
                    obscureText: _signInCubit.state.isPasswordObscure,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      helperText: 'press your email',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        onPressed: _handleTogglePasswordVisibility,
                        icon: Icon(
                          _signInCubit.state.isPasswordObscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: (value) => validateIsNotEmpty(
                      value,
                      message: 'password is required',
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _signInCubit.state.isLoading
                          ? null
                          : _handleSubmit,
                      child: _signInCubit.state.isLoading
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
                          : const Text('Login'),
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
