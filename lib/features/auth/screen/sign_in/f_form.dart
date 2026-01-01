part of 's_sign_in.dart';

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> with UserInfoValidatorMixIn {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final SignInCubit _signInCubit;
  bool _isPasswordObscure = true;

  @override
  void initState() {
    _signInCubit = context.read<SignInCubit>();
    super.initState();
    _emailController = TextEditingController()
      ..addListener(() {
        _signInCubit.updateState(email: _emailController.text.trim());
      });
    _passwordController = TextEditingController()
      ..addListener(() {
        _signInCubit.updateState(password: _passwordController.text.trim());
      });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signInCubit.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(controller: _emailController, validator: validateEmail),
          TextFormField(
            controller: _passwordController,
            maxLength: kMaxPasswordLength,
            validator: validatePassword,
            obscureText: _isPasswordObscure,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isPasswordObscure = !_isPasswordObscure;
                  });
                },
                icon: _isPasswordObscure
                    ? Icon(Icons.visibility)
                    : Icon(Icons.visibility_off),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
