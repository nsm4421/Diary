import 'package:diary/core/value_objects/diary.dart';
import 'package:diary/presentation/provider/diary/search/search_diary_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SearchDiaryCubit cubit;

  setUp(() {
    cubit = SearchDiaryCubit();
  });

  tearDown(() async {
    await cubit.close();
  });

  test('initial state is title search with empty keyword', () {
    expect(cubit.state, isA<FetchDiaryByTitleParamValue>());
    final param = cubit.state as FetchDiaryByTitleParamValue;
    expect(param.title, '');
  });

  test('updateTitle trims value and is restored after switching kinds', () {
    cubit.updateTitle('  spring trip  ');
    expect(
      (cubit.state as FetchDiaryByTitleParamValue).title,
      'spring trip',
    );

    cubit.switchKind(SearchDiaryKind.content);
    expect(cubit.state, isA<FetchDiaryByContentParamValue>());

    cubit.switchKind(SearchDiaryKind.title);
    expect(
      (cubit.state as FetchDiaryByTitleParamValue).title,
      'spring trip',
    );
  });

  test('updateContent and updateDateRange cache their params', () {
    cubit.updateContent('  gratitude list ');
    expect(
      (cubit.state as FetchDiaryByContentParamValue).content,
      'gratitude list',
    );

    cubit.switchKind(SearchDiaryKind.dateRange);
    final start = DateTime(2024, 3, 1);
    final end = DateTime(2024, 3, 31);
    cubit.updateDateRange(start: start, end: end);
    final dateParam = cubit.state as FetchDiaryByDateRangeParamValue;
    expect(dateParam.start, start);
    expect(dateParam.end, end);

    cubit.switchKind(SearchDiaryKind.content);
    expect(
      (cubit.state as FetchDiaryByContentParamValue).content,
      'gratitude list',
    );
  });
}
