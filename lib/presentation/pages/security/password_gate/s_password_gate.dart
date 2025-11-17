part of 'p_password_gate.dart';

class _Screen extends StatefulWidget {
  final bool autoRedirectToHome;

  const _Screen({super.key, this.autoRedirectToHome = false});

  @override
  State<_Screen> createState() => __ScreenState();
}

class __ScreenState extends State<_Screen> {
  final TextEditingController _controller = TextEditingController();
  bool _completedNavigation = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordLockCubit, PasswordLockState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (_shouldUnlock(state)) {
          _handleUnlocked();
          return;
        }
        if (state.isFailure && state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        final colorScheme = context.colorScheme;
        final textTheme = context.textTheme;
        final isBusy = state.isLoading;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            leading: Icon(
              Icons.lock_outline,
              color: context.colorScheme.onPrimary,
            ),
            title: Text(
              '비밀번호 잠금',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: Stack(
            children: [
              Container(
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
              ),
              Positioned(
                top: 100,
                right: -36,
                child: Icon(
                  Icons.lock_outline_rounded,
                  size: 140,
                  color: colorScheme.onPrimary.withAlpha(20),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '등록된 비밀번호로 잠금을 해제하세요.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimary.withAlpha(220),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _controller,
                        enabled: !isBusy,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          labelText: '비밀번호 입력',
                          filled: true,
                          fillColor: colorScheme.surface.withAlpha(235),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (state.errorMessage.isNotEmpty)
                        Text(
                          state.errorMessage,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.errorContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(height: 16),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(54),
                        ),
                        onPressed: isBusy ? null : _submit,
                        child: isBusy
                            ? SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 2.4,
                                  backgroundColor: colorScheme.onPrimary,
                                ),
                              )
                            : const Text('잠금 해제'),
                      ),
                      const SizedBox(height: 12),
                      if (state.isLocked)
                        Text(
                          '남은 시도: ${state.remainingAttempts}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onPrimary.withAlpha(220),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submit() {
    final password = _controller.text.trim();
    context.read<PasswordLockCubit>().submit(password);
  }

  void _handleUnlocked() {
    if (_completedNavigation) return;
    _completedNavigation = true;
    if (widget.autoRedirectToHome) {
      context.router.replaceAll([const HomeRoute()]);
    } else {
      context.router.maybePop(true);
    }
  }

  bool _shouldUnlock(PasswordLockState state) {
    if (state.isFailure || state.isLoading) return false;
    return !state.isLocked;
  }
}
