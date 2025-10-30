import 'package:dartz/dartz.dart';
import 'package:diary/core/error/failure.dart';
import 'package:diary/core/value_objects/pageable.dart';
import 'package:diary/domain/entity/diary_entry.dart';
import 'package:diary/domain/usecase/diary/diary_usecases.dart';
import 'package:diary/presentation/provider/display/display_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class DisplayDiaryBloc extends DisplayBloc<DiaryEntry, DateTime, FetchDiaryParam> {
  final DiaryUseCases _diaryUseCases;

  DisplayDiaryBloc(this._diaryUseCases);

  @override
  Future<Either<Failure, Pageable<DiaryEntry, DateTime>>> fetch({
    required DateTime cursor,
    int limit = 30,
    FetchDiaryParam? param
  }) async {
    return await _diaryUseCases.fetch.call(
      cursor: cursor,
      limit: limit,
      param: param ?? FetchDiaryParam.none(),
    );
  }

  @override
  String idOf(DiaryEntry item) => item.id;

  @override
  DateTime initialCursor() => DateTime.now().toUtc();
}
