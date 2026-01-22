import 'package:diary/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';
import 'package:vote/vote.dart';

part 'state.dart';

part 'cubit.freezed.dart';

@injectable
class CreateAgendaCubit extends Cubit<CreateAgendaState> with UuidMixIn {
  final String _agendaId;
  final VoteService _voteService;

  CreateAgendaCubit(this._voteService, @factoryParam this._agendaId)
    : super(CreateAgendaState());

  void resetStatus() {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: Status.initial, failure: null));
  }

  void updateTitle(String text) {
    if (state.status.isLoading) return;
    emit(state.copyWith(title: text, failure: null));
  }

  void updateDescription(String text) {
    if (state.status.isLoading) return;
    emit(state.copyWith(description: text, failure: null));
  }

  void updateChoices(List<String> choices) {
    if (state.status.isLoading) return;
    emit(state.copyWith(choices: choices, failure: null));
  }

  Future<void> submit() async {
    if (state.status.isLoading) return;
    emit(
      state.copyWith(
        title: state.title.trim(),
        description: state.description.trim(),
        choices: state.choices.map((e) => e.trim()).toList(growable: false),
      ),
    );

    /// validation
    if (state.title.isEmpty) {
      emit(
        state.copyWith(
          status: Status.error,
          failure: Failure(message: '제목을 입력해주세요'),
        ),
      );
      return;
    } else if (state.choices.length < 2) {
      emit(
        state.copyWith(
          status: Status.error,
          failure: Failure(message: '선택지를 2개이상 입력해주세요'),
        ),
      );
      return;
    } else if (state.choices.length != state.choices.toSet().length) {
      emit(
        state.copyWith(
          status: Status.error,
          failure: Failure(message: '중복된 선택지가 존재합니다'),
        ),
      );
      return;
    }

    /// call service
    emit(state.copyWith(status: Status.loading));
    (await _voteService
            .createAgenda(
              agendaId: _agendaId,
              agendaTitle: state.title,
              agendaDescription: state.description.isEmpty
                  ? null
                  : state.description,
              choices: state.choices
                  .map((choice) => (genUuid(), choice))
                  .toList(),
            )
            .run())
        .match(
          (failure) {
            emit(state.copyWith(status: Status.error, failure: failure));
          },
          (created) {
            emit(
              state.copyWith(
                status: Status.success,
                failure: null,
                created: created,
              ),
            );
          },
        );
  }
}
