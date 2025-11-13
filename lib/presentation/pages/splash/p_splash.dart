import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:diary/presentation/provider/security/password_lock/password_lock_cubit.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diary/core/extension/build_context_extension.dart';

const _kSplashDisplayDuration = Duration(milliseconds: 1600);

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  Timer? _navigateTimer;
  bool _delayElapsed = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateTimer = Timer(_kSplashDisplayDuration, () {
        if (!mounted) return;
        _delayElapsed = true;
        _maybeNavigate(context.read<PasswordLockCubit>().state);
      });
    });
  }

  @override
  void dispose() {
    _navigateTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return BlocListener<PasswordLockCubit, PasswordLockState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) => _maybeNavigate(state),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primaryContainer.withAlpha(90),
                colorScheme.primary,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 80,
                right: -40,
                child: Icon(
                  Icons.auto_stories_outlined,
                  size: 140,
                  color: colorScheme.onPrimary.withAlpha(8),
                ),
              ),
              Positioned(
                bottom: 60,
                left: 24,
                child: Opacity(
                  opacity: 0.12,
                  child: Icon(
                    Icons.edit_note_outlined,
                    size: 120,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
              SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'diary-logo',
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: colorScheme.onPrimary.withAlpha(10),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.onPrimary.withAlpha(20),
                                width: 1.2,
                              ),
                            ),
                            child: Icon(
                              Icons.menu_book_rounded,
                              size: 48,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          'My Diary',
                          style: textTheme.headlineMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '하루를 기록하고\n감정을 남겨보세요',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onPrimary.withAlpha(85),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _maybeNavigate(PasswordLockState state) {
    if (_hasNavigated || !_delayElapsed) return;
    if (state.isLoading) return;

    _hasNavigated = true;
    if (state.isLocked) {
      context.router.replace(PasswordGateRoute(autoRedirectToHome: true));
    } else {
      context.router.replace(const DisplayDiaryRoute());
    }
  }
}
