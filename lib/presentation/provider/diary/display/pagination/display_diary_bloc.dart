import 'package:dartz/dartz.dart';
import 'package:diary/core/value_objects/error/failure.dart';
import 'package:diary/core/value_objects/domain/fetch_diary.dart';
import 'package:diary/core/value_objects/pageable.dart';
import 'package:diary/domain/entity/diary_entity.dart';
import 'package:diary/domain/usecase/diary/diary_usecases.dart';
import 'package:diary/presentation/provider/display/display_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class DisplayDiaryBloc extends DisplayBloc<DiaryEntity, DateTime> {
  final DiaryUseCases _diaryUseCases;
  late final FetchDiaryParam _param;

  DisplayDiaryBloc(@factoryParam FetchDiaryParam? param, this._diaryUseCases) {
    _param = param ?? FetchDiaryParam.none();
  }

  @override
  Future<Either<Failure, Pageable<DiaryEntity, DateTime>>> fetch({
    required DateTime cursor,
    int limit = 30,
  }) async {
    return await _diaryUseCases.fetch.call(
      cursor: cursor,
      limit: limit,
      param: _param,
    );
  }

  @override
  String idOf(DiaryEntity item) => item.id;

  @override
  DateTime initialCursor() => DateTime.now().toUtc();
}
