part of 'diary_detail_cubit.dart';

@CopyWith(copyWithNull: true)
class DiaryDetailState extends Equatable {
  const DiaryDetailState({
    this.status = DiaryDetailStatus.idle,
    this.diary,
    this.errorMessage = '',
  });

  final DiaryDetailStatus status;
  final DiaryDetailEntity? diary;
  final String errorMessage;

  bool get isInitial => status == DiaryDetailStatus.idle;

  bool get isLoading => status == DiaryDetailStatus.loading;

  bool get isFetched => status == DiaryDetailStatus.fetched;

  bool get isFailure => status == DiaryDetailStatus.failure;

  @override
  List<Object?> get props => [status, diary, errorMessage];
}
