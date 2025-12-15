import 'package:diary/core/response/failure.dart';
import 'package:diary/domain/entity/diary/diary_entity.dart';
import 'package:diary/domain/usecase/diary/diary_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

part 'create_diary_state.dart';

part 'create_diary_cubit.freezed.dart';

@injectable
class CreateDiaryCubit extends Cubit<CreateDiaryState> {
  final DiaryUseCases _useCases;

  CreateDiaryCubit(this._useCases) : super(CreateDiaryState.idle());

  void initialize() {
    emit(CreateDiaryState.idle());
  }

  Future<void> submit([String? title]) async {
    if (!state.isIdle) return;
    final diaryId = genUuid();
    emit(CreateDiaryState.processing(diaryId: diaryId, title: title));
    await _useCases.createDiary
        .call(diaryId: diaryId, title: title)
        .then(
          (res) => res.fold(
            (failure) => emit(
              CreateDiaryState.failure(
                diaryId: diaryId,
                title: title,
                failure: failure,
              ),
            ),
            (created) => emit(CreateDiaryState.created(created)),
          ),
        );
  }
}
