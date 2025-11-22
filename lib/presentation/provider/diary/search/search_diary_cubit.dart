import 'package:diary/core/value_objects/domain/fetch_diary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchDiaryCubit extends Cubit<FetchDiaryParam> {
  late FetchDiaryByTitleParamValue _cachedTitleParam;
  late FetchDiaryByContentParamValue _cachedContentParam;

  SearchDiaryCubit() : super(FetchDiaryParam.title('')) {
    _cachedTitleParam = FetchDiaryByTitleParamValue('');
    _cachedContentParam = FetchDiaryByContentParamValue('');
  }

  void switchKind(SearchDiaryKind kind) {
    emit(switch (kind) {
      SearchDiaryKind.content => _cachedContentParam,
      SearchDiaryKind.title => _cachedTitleParam,
      (_) => state,
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
}
