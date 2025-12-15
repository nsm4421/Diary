import 'package:diary/domain/entity/base/base_entity.dart';

extension BaseEntityIterableX on Iterable<BaseEntity> {
  DateTime? get leastCreatedAt {
    return isEmpty
        ? null
        : map(
            (e) => e.createdAt,
          ).reduce((prev, curr) => prev.isAfter(curr) ? curr : prev);
  }
}
