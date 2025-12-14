import 'package:app_extensions/export.dart';
import 'package:auto_route/auto_route.dart';
import 'package:diary/presentation/components/components.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AuthLandingPage extends StatelessWidget {
  const AuthLandingPage({super.key});

  void _openSignUp(BuildContext context) {
    context.router.push(const SignUpRoute());
  }

  void _openSignIn(BuildContext context) {
    context.router.push(const SignInRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AuthLogo(),
                  const SizedBox(height: 16),
                  Text(
                    'Karma Diary',
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '가볍게 기록을 시작해보세요.',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    onPressed: () => _openSignUp(context),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      textStyle: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                    label: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => _openSignIn(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      textStyle: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    icon: const Icon(Icons.lock_open_rounded),
                    label: const Text('Log In'),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer.withOpacity(
                        0.18,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: context.colorScheme.primaryContainer.withOpacity(
                          0.6,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_fix_high_rounded,
                          size: 18,
                          color: context.colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '오늘의 감정을 짧게 남겨보세요.',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
