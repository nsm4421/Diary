part of 'create_diary_cubit.dart';

@freezed
class CreateDiaryState with _$CreateDiaryState {
  const factory CreateDiaryState.idle() = _Idle;

  const factory CreateDiaryState.processing({
    required String diaryId,
    String? title,
  }) = _Processing;

  const factory CreateDiaryState.created(DiaryEntity created) = _Created;

  const factory CreateDiaryState.failure({
    String? diaryId,
    String? title,
    required Failure failure,
  }) = _Failure;
}

extension CraeteDiaryStateX on CreateDiaryState {
  bool get isIdle => maybeWhen(idle: () => true, orElse: () => false);

  bool get isLoading =>
      maybeWhen(processing: (_, _) => true, orElse: () => false);

  bool get isCreated => maybeWhen(created: (_) => true, orElse: () => false);

  bool get isFailure =>
      maybeWhen(failure: (_, _, _) => true, orElse: () => false);

  DiaryEntity? get created => maybeWhen(created: (e) => e, orElse: () => null);

  Failure? get failure =>
      maybeWhen(failure: (_, _, e) => e, orElse: () => null);
}
