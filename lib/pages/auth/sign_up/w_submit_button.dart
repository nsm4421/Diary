part of 'p_sign_up.dart';

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return SizedBox(
          height: 44,
          child: FilledButton.tonal(
            onPressed: state.status == Status.initial
                ? () async {
                    FocusScope.of(context).unfocus();
                    await Future.delayed(500.durationInMilliSec, () {
                      if (!context.mounted) return;
                      context.read<SignUpCubit>().submit();
                    });
                  }
                : null,
            style: FilledButton.styleFrom(
              textStyle: context.textTheme.labelLarge,
            ),
            child: const Text("회원가입"),
          ),
        );
      },
    );
  }
}
