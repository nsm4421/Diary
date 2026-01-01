import 'package:copy_with_extension/copy_with_extension.dart';

part 'failure.g.dart';

@CopyWith()
class Failure {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  Failure({required this.message, this.error, this.stackTrace});
}
