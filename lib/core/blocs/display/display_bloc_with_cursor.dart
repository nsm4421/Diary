import '../../value_objects/base_model.dart';
import 'display_bloc.dart';

// Cursor Type : DateTime
abstract class DisplayBlocWithDateTimeCursor<E extends BaseModel>
    extends DisplayBloc<E, DateTime> {
  @override
  String idOf(E item) => item.id;

  @override
  DateTime getCursor([List<E>? items]) {
    if (items == null || items.isEmpty) {
      return DateTime.now().toUtc();
    }
    return items
        .map((e) => e.createdAt)
        .reduce((a, b) => a.isBefore(b) ? a : b);
  }
}
