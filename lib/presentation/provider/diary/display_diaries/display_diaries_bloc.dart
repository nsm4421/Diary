import 'package:diary/core/response/app_response.dart';
import 'package:diary/core/value_objects/pageable.dart';
import 'package:diary/domain/entity/base/base_entity_extension.dart';
import 'package:diary/domain/entity/diary/diary_entity.dart';
import 'package:diary/domain/usecase/diary/diary_usecases.dart';
import 'package:diary/presentation/provider/base/display_bloc/display_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class DisplayDiariesBloc extends DisplayBloc<DiaryEntity, DateTime> {
  final DiaryUseCases _useCases;

  DisplayDiariesBloc(this._useCases);

  @override
  Future<AppResponse<Pageable<DiaryEntity, DateTime>>> fetch({
    required DateTime cursor,
    int limit = 20,
  }) async {
    return await _useCases
        .fetchDiaries(lastCreatedAt: cursor, limit: limit)
        .then(
          (res) => res.map(
            (diaries) => Pageable(
              items: diaries,
              nextCursor: diaries.length < limit
                  ? null
                  : diaries.leastCreatedAt,
            ),
          ),
        );
  }

  @override
  String idOf(DiaryEntity item) => item.id;

  @override
  DateTime initialCursor() => DateTime.now().toUtc();
}
