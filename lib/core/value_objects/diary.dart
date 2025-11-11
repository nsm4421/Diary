import 'package:diary/core/extension/datetime_extension.dart';

enum SearchDiaryKind { none, title, content, dateRange }

class FetchDiaryParam {
  final SearchDiaryKind kind;

  FetchDiaryParam([this.kind = SearchDiaryKind.none]);

  factory FetchDiaryParam.none() {
    return FetchDiaryParam();
  }

  factory FetchDiaryParam.title(String title) {
    return FetchDiaryByTitleParamValue(title);
  }

  factory FetchDiaryParam.content(String content) {
    return FetchDiaryByContentParamValue(content);
  }

  factory FetchDiaryParam.dateRange({
    required DateTime start,
    required DateTime end,
  }) {
    return FetchDiaryByDateRangeParamValue(start: start, end: end);
  }
}

class FetchDiaryByTitleParamValue extends FetchDiaryParam {
  final String title;

  FetchDiaryByTitleParamValue(this.title) : super(SearchDiaryKind.title);

  @override
  String toString() => 'title search param:$title';
}

class FetchDiaryByContentParamValue extends FetchDiaryParam {
  final String content;

  FetchDiaryByContentParamValue(this.content) : super(SearchDiaryKind.content);

  @override
  String toString() => 'content search param:$content';
}

class FetchDiaryByDateRangeParamValue extends FetchDiaryParam {
  final DateTime start;
  final DateTime end;

  FetchDiaryByDateRangeParamValue({required this.start, required this.end})
    : super(SearchDiaryKind.dateRange);

  @override
  String toString() =>
      'dateRange search param:${start.yyyymmdd}~${end.yyyymmdd}';
}
