import 'dart:io';

import 'package:diary/core/response/app_response.dart';
import 'package:diary/domain/entity/diary/diary_entity.dart';
import 'package:diary/domain/entity/diary/story_entity.dart';
import 'package:diary/domain/entity/diary/story_media_entity.dart';
import 'package:diary/domain/repository/diary_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

part 'scenario/create_diary_usecase.dart';

part 'scenario/create_story_usecase.dart';

part 'scenario/delete_diary_usecase.dart';

part 'scenario/delete_story_usecase.dart';

part 'scenario/fetch_diaries_usecase.dart';

part 'scenario/upload_story_media_usecase.dart';

part 'scenario/fetch_stories_usecase.dart';

part 'scenario/delete_story_media_usecase.dart';

@lazySingleton
class DiaryUseCases {
  final DiaryRepository _repository;

  DiaryUseCases(this._repository);

  /// Diary
  _CreateDiaryUseCase get createDiary => _CreateDiaryUseCase(_repository);

  _FetchDiariesUseCase get fetchDiaries => _FetchDiariesUseCase(_repository);

  _DeleteDiaryUseCase get deleteDiary => _DeleteDiaryUseCase(_repository);

  /// Story
  _CreateStoryUseCase get createStory => _CreateStoryUseCase(_repository);

  _FetchStoriesUseCase get fetchStories => _FetchStoriesUseCase(_repository);

  _DeleteStoryUseCase get deleteStory => _DeleteStoryUseCase(_repository);

  /// Images
  _UploadImagesUseCase get uploadImages => _UploadImagesUseCase(_repository);

  _DeleteImagesUseCase get deleteImages => _DeleteImagesUseCase(_repository);
}
