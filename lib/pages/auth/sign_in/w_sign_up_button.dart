part of 'p_sign_in.dart';

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.router.push(const SignUpRoute());
      },
      style: TextButton.styleFrom(
        foregroundColor: context.colorScheme.onSurfaceVariant,
        textStyle: context.textTheme.labelMedium,
      ),
      child: const Text("회원가입"),
    );
  }
}
