part of 'p_create_diary.dart';

class _SubmitButton extends StatelessWidget {
  const _SubmitButton(this._formKey, {super.key});

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateDiaryCubit, CreateDiaryState>(
      builder: (context, state) {
        return FilledButton(
          onPressed: state.isSubmitting
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  _formKey.currentState?.save();
                  final ok = _formKey.currentState?.validate();
                  if (ok == null || !ok) return;
                  await context.read<CreateDiaryCubit>().handleSubmit();
                },
          child: state.isSubmitting
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('저장'),
        );
      },
    );
  }
}
