part of 'create_diary_cubit.dart';

@freezed
class CreateDiaryState with _$CreateDiaryState {
  @override
  final CreateDiaryStatus status;
  @override
  final String title;
  @override
  final String content;
  @override
  final List<File> medias;
  @override
  final String errorMessage;

  const CreateDiaryState({
    this.status = CreateDiaryStatus.initial,
    this.title = '',
    this.content = '',
    this.medias = const [],
    this.errorMessage = '',
  });

  bool get isSubmitting => status == CreateDiaryStatus.submitting;

  bool get isSuccess => status == CreateDiaryStatus.success;

  bool get isError => status == CreateDiaryStatus.failure;
}
