import 'package:diary/core/value_objects/diary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchDiaryCubit extends Cubit<FetchDiaryParam> {
  late FetchDiaryByTitleParamValue _cachedTitleParam;
  late FetchDiaryByContentParamValue _cachedContentParam;
  late FetchDiaryByDateRangeParamValue _cachedDateRangeParam;

  SearchDiaryCubit() : super(FetchDiaryParam.title('')) {
    _cachedTitleParam = FetchDiaryByTitleParamValue('');
    _cachedContentParam = FetchDiaryByContentParamValue('');
    _cachedDateRangeParam = FetchDiaryByDateRangeParamValue(
      start: DateTime.now().subtract(Duration(days: 14)),
      end: DateTime.now(),
    );
  }

  void switchKind(SearchDiaryKind kind) {
    emit(switch (kind) {
      SearchDiaryKind.content => _cachedContentParam,
      SearchDiaryKind.dateRange => _cachedDateRangeParam,
      (_) => _cachedTitleParam,
    });
  }

  void updateTitle(String text) {
    _cachedTitleParam = FetchDiaryByTitleParamValue(text.trim());
    emit(_cachedTitleParam);
  }

  void updateContent(String text) {
    _cachedContentParam = FetchDiaryByContentParamValue(text.trim());
    emit(_cachedContentParam);
  }

  void updateDateRange({required DateTime start, required DateTime end}) {
    _cachedDateRangeParam = FetchDiaryByDateRangeParamValue(
      start: start,
      end: end,
    );
    emit(_cachedDateRangeParam);
  }
}
