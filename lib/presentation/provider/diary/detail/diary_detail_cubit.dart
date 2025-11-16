import 'package:diary/core/constant/error_code.dart';
import 'package:diary/core/value_objects/error/failure.dart';
import 'package:diary/core/constant/status.dart';
import 'package:diary/domain/entity/diary_detail_entity.dart';
import 'package:diary/domain/usecase/diary/diary_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'diary_detail_state.dart';

part 'diary_detail_cubit.g.dart';

@injectable
class DiaryDetailCubit extends Cubit<DiaryDetailState> {
  DiaryDetailCubit(@factoryParam this._diaryId, this._diaryUseCases)
    : super(DiaryDetailState());

  final String _diaryId;
  final DiaryUseCases _diaryUseCases;

  Future<void> init([bool forceRefresh = false]) async {
    final shouldFetch = forceRefresh || !state.isFetched && state.diary == null;
    if (!shouldFetch) {
      return;
    }

    emit(
      state
          .copyWith(status: DiaryDetailStatus.loading)
          .copyWith(errorMessage: ''),
    );

    await _diaryUseCases
        .getDetail(_diaryId)
        .then(
          (res) => res.fold(
            (failure) => emit(
              state.copyWith(
                status: DiaryDetailStatus.failure,
                errorMessage: _failureMessage(failure),
              ),
            ),
            (detail) {
              emit(
                detail == null
                    ? state
                          .copyWith(
                            status: DiaryDetailStatus.failure,
                            errorMessage: '해당 일기를 찾을 수 없습니다.',
                          )
                          .copyWithNull(diary: true)
                    : state
                          .copyWith(
                            status: DiaryDetailStatus.fetched,
                            diary: detail,
                          )
                          .copyWith(errorMessage: ''),
              );
            },
          ),
        );
  }

  Future<void> refresh() async {
    await init(true);
  }

  String _failureMessage(Failure failure) {
    return switch (failure.code) {
      ErrorCode.validation => failure.description,
      ErrorCode.notFound => '해당 일기를 찾을 수 없습니다.',
      ErrorCode.network || ErrorCode.timeout => '네트워크 연결을 확인해주세요.',
      _ => failure.description,
    };
  }
}
