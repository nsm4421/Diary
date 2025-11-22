import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:diary/core/value_objects/domain/diary_mood.dart';
import 'package:equatable/equatable.dart';

part 'diary_entity.g.dart';

@CopyWith(copyWithNull: true)
class DiaryEntity extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String date;
  final String? title;
  final String content;
  final DiaryMood mood;

  const DiaryEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.date,
    this.title,
    this.content = '',
    this.mood = DiaryMood.none
  });

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    date,
    title,
    content,
    mood
  ];
}
