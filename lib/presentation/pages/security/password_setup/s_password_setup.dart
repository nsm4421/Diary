part of 'p_password_setup.dart';

class _PasswordSetupView extends StatefulWidget {
  const _PasswordSetupView();

  @override
  State<_PasswordSetupView> createState() => _PasswordSetupViewState();
}

class _PasswordSetupViewState extends State<_PasswordSetupView> {
  bool _delayElapsed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _delayElapsed = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordSetupCubit, PasswordSetupState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state.isStatusSuccess) {
          final message = state.hasExistingPassword
              ? '비밀번호를 저장했어요.'
              : '비밀번호를 삭제했어요.';
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
          context.read<PasswordSetupCubit>().resetStatus();
        } else if (state.isStatusFailure && state.errorMessage.isNotEmpty) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        final showSkeleton = !_delayElapsed || state.isStatusIdle;
        final title = state.hasExistingPassword ? '비밀번호 관리' : '비밀번호 설정';

        return _PasswordSetupScaffold(
          title: title,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: showSkeleton
                ? const _PasswordLoadingCard()
                : state.hasExistingPassword
                ? _UpdatePasswordForm(state: state)
                : _CreatePasswordForm(state: state),
          ),
        );
      },
    );
  }
}

class _PasswordSetupScaffold extends StatelessWidget {
  const _PasswordSetupScaffold({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          const _PasswordBackground(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordBackground extends StatelessWidget {
  const _PasswordBackground();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primaryContainer,
            Theme.of(context).scaffoldBackgroundColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 80,
            right: -40,
            child: Icon(
              Icons.password_rounded,
              size: 140,
              color: colorScheme.onPrimary.withOpacity(0.12),
            ),
          ),
          Positioned(
            bottom: 120,
            left: -20,
            child: Icon(
              Icons.shield_outlined,
              size: 120,
              color: colorScheme.onPrimary.withOpacity(0.08),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordLoadingCard extends StatelessWidget {
  const _PasswordLoadingCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 36),
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.65),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 42,
                width: 42,
                child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '보안 상태를 확인하는 중이에요...',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.85),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '잠시만 기다려주세요.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreatePasswordForm extends StatefulWidget {
  const _CreatePasswordForm({required this.state});

  final PasswordSetupState state;

  @override
  State<_CreatePasswordForm> createState() => _CreatePasswordFormState();
}

class _CreatePasswordFormState extends State<_CreatePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmController;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController()..addListener(_handleChange);
    _confirmController = TextEditingController()..addListener(_handleChange);
  }

  @override
  void dispose() {
    _passwordController
      ..removeListener(_handleChange)
      ..dispose();
    _confirmController
      ..removeListener(_handleChange)
      ..dispose();
    super.dispose();
  }

  void _handleChange() {
    final cubit = context.read<PasswordSetupCubit>();
    if (cubit.state.isStatusFailure) {
      cubit.resetStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isBusy = widget.state.isStatusLoading;

    return Card(
      elevation: 10,
      shadowColor: colorScheme.primary.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      color: colorScheme.surface.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '새로운 비밀번호를 만들어주세요.',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '최소 4자 이상 입력하면 기기에서 안전하게 암호화됩니다.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              _PasswordTextField(
                controller: _passwordController,
                label: '비밀번호',
                enabled: !isBusy,
                obscureText: _obscurePassword,
                onToggleObscure: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                textInputAction: TextInputAction.next,
                validator: _validatePassword,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              const SizedBox(height: 16),
              _PasswordTextField(
                controller: _confirmController,
                label: '비밀번호 확인',
                enabled: !isBusy,
                obscureText: _obscureConfirm,
                onToggleObscure: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                textInputAction: TextInputAction.done,
                validator: (value) =>
                    _validateConfirm(value, _passwordController.text),
                onFieldSubmitted: (_) => _handleSubmit(),
              ),
              const SizedBox(height: 12),
              _ErrorMessage(message: widget.state.errorMessage),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isBusy ? null : _handleSubmit,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: isBusy
                      ? const _ButtonSpinner()
                      : const Text('비밀번호 저장'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validatePassword(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }
    if (trimmed.length < 4) {
      return '비밀번호는 최소 4자 이상이어야 합니다.';
    }
    return null;
  }

  String? _validateConfirm(String? value, String original) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return '비밀번호를 다시 입력해주세요.';
    }
    if (trimmed != original.trim()) {
      return '비밀번호가 서로 일치하지 않습니다.';
    }
    return null;
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() != true) return;
    FocusScope.of(context).unfocus();
    context.read<PasswordSetupCubit>().setPassword(_passwordController.text);
  }
}

class _UpdatePasswordForm extends StatefulWidget {
  const _UpdatePasswordForm({required this.state});

  final PasswordSetupState state;

  @override
  State<_UpdatePasswordForm> createState() => _UpdatePasswordFormState();
}

class _UpdatePasswordFormState extends State<_UpdatePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmController;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController()..addListener(_handleChange);
    _confirmController = TextEditingController()..addListener(_handleChange);
  }

  @override
  void dispose() {
    _passwordController
      ..removeListener(_handleChange)
      ..dispose();
    _confirmController
      ..removeListener(_handleChange)
      ..dispose();
    super.dispose();
  }

  void _handleChange() {
    final cubit = context.read<PasswordSetupCubit>();
    if (cubit.state.isStatusFailure) {
      cubit.resetStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isBusy = widget.state.isStatusLoading;

    return Card(
      elevation: 10,
      shadowColor: colorScheme.primary.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      color: colorScheme.surface.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '비밀번호를 변경하거나 삭제할 수 있어요.',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '보안을 위해 비밀번호와 확인을 모두 입력해주세요.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              _PasswordTextField(
                controller: _passwordController,
                label: '비밀번호',
                enabled: !isBusy,
                obscureText: _obscurePassword,
                onToggleObscure: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                textInputAction: TextInputAction.next,
                validator: _validatePassword,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              const SizedBox(height: 16),
              _PasswordTextField(
                controller: _confirmController,
                label: '비밀번호 확인',
                enabled: !isBusy,
                obscureText: _obscureConfirm,
                onToggleObscure: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                textInputAction: TextInputAction.done,
                validator: (value) =>
                    _validateConfirm(value, _passwordController.text),
                onFieldSubmitted: (_) => _handleSave(),
              ),
              const SizedBox(height: 12),
              _ErrorMessage(message: widget.state.errorMessage),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isBusy ? null : _handleSave,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: isBusy
                      ? const _ButtonSpinner()
                      : const Text('비밀번호 변경'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: isBusy ? null : _handleClear,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('비밀번호 삭제'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validatePassword(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }
    if (trimmed.length < 4) {
      return '비밀번호는 최소 4자 이상이어야 합니다.';
    }
    return null;
  }

  String? _validateConfirm(String? value, String original) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return '비밀번호를 다시 입력해주세요.';
    }
    if (trimmed != original.trim()) {
      return '비밀번호가 서로 일치하지 않습니다.';
    }
    return null;
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() != true) return;
    FocusScope.of(context).unfocus();
    context.read<PasswordSetupCubit>().setPassword(_passwordController.text);
  }

  void _handleClear() {
    if (_formKey.currentState?.validate() != true) return;
    FocusScope.of(context).unfocus();
    context.read<PasswordSetupCubit>().clearPassword(_passwordController.text);
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({
    required this.controller,
    required this.label,
    required this.enabled,
    required this.obscureText,
    required this.onToggleObscure,
    required this.validator,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final bool enabled;
  final bool obscureText;
  final VoidCallback onToggleObscure;
  final FormFieldValidator<String>? validator;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: enabled
            ? colorScheme.surfaceVariant.withOpacity(0.95)
            : colorScheme.surfaceVariant.withOpacity(0.7),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        suffixIcon: IconButton(
          onPressed: enabled ? onToggleObscure : null,
          icon: Icon(
            obscureText
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
          ),
        ),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (message.isEmpty) return const SizedBox.shrink();
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: message.isEmpty ? 0 : 1,
      child: Text(
        message,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ButtonSpinner extends StatelessWidget {
  const _ButtonSpinner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator.adaptive(
        strokeWidth: 2.2,
        valueColor: AlwaysStoppedAnimation(
          Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
