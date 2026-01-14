import 'package:shared/shared.dart';

class AgendaModel extends BaseModel {
  final String title;
  final String? description;

  AgendaModel({
    required super.id,
    required super.createdAt,
    super.updatedAt,
    required this.title,
    this.description = '',
  });
}
