import 'package:vote/vote.dart';

import '../../../generated/database.dart';

extension AgendasRowExtension on AgendasRow {
  AgendaModel toModel() {
    return AgendaModel(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      title: title,
      description: description,
    );
  }
}
