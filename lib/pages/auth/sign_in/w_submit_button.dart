part of 'page.dart';

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, state) {
        return TextButton(
          onPressed: state.canRequest
              ? () async {
                  FocusScope.of(context).unfocus();
                  await Future.delayed(500.durationInMilliSec, () {
                    if (!context.mounted) return;
                    context.read<SignInCubit>().submit();
                  });
                }
              : null,
          child: Text("제출하기"),
        );
      },
    );
  }
}
