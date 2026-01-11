part of 'p_create_agenda.dart';

class _Description extends StatefulWidget {
  const _Description();

  @override
  State<_Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<_Description> {
  late final TextEditingController _controller;
  late final CreateAgendaBloc _bloc;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_handleChange);
    _bloc = context.read<CreateAgendaBloc>();
  }

  _handleChange() {
    _bloc.add(
      CreateEvent.update(
        _bloc.state.data.copyWith(description: _controller.text.trim()),
      ),
    );
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: !_bloc.state.isLoading,
      controller: _controller,
      textInputAction: TextInputAction.next,
      minLines: 1,
      maxLines: 5,
      decoration: InputDecoration(
        labelText: '(선택) 상세설명',
        hintText: '자세한 투표내용을 추가할수 있어요',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: context.colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: context.colorScheme.primary,
            width: 1.6,
          ),
        ),
      ),
    );
  }
}
