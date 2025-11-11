import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:diary/core/error/failure.dart';
import 'package:diary/core/value_objects/constraint.dart';
import 'package:diary/core/value_objects/diary.dart';
import 'package:diary/core/value_objects/pageable.dart';
import 'package:diary/domain/entity/diary_detail_entity.dart';
import 'package:diary/domain/entity/diary_entity.dart';
import 'package:diary/domain/repository/diary_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

part 'scenario/create_diary_entry_usecase.dart';

part 'scenario/delete_diary_entry_usecase.dart';

part 'scenario/fetch_diary_entries_usecase.dart';

part 'scenario/get_diary_entry_usecase.dart';

part 'scenario/update_diary_entry_usecase.dart';

part 'scenario/watch_diary_entries_usecase.dart';

@lazySingleton
class DiaryUseCases {
  final DiaryRepository _diaryRepository;

  DiaryUseCases(this._diaryRepository);

  _CreateDiaryEntryUseCase get create =>
      _CreateDiaryEntryUseCase(_diaryRepository);

  _GetDiaryDetailUseCase get getDetail =>
      _GetDiaryDetailUseCase(_diaryRepository);

  _FetchDiariesUseCase get fetch => _FetchDiariesUseCase(_diaryRepository);

  _DeleteDiaryEntryUseCase get delete =>
      _DeleteDiaryEntryUseCase(_diaryRepository);

  _UpdateDiaryEntryUseCase get update =>
      _UpdateDiaryEntryUseCase(_diaryRepository);

  _WatchDiaryEntriesUseCase get watch =>
      _WatchDiaryEntriesUseCase(_diaryRepository);
}
