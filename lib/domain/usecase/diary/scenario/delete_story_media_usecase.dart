part of '../diary_usecases.dart';

class _DeleteImagesUseCase {
  final DiaryRepository _repository;

  _DeleteImagesUseCase(this._repository);

  Future<AppResponse<void>> call({
    required String diaryId,
    required String storyId,
    required List<int> sequences,
  }) async {
    final deleteMediaRes = await _repository.deleteMedia(
      diaryId: diaryId,
      storyId: storyId,
      sequences: sequences,
    );
    final paths = deleteMediaRes.getOrElse((_) => []);

    if (paths.isNotEmpty) {
      await _repository.insertMedia(
        diaryId: diaryId,
        styroId: storyId,
        paths: paths,
      );
    }

    return deleteMediaRes.toAppResponse();
  }
}
