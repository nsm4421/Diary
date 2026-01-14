part of 'p_sign_up.dart';

class _SignInButton extends StatelessWidget {
  const _SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.router.pop();
      },
      style: TextButton.styleFrom(
        foregroundColor: context.colorScheme.onSurfaceVariant,
        textStyle: context.textTheme.labelMedium,
      ),
      child: const Text("로그인"),
    );
  }
}
