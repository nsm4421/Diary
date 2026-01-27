import 'package:diary/providers/vote/agenda_detail/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 's_agenda_detail.dart';

class AgendaDetailPage extends StatelessWidget {
  const AgendaDetailPage(this._agendaId, {super.key});

  final String _agendaId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<AgendaDetailBloc>(param1: _agendaId),
      child: BlocBuilder<AgendaDetailBloc, AgendaDetailState>(
        builder: (context, state) {
          return state.agenda == null
              ? Center(child: CircularProgressIndicator())
              : _Screen();
        },
      ),
    );
  }
}
