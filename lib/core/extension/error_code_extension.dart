import 'package:diary/core/constant/error_code.dart';

extension ErrorCodeExtension on ErrorCode {
  String get defaultDescription {
    switch (this) {
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
        return '저장된 데이터를 불러오는 중 문제가 발생했습니다.';
      case ErrorCode.database:
        return '저장된 데이터를 불러오는 중 문제가 발생했습니다.';
      case ErrorCode.storage:
        return '파일을 처리하는 중 문제가 발생했습니다.';
      case ErrorCode.parsing:
        return '데이터 처리 중 오류가 발생했습니다.';
      case ErrorCode.validation:
        return '요청 값이 올바르지 않습니다.';
      case ErrorCode.cancelled:
        return '요청이 취소되었습니다.';
      case ErrorCode.unknown:
        return '알 수 없는 오류가 발생했습니다.';
    }
  }
}
