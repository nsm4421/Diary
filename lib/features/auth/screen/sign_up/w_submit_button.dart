part of 's_sign_up.dart';

final _kLoadingDuration = 1500.durationInMilliSec;

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final signUpCubit = context.read<SignUpCubit>();
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (_, state) async {
        if (!state.isError) return;
        await Future.delayed(_kLoadingDuration, () {
          signUpCubit.resetError();
        });
      },
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.canRequest ? signUpCubit.submit : null,
          child: Text("SUBMIT"),
        );
      },
    );
  }
}
