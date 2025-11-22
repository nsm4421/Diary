import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:diary/core/dependency_injection/dependency_injection.dart';
import 'package:diary/core/value_objects/domain/diary_mood.dart';
import 'package:diary/domain/usecase/diary/diary_usecases.dart';

const int _seedCount = int.fromEnvironment('SEED_COUNT', defaultValue: 12);

/// Provide explicit entries when you want predictable output.
/// Leave the list empty to fall back to auto-generated samples.
const List<SeedDiaryEntry> _manualEntries = <SeedDiaryEntry>[
  SeedDiaryEntry(
    title: '월요일 출근길 메모',
    mood: DiaryMood.soso,
    content: '''출근길 버스에서 졸다가 창밖을 보니 안개가 얇게 깔려 있었다.
점심은 회사 근처 김치찌개로 간단히 해결했다.

퇴근길에 이어폰으로 오래된 플레이리스트를 들으니 고등학교 생각이 잠깐 났다.
집에 돌아와서는 베란다 창문을 열어두고 한참 멍을 때렸다.''',
  ),
  SeedDiaryEntry(
    title: '약속 취소된 화요일',
    mood: DiaryMood.sad,
    content: '''저녁에 보기로 한 약속이 취소되어 갑자기 시간이 생겼다.
피곤해서 바로 누울까 하다가, 냉장고 청소를 조금 했다.

혼자 밥을 먹으면서 유튜브로 여행 브이로그를 틀어놨더니
나도 어디론가 떠나고 싶다는 생각이 들었다.''',
  ),
  SeedDiaryEntry(
    title: '집에서 보내는 조용한 수요일',
    mood: DiaryMood.soso,
    content: '''재택근무라 오전은 비교적 여유로웠다.
비가 와서 창문을 두드리는 소리가 배경음악처럼 깔렸다.

점심 후 갑자기 졸음이 몰려와서 짧게 20분 낮잠을 잤다.
눈을 뜨니 머리가 맑아져서 미뤄둔 문서 작업을 한 번에 끝냈다.''',
  ),
  SeedDiaryEntry(
    title: '헬스장 복귀',
    mood: DiaryMood.happy,
    content: '''오랜만에 헬스장에 갔다. 러닝머신 20분, 스쿼트와 데드리프트 가볍게.
근육이 깨어나는 느낌이 조금 무섭지만 기분은 상쾌했다.

샤워하고 나오니 비가 그쳐 있었다. 편의점에서 단백질 음료 하나 사서 집으로.''',
  ),
  SeedDiaryEntry(
    title: null,
    mood: DiaryMood.happy,
    content: '''점심시간에 회사 옥상 휴게공간에서 잠깐 햇볕을 쬐었다.
책 한 장을 읽고 내려왔는데 마음이 조금 가벼워졌다.

작은 여유를 억지로라도 만들어야겠다는 생각을 했다.''',
  ),
  SeedDiaryEntry(
    title: '커피와 코드',
    mood: DiaryMood.happy,
    content: '''아침에 새로 산 원두로 핸드드립을 했다.
향이 진하게 올라와서 하루를 잘 시작한 느낌.

오후에는 팀에서 논의하던 버그를 잡았는데,
원인은 생각보다 단순한 캐싱 문제였다.
디버깅 로그를 정리해두니 마음이 놓였다.''',
  ),
  SeedDiaryEntry(
    title: '퇴근 후 산책',
    mood: DiaryMood.soso,
    content: '''저녁 먹고 동네 하천을 한 바퀴 돌았다.
바람이 선선하고 강아지들이 많이 뛰어다녔다.

걷다 보니 생각이 정리돼서 내일 할 일을 머릿속으로 순서대로 적어봤다.''',
  ),
  SeedDiaryEntry(
    title: '비 오는 목요일',
    mood: DiaryMood.sad,
    content: '''아침부터 비가 와서 우산을 챙겼다.
젖은 우산 냄새가 사무실을 가득 채워 조금 답답했다.

비가 오면 괜히 감정이 예민해지는 것 같다.
퇴근길 지하철에서 팟캐스트를 들으며 마음을 가라앉혔다.''',
  ),
  SeedDiaryEntry(
    title: null,
    mood: DiaryMood.soso,
    content: '''새벽에 잠이 깨서 물을 마시러 나왔다가 창밖을 봤다.
도심 불빛이 잔잔하게 깜빡이는 걸 한참 바라봤다.

이 시간대의 고요함이 좋아서 침대에 돌아가기 전에
다시 한번 깊게 숨을 들이마셨다.''',
  ),
  SeedDiaryEntry(
    title: '친구와 저녁',
    mood: DiaryMood.happy,
    content: '''오랜만에 대학 친구를 만났다.
수다 떨다 보니 시간이 훌쩍 지나 버렸다.

맛집이라고 해서 간 파스타 집이 의외로 조용해서 좋았다.
헤어질 때 서로 더 자주 보자고 약속.''',
  ),
  SeedDiaryEntry(
    title: '일요일 준비 리스트',
    mood: DiaryMood.soso,
    content: '''주말 동안 미뤄둔 빨래와 청소를 한꺼번에 처리했다.
청소기를 돌리면서 팟캐스트를 틀어놓으니 덜 지루했다.

다음 주 일정도 캘린더에 정리했다. 생각보다 할 일이 많아서
살짝 긴장되지만, 그래도 하나씩 해보자는 마음.''',
  ),
  SeedDiaryEntry(
    title: '작업 몰입의 하루',
    mood: DiaryMood.happy,
    content: '''아침부터 집중이 잘 되는 날이었다.
카페에 앉아 이어폰을 끼고 새 기능 설계를 정리했다.

중간중간 막히는 부분이 있었지만 동료에게 짧게 전화로 확인하고
속도를 낸 덕분에 오후에는 프로토타입까지 만들었다.
집에 와서 쓰러지듯 잠들었다.''',
  ),
];

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  final entries = _manualEntries.isNotEmpty
      ? _manualEntries
      : _generateEntries(_seedCount > 0 ? _seedCount : 12);

  final seeder = _DiarySeeder(GetIt.instance<DiaryUseCases>());
  final result = await seeder.seed(entries);

  debugPrint('--- Diary seeding completed ---');
  debugPrint('  Deleted existing: ${result.deleted}');
  if (result.deleteFailures.isNotEmpty) {
    for (final failure in result.deleteFailures) {
      debugPrint(
        '  Delete failed: ${failure.entryTitle ?? '무제'} -> ${failure.message}',
      );
    }
  }
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
    final purge = await _clearExistingEntries();

    var inserted = 0;
    final insertFailures = <SeedFailure>[];

    for (final entry in entries) {
      final result = await _useCases.create(
        title: entry.title,
        content: entry.content,
        mood: entry.mood,
      );

      result.fold(
        (failure) {
          insertFailures.add(
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

    return SeedResult(
      inserted: inserted,
      deleted: purge.deleted,
      failures: insertFailures,
      deleteFailures: purge.failures,
    );
  }

  Future<_ClearResult> _clearExistingEntries() async {
    const batchSize = 40;
    var cursor = DateTime.now().toUtc();
    var deleted = 0;
    final failures = <SeedFailure>[];

    while (true) {
      final pageResult = await _useCases.fetch(
        limit: batchSize,
        cursor: cursor,
      );
      final page = pageResult.fold(
        (failure) {
          failures.add(
            SeedFailure(
              entryTitle: '목록 조회',
              message: failure.message,
            ),
          );
          return null;
        },
        (pageable) => pageable,
      );

      if (page == null || page.items.isEmpty) {
        break;
      }

      for (final diary in page.items) {
        final result = await _useCases.delete(diary.id);
        result.fold(
          (failure) {
            failures.add(
              SeedFailure(
                entryTitle: diary.title ?? diary.id,
                message: failure.message,
              ),
            );
          },
          (_) => deleted++,
        );

        // Small delay to avoid hammering the DB and storage back-to-back.
        await Future<void>.delayed(const Duration(milliseconds: 40));
      }

      final nextCursor = page.nextCursor;
      if (nextCursor == null) {
        break;
      }
      cursor = nextCursor;
    }

    return _ClearResult(deleted: deleted, failures: failures);
  }
}

class SeedDiaryEntry {
  final String? title;
  final String content;
  final DiaryMood mood;

  const SeedDiaryEntry({
    this.title,
    required this.content,
    this.mood = DiaryMood.soso,
  });
}

class SeedResult {
  final int inserted;
  final int deleted;
  final List<SeedFailure> failures;
  final List<SeedFailure> deleteFailures;

  const SeedResult({
    required this.inserted,
    required this.deleted,
    required this.failures,
    required this.deleteFailures,
  });
}

class SeedFailure {
  final String? entryTitle;
  final String message;

  const SeedFailure({this.entryTitle, required this.message});
}

class _ClearResult {
  final int deleted;
  final List<SeedFailure> failures;

  const _ClearResult({required this.deleted, required this.failures});
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
  final moodOptions = <DiaryMood>[
    DiaryMood.happy,
    DiaryMood.sad,
    DiaryMood.soso,
  ];
  final feelings = <String>[
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
    '점심으로는 간단하게 샐러드를 먹었다. 양이 부족해서 견과류를 조금 더 챙겨 먹었다.',
    '오랜만에 친구와 통화하며 웃을 일이 많았다. 서로 계획을 공유하다 보니 시간이 훌쩍 갔다.',
    '바람이 시원해서 산책하기 딱 좋았다. 뛰어다니는 강아지를 보며 같이 웃었다.',
    '작은 실수가 있었지만 금방 수습했다. 다음에는 체크리스트를 더 자주 들여다봐야겠다.',
    '읽고 있던 책이 절정으로 치달아 손을 놓을 수 없었다. 밑줄을 잔뜩 긋다가 펜 잉크를 다 썼다.',
    '코딩 문제를 해결하고 큰 성취감을 느꼈다. 디버깅 과정을 정리해두니 마음이 후련하다.',
    '고양이가 옆에서 졸고 있어서 마음이 안정됐다. 부드러운 숨소리가 배경음악처럼 느껴졌다.',
    '작업실을 정리했더니 머릿속도 말끔해진 느낌이다. 버릴 물건을 한 번에 치워서 속이 시원했다.',
    '노을이 너무 예뻐서 사진을 잔뜩 찍었다. 하늘 색이 계속 변해서 눈을 떼기 어려웠다.',
    '오늘은 스스로를 칭찬해주고 싶다. 작은 일이라도 끝낼 때마다 박수를 쳐봤다.',
  ];
  final wrapUps = <String>[
    '내일은 조금 더 일찍 일어나 스트레칭부터 해봐야겠다.',
    '짧게라도 일기를 쓰니 마음이 차분해진다.',
    '남은 일은 내일로 넘기고 오늘은 가볍게 쉬어야겠다.',
    '오늘 느꼈던 감정을 잊지 않으려고 메모해둔다.',
    '집에 돌아와 차를 한 잔 타 마시며 하루를 마무리했다.',
  ];

  return List<SeedDiaryEntry>.generate(count, (index) {
    final hasTitle = random.nextBool();
    final title = hasTitle ? titles[random.nextInt(titles.length)] : null;

    final mood = moodOptions[random.nextInt(moodOptions.length)];
    final feeling = feelings[random.nextInt(feelings.length)];
    final detail = details[random.nextInt(details.length)];
    final reflection = details[(random.nextInt(details.length))];
    final wrapUp = wrapUps[random.nextInt(wrapUps.length)];

    final content = StringBuffer()
      ..writeln('Day ${index + 1}')
      ..writeln('오늘은 $feeling.')
      ..writeln()
      ..writeln(detail)
      ..writeln(reflection)
      ..writeln(wrapUp);

    return SeedDiaryEntry(
      title: title,
      content: content.toString(),
      mood: mood,
    );
  });
}
