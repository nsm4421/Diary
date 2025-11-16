part of 'delete_diary_cubit.dart';

@CopyWith()
class DeleteDiaryState {
  final DeleteDiaryStatus status;
  final String errorMessage;

  DeleteDiaryState({
    this.status = DeleteDiaryStatus.idle,
    this.errorMessage = '',
  });

  bool get isReady => status == DeleteDiaryStatus.idle;

  bool get isDeleted => status == DeleteDiaryStatus.success;

  bool get isFailure => status == DeleteDiaryStatus.failure;
}
