import 'package:shared/shared.dart';

class Failure {
  Failure({
    required this.code,
    required this.message,
    this.statusCode,
    this.error,
    this.stackTrace,
  });

  factory Failure.fromApiException(ApiException exception) => Failure(
    code: exception.code.name,
    message: exception.message ?? exception.code.description,
    statusCode: exception.statusCode,
    error: exception.error,
    stackTrace: exception.stackTrace,
  );

  final String code;
  final String message;
  final int? statusCode;
  final Object? error;
  final StackTrace? stackTrace;
}
