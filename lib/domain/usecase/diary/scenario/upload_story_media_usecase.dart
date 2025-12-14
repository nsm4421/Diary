part of '../diary_usecases.dart';

class _UploadImagesUseCase {
  final DiaryRepository _repository;

  _UploadImagesUseCase(this._repository);

  Future<AppResponse<List<StoryMediaEntity>>> call({
    required String diaryId,
    required String storyId,
    required List<File> files,
  }) async {
    final paths = await _repository
        .uploadImagesOnBucket(diaryId: diaryId, storyId: storyId, files: files)
        .then((res) => res.getOrElse((_) => []));

    return await _repository
        .insertMedia(diaryId: diaryId, styroId: storyId, paths: paths)
        .then((res) => res.toAppResponse());
  }
}
