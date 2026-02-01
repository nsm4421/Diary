part of 'p_sign_in.dart';

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, state) {
        return SizedBox(
          height: 44,
          child: FilledButton.tonal(
            onPressed: state.canRequest
                ? () async {
                    FocusScope.of(context).unfocus();
                    await Future.delayed(500.durationInMilliSec, () {
                      if (!context.mounted) return;
                      context.read<SignInCubit>().submit();
                    });
                  }
                : null,
            style: FilledButton.styleFrom(
              textStyle: context.textTheme.labelLarge,
            ),
            child: const Text("로그인"),
          ),
        );
      },
    );
  }
}
