import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:diary/core/value_objects/error/failure.dart';
import 'package:diary/core/utils/falure_handler.dart';
import 'package:diary/core/extension/logger_extension.dart';
import 'package:diary/core/utils/app_logger.dart';
import 'package:diary/core/constant/constraint.dart';
import 'package:diary/core/value_objects/diary.dart';
import 'package:diary/core/value_objects/pageable.dart';
import 'package:diary/domain/entity/diary_detail_entity.dart';
import 'package:diary/domain/entity/diary_entity.dart';
import 'package:diary/domain/repository/diary_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

part 'scenario/create_diary_entry_usecase.dart';

part 'scenario/delete_diary_entry_usecase.dart';

part 'scenario/fetch_diary_entries_usecase.dart';

part 'scenario/get_diary_entry_usecase.dart';

part 'scenario/update_diary_entry_usecase.dart';

part 'scenario/watch_diary_entries_usecase.dart';

@lazySingleton
class DiaryUseCases with AppLoggerMixIn {
  final DiaryRepository _diaryRepository;

  DiaryUseCases(this._diaryRepository);

  _CreateDiaryEntryUseCase get create =>
      _CreateDiaryEntryUseCase(_diaryRepository, logger: logger);

  _GetDiaryDetailUseCase get getDetail =>
      _GetDiaryDetailUseCase(_diaryRepository, logger: logger);

  _FetchDiariesUseCase get fetch => _FetchDiariesUseCase(_diaryRepository, logger: logger);

  _DeleteDiaryEntryUseCase get delete =>
      _DeleteDiaryEntryUseCase(_diaryRepository, logger: logger);

  _UpdateDiaryEntryUseCase get update =>
      _UpdateDiaryEntryUseCase(_diaryRepository, logger: logger);

  _WatchDiaryEntriesUseCase get watch =>
      _WatchDiaryEntriesUseCase(_diaryRepository, logger: logger);
}
