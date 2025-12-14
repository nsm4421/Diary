import 'package:shared/shared.dart';

mixin class DiaryMediaUtilMixIn {
  String buildDiaryMediaPath({
    required String userId,
    required String diaryId,
    required String storyId,
    String ext = 'jpg',
  }) {
    final saveFilename = '${genUuid()}.$ext';
    return "$userId/$diaryId/$storyId/$saveFilename";
  }
}
