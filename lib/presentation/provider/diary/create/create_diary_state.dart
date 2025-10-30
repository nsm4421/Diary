part of 'create_diary_cubit.dart';

enum _Status { initial, editing, submitting, failure, success }

@freezed
class CreateDiaryState with _$CreateDiaryState {
  @override
  final _Status status;
  @override
  final String title;
  @override
  final String content;
  @override
  final Failure? failure;

  const CreateDiaryState({
    this.status = _Status.initial,
    this.title = '',
    this.content = '',
    this.failure,
  });

  bool get isSubmitting => status == _Status.submitting;

  bool get isSuccess => status == _Status.success;

  bool get isError => status == _Status.failure;
}
