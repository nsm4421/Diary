import 'package:diary/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared/shared.dart';
import 'package:vote/vote.dart';

part 'state.dart';

part 'cubit.freezed.dart';

@injectable
class CreateAgendaCommentCubit extends Cubit<CreateAgendaCommentState>
    with UuidMixIn {
  late final String _agendaId;
  late final String? _parentCommentId;
  late final ProfileModel _profile;
  final VoteService _voteService;
  final Logger _logger;

  CreateAgendaCommentCubit(
    @factoryParam CreateAgendaCommentParam params,
    this._voteService,
    this._logger,
  ) : super(CreateAgendaCommentState.idle()) {
    _agendaId = params.agendaId;
    _parentCommentId = params.parentCommentId;
    _profile = params.profile;
  }

  Future<void> submit(String text) async {
    if (state.isLoading) return;
    emit(CreateAgendaCommentState.loading(text));
    final commentId = genUuid();

    (await _voteService
            .createAgendaComment(
              commentId: commentId,
              parentCommentId: _parentCommentId,
              agendaId: _agendaId,
              content: text,
            )
            .run())
        .match(
          (failure) {
            _logger.failure(failure);
            emit(
              CreateAgendaCommentState.error(content: text, failure: failure),
            );
          },
          (_) {
            _logger.t('[CreateAgendaCommentCubit]comment created');
            final now = DateTime.now().toUtc();
            final created = AgendaCommentModel(
              id: commentId,
              createdAt: now,
              updatedAt: now,
              agendaId: _agendaId,
              parentId: _parentCommentId,
              content: text,
              author: _profile,
            );
            emit(CreateAgendaCommentState.success(created));
          },
        );
  }
}
