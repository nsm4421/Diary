import 'package:diary/core/constant/api_error_code.dart';
import 'package:equatable/equatable.dart';

class ApiError extends Equatable {
  const ApiError({required this.code, required this.message, this.details});

  final ApiErrorCode code;
  final String message;
  final Object? details;

  @override
  List<Object?> get props => [code, message, details];
}
