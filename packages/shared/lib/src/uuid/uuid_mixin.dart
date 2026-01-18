import 'package:uuid/uuid.dart';

mixin class UuidMixIn {
  String genUuid() {
    return Uuid().v4();
  }
}
