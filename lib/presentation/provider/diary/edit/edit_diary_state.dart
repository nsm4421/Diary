part of 'edit_diary_cubit.dart';

@freezed
class EditDiaryState with _$EditDiaryState {
  @override
  final EditDiaryStatus status;
  @override
  final String title;
  @override
  final String content;
  @override
  final List<File> medias;
  @override
  final String errorMessage;
  @override
  final DiaryMood mood;

  const EditDiaryState({
    this.status = EditDiaryStatus.idle,
    this.title = '',
    this.content = '',
    this.medias = const [],
    this.errorMessage = '',
    this.mood = DiaryMood.none,
  });

  bool get isMounted => status != EditDiaryStatus.idle;

  bool get isSubmitting => status == EditDiaryStatus.submitting;

  bool get isSuccess => status == EditDiaryStatus.success;

  bool get isError => status == EditDiaryStatus.failure;
}
