import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

const int kDiaryEntryMaxContentLength = 5000;
const int kDiaryEntryMaxTitleLength = 30;

@CopyWith(copyWithNull: true)
class DiaryEntity extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String date;
  final bool isTemp;
  final String? title;
  final String content;

  const DiaryEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.date,
    this.isTemp = false,
    this.title,
    this.content = '',
  });

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    date,
    isTemp,
    title,
    content,
  ];
}
