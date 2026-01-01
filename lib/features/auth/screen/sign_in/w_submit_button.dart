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
        return ElevatedButton(
          onPressed: state.canRequest ? signInCubit.submit : null,
          child: Text("SUBMIT"),
        );
      },
    );
  }
}
