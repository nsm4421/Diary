import 'package:equatable/equatable.dart';

import 'app_exception.dart';
import 'error_code.dart';

class Failure extends Equatable {
  const Failure({
    required this.code,
    required this.message,
    this.statusCode,
    this.details,
    this.stackTrace,
  });

  final ErrorCode code;
  final String message;
  final int? statusCode;
  final Object? details;
  final StackTrace? stackTrace;

  factory Failure.fromException(AppException exception) {
    return Failure(
      code: exception.code,
      message: exception.message,
      statusCode: exception.statusCode,
      details: exception.details,
      stackTrace: exception.stackTrace,
    );
  }

  const Failure.unknown({
    required String message,
    StackTrace? stackTrace,
    Object? details,
  }) : this(
          code: ErrorCode.unknown,
          message: message,
          stackTrace: stackTrace,
          details: details,
        );

  @override
  List<Object?> get props => [code, message, statusCode, details, stackTrace];
}
