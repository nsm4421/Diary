part of 'sign_up_page.dart';

class _SocialSignUpButtonsWidget extends StatelessWidget {
  const _SocialSignUpButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.tonalIcon(
          onPressed: () {},
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            textStyle: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          icon: const Icon(Icons.g_translate_rounded),
          label: const Text('Continue with Google'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            textStyle: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          icon: const Icon(Icons.code_rounded),
          label: const Text('Continue with GitHub'),
        ),
      ],
    );
  }
}
