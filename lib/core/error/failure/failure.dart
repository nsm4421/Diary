import 'package:dartz/dartz.dart';
import 'package:diary/core/error/constant/error_code_extension.dart';
import 'package:equatable/equatable.dart';

import '../constant/error_code.dart';

class Failure extends Equatable {
  const Failure({
    required this.code,
    required this.description,
    this.details,
    this.stackTrace,
  });

  final ErrorCode code;
  final String description;
  final Object? details;
  final StackTrace? stackTrace;

  String get message => description;

  Either<Failure, T> toLeft<T>() => Left(this);

  const Failure.unknown({
    String description = 'Unknown error occurred.',
    StackTrace? stackTrace,
    Object? details,
  }) : this(
         code: ErrorCode.unknown,
         description: description,
         stackTrace: stackTrace,
         details: details,
       );

  factory Failure.validation(String description) {
    return Failure(code: ErrorCode.validation, description: description);
  }

  factory Failure.fromCode(
    ErrorCode code, {
    String? description,
    int? statusCode,
    Object? details,
    StackTrace? stackTrace,
  }) {
    return Failure(
      code: code,
      description: description ?? code.defaultDescription,
      details: details,
      stackTrace: stackTrace,
    );
  }

  @override
  List<Object?> get props => [code, description, details, stackTrace];
}
