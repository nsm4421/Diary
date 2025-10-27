import 'package:dartz/dartz.dart';
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

  Either<Failure, T> toLeft<T>() => Left(this);

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

  factory Failure.validation(String message) {
    return Failure(code: ErrorCode.validation, message: message);
  }

  factory Failure.fromCode(
    ErrorCode code, {
    String? message,
    int? statusCode,
    Object? details,
    StackTrace? stackTrace,
  }) {
    return Failure(
      code: code,
      message: message ?? _defaultMessageFor(code),
      statusCode: statusCode,
      details: details,
      stackTrace: stackTrace,
    );
  }

  Failure withFriendlyMessage() {
    if (code == ErrorCode.validation) {
      return this;
    }
    final friendly = _defaultMessageFor(code);
    if (friendly.isEmpty || friendly == message) {
      return this;
    }
    return Failure(
      code: code,
      message: friendly,
      statusCode: statusCode,
      details: details,
      stackTrace: stackTrace,
    );
  }

  static String _defaultMessageFor(ErrorCode code) {
    switch (code) {
      case ErrorCode.badRequest:
        return '잘못된 요청입니다.';
      case ErrorCode.unauthorized:
        return '인증이 필요합니다.';
      case ErrorCode.forbidden:
        return '접근 권한이 없습니다.';
      case ErrorCode.notFound:
        return '요청한 데이터를 찾을 수 없습니다.';
      case ErrorCode.conflict:
        return '이미 처리된 요청입니다.';
      case ErrorCode.server:
        return '서버에서 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
      case ErrorCode.network:
        return '네트워크 연결을 확인해주세요.';
      case ErrorCode.timeout:
        return '요청 시간이 초과되었습니다. 잠시 후 다시 시도해주세요.';
      case ErrorCode.cache:
      case ErrorCode.database:
      case ErrorCode.storage:
        return '저장된 데이터를 불러오는 중 문제가 발생했습니다.';
      case ErrorCode.parsing:
        return '데이터 처리 중 오류가 발생했습니다.';
      case ErrorCode.cancelled:
        return '요청이 취소되었습니다.';
      case ErrorCode.validation:
        return '';
      case ErrorCode.unknown:
      default:
        return '알 수 없는 오류가 발생했습니다.';
    }
  }

  @override
  List<Object?> get props => [code, message, statusCode, details, stackTrace];
}
