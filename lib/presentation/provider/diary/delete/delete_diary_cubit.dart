import 'package:diary/core/constant/status.dart';
import 'package:diary/domain/usecase/diary/diary_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'delete_diary_state.dart';

part 'delete_diary_cubit.g.dart';

@injectable
class DeleteDiaryCubit extends Cubit<DeleteDiaryState> {
  final String _diaryId;
  final DiaryUseCases _diaryUseCases;

  DeleteDiaryCubit(@factoryParam this._diaryId, this._diaryUseCases)
    : super(DeleteDiaryState());

  Future<void> reset([
    Duration duration = const Duration(milliseconds: 500),
  ]) async {
    await Future.delayed(duration);
    emit(state.copyWith(status: DeleteDiaryStatus.idle, errorMessage: ''));
  }

  Future<void> delete() async {
    emit(state.copyWith(status: DeleteDiaryStatus.loading, errorMessage: ''));

    await _diaryUseCases
        .delete(_diaryId)
        .then(
          (res) => res.fold(
            (failure) => emit(
              state.copyWith(
                status: DeleteDiaryStatus.failure,
                errorMessage: failure.message,
              ),
            ),
            (_) => emit(
              state.copyWith(
                status: DeleteDiaryStatus.success,
                errorMessage: '',
              ),
            ),
          ),
        );
  }
}
