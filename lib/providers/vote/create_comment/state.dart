part of 'cubit.dart';

typedef CreateAgendaCommentParam = ({
  String agendaId,
  String? parentCommentId,
  ProfileModel profile,
});

@freezed
sealed class CreateAgendaCommentState with _$CreateAgendaCommentState {
  factory CreateAgendaCommentState.idle() = _Idle;

  factory CreateAgendaCommentState.loading(String content) = _Loading;

  factory CreateAgendaCommentState.success(AgendaCommentModel created) =
      _Success;

  factory CreateAgendaCommentState.error({
    required String content,
    required Failure failure,
  }) = _Failure;
}

extension CreateAgendaCommentStateExtension on CreateAgendaCommentState {
  bool get isLoading => mapOrNull(loading: (_) => true) ?? false;

  bool get isSuccess => mapOrNull(success: (_) => true) ?? false;

  AgendaCommentModel? get created =>
      mapOrNull(success: (e) => e.created) ?? null;
}
