part of 's_sign_in.dart';

final _kLoadingDuration = 1500.durationInMilliSec;

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final signInCubit = context.read<SignInCubit>();
    return BlocConsumer<SignInCubit, SignInState>(
      listener: (_, state) async {
        if (!state.isError) return;
        await Future.delayed(_kLoadingDuration, () {
          signInCubit.resetError();
        });
      },
      builder: (context, state) {
        final isEnabled = state.canRequest;
        final gradient = isEnabled
            ? LinearGradient(
                colors: [
                  context.colorScheme.primary,
                  context.colorScheme.tertiary,
                ],
              )
            : LinearGradient(
                colors: [
                  context.colorScheme.surfaceContainerHighest,
                  context.colorScheme.surfaceContainerHighest,
                ],
              );
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 22),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  if (isEnabled)
                    BoxShadow(
                      color: context.colorScheme.primary.withAlpha(64),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: isEnabled ? signInCubit.submit : null,
                  child: AnimatedSwitcher(
                    duration: 200.durationInMilliSec,
                    child: state.isLoading
                        ? Row(
                            key: const ValueKey('loading'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    context.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Signing in...',
                                style: context.textTheme.labelLarge?.copyWith(
                                  color: context.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            key: const ValueKey('idle'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'SUBMIT',
                                style: context.textTheme.labelLarge?.copyWith(
                                  color: context.colorScheme.onPrimary,
                                  letterSpacing: 1.1,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                Icons.arrow_forward,
                                size: 18,
                                color: context.colorScheme.onPrimary,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
