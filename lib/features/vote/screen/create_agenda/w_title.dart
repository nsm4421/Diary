part of 'p_create_agenda.dart';

class _Title extends StatefulWidget {
  const _Title();

  @override
  State<_Title> createState() => _TitleState();
}

class _TitleState extends State<_Title> {
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
        _bloc.state.data.copyWith(title: _controller.text.trim()),
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
      decoration: InputDecoration(
        labelText: '제목',
        hintText: '투표 제목을 작명해주세요',
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
