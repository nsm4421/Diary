import 'dart:async';
import 'dart:math';

import 'package:diary/core/dependency_injection/dependency_injection.dart';
import 'package:diary/domain/usecase/diary/diary_usecases.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const int _seedCount = int.fromEnvironment('SEED_COUNT', defaultValue: 12);

/// Provide explicit entries when you want predictable output.
/// Leave the list empty to fall back to auto-generated samples.
const List<SeedDiaryEntry> _manualEntries = <SeedDiaryEntry>[
  // Example:
  // SeedDiaryEntry(
  //   title: '주말 등산',
  //   content: '아침 일찍 북악산을 올랐다. 공기가 상쾌해서 마음이 정리되는 느낌!',
  // ),
];

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  final entries = _manualEntries.isNotEmpty
      ? _manualEntries
      : _generateEntries(_seedCount > 0 ? _seedCount : 12);

  final seeder = _DiarySeeder(getIt<DiaryUseCases>());
  final result = await seeder.seed(entries);

  debugPrint('--- Diary seeding completed ---');
  debugPrint('  Inserted: ${result.inserted}');
  if (result.failures.isNotEmpty) {
    for (final failure in result.failures) {
      debugPrint(
        '  Failed: ${failure.entryTitle ?? '무제'} -> ${failure.message}',
      );
    }
  }
  debugPrint('--------------------------------');

  // Give the logs a chance to flush before closing.
  await Future<void>.delayed(const Duration(milliseconds: 300));
  await SystemNavigator.pop();
}

class _DiarySeeder {
  _DiarySeeder(this._useCases);

  final DiaryUseCases _useCases;

  Future<SeedResult> seed(List<SeedDiaryEntry> entries) async {
    var inserted = 0;
    final failures = <SeedFailure>[];

    for (final entry in entries) {
      final result = await _useCases.create(
        title: entry.title,
        content: entry.content,
      );

      result.fold(
        (failure) {
          failures.add(
            SeedFailure(
              entryTitle: entry.title,
              message: failure.message,
            ),
          );
        },
        (_) => inserted++,
      );

      // Small delay keeps Drift transactions from overlapping too quickly,
      // making logs easier to read when seeding many rows.
      await Future<void>.delayed(const Duration(milliseconds: 80));
    }

    return SeedResult(inserted: inserted, failures: failures);
  }
}

class SeedDiaryEntry {
  final String? title;
  final String content;

  const SeedDiaryEntry({this.title, required this.content});
}

class SeedResult {
  final int inserted;
  final List<SeedFailure> failures;

  const SeedResult({required this.inserted, required this.failures});
}

class SeedFailure {
  final String? entryTitle;
  final String message;

  const SeedFailure({this.entryTitle, required this.message});
}

List<SeedDiaryEntry> _generateEntries(int count) {
  final random = Random();
  final titles = <String>[
    '아침 산책 기록',
    '요가 수련 일지',
    '커피 한 잔의 여유',
    '오늘의 배움',
    '소소한 행복',
    '개발 일기',
    '주말 계획',
    '독서 메모',
    '여행 버킷리스트',
    '그냥 그런 날',
  ];
  final moods = <String>[
    '기분이 상쾌했다',
    '조금 지쳤지만 의욕이 생겼다',
    '새로운 아이디어가 반짝였다',
    '평온하고 따뜻했다',
    '살짝 우울했지만 금방 괜찮아졌다',
    '집중이 잘 됐다',
    '여유로운 하루였다',
    '후련한 마음이 들었다',
    '하루 종일 설렜다',
    '꽤 만족스러웠다',
  ];
  final details = <String>[
    '점심으로는 간단하게 샐러드를 먹었다.',
    '오랜만에 친구와 통화하며 웃을 일이 많았다.',
    '바람이 시원해서 산책하기 딱 좋았다.',
    '작은 실수가 있었지만 금방 수습했다.',
    '읽고 있던 책이 절정으로 치달아 손을 놓을 수 없었다.',
    '코딩 문제를 해결하고 큰 성취감을 느꼈다.',
    '고양이가 옆에서 졸고 있어서 마음이 안정됐다.',
    '작업실을 정리했더니 머릿속도 말끔해진 느낌이다.',
    '노을이 너무 예뻐서 사진을 잔뜩 찍었다.',
    '오늘은 스스로를 칭찬해주고 싶다.',
  ];

  return List<SeedDiaryEntry>.generate(count, (index) {
    final hasTitle = random.nextBool();
    final title = hasTitle ? titles[random.nextInt(titles.length)] : null;

    final mood = moods[random.nextInt(moods.length)];
    final detail = details[random.nextInt(details.length)];
    final reflection = details[(random.nextInt(details.length))];

    final content = StringBuffer()
      ..writeln('Day ${index + 1}')
      ..writeln()
      ..writeln('$mood.')
      ..writeln(detail)
      ..writeln(reflection);

    return SeedDiaryEntry(
      title: title,
      content: content.toString(),
    );
  });
}
