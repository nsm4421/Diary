import 'package:dartz/dartz.dart';
import 'package:diary/core/error/api/api_error.dart';
import 'package:diary/domain/repository/password_repository.dart';
import 'package:diary/domain/usecase/security/security_usecases.dart';
import 'package:diary/presentation/provider/security/password_setup/password_setup_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mock_logger.dart';

void main() {
  late FakePasswordRepository repository;
  late SecurityUseCases securityUseCases;
  late MockLogger logger;
  late PasswordSetupCubit cubit;

  setUp(() {
    repository = FakePasswordRepository();
    logger = MockLogger();
    securityUseCases = SecurityUseCases(repository)..setLogger(logger);
    cubit = PasswordSetupCubit(securityUseCases);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('init', () {
    test(
      'sets editing status and hasExistingPassword when hash missing',
      () async {
        await cubit.init();

        expect(cubit.state.isStatusEditing, isTrue);
        expect(cubit.state.hasExistingPassword, isFalse);
        expect(cubit.state.errorMessage, isEmpty);
      },
    );

    test('toggles hasExistingPassword when repository returns hash', () async {
      repository.storedHash = 'secure-hash';

      await cubit.init();

      expect(cubit.state.hasExistingPassword, isTrue);
      expect(cubit.state.errorMessage, isEmpty);
    });
  });

  group('setPassword', () {
    test('emits success and updates repository', () async {
      await cubit.init();

      await cubit.setPassword(' 1234 ');

      expect(cubit.state.isStatusSuccess, isTrue);
      expect(cubit.state.hasExistingPassword, isTrue);
      expect(repository.storedHash, isNotNull);
    });

    test('surfaces failure when repository throws', () async {
      repository.saveError = const ApiError(
        code: ApiErrorCode.server,
        message: 'boom',
      );
      await cubit.init();

      await cubit.setPassword('1234');

      expect(cubit.state.isStatusFailure, isTrue);
      expect(cubit.state.errorMessage, isNotEmpty);
    });
  });

  group('clearPassword', () {
    test('emits success and clears repository', () async {
      repository.storedHash = 'secure';
      await cubit.init();

      await cubit.clearPassword('1234');

      expect(cubit.state.isStatusSuccess, isTrue);
      expect(cubit.state.hasExistingPassword, isFalse);
    });

    test('emits failure when repository throws', () async {
      repository.storedHash = 'secure';
      repository.clearError = const ApiError(
        code: ApiErrorCode.server,
        message: 'fail',
      );
      await cubit.init();

      await cubit.clearPassword('1234');

      expect(cubit.state.isStatusFailure, isTrue);
      expect(cubit.state.errorMessage, isNotEmpty);
    });
  });
}

class FakePasswordRepository implements PasswordRepository {
  String? storedHash;
  ApiError? saveError;
  ApiError? fetchError;
  ApiError? clearError;

  @override
  Future<Either<ApiError, Unit>> savePasswordHash(String hash) async {
    if (saveError != null) return Left(saveError!);
    storedHash = hash;
    return const Right(unit);
  }

  @override
  Future<Either<ApiError, String?>> fetchPasswordHash() async {
    if (fetchError != null) return Left(fetchError!);
    return Right(storedHash);
  }

  @override
  Future<Either<ApiError, Unit>> clearPassword() async {
    if (clearError != null) return Left(clearError!);
    storedHash = null;
    return const Right(unit);
  }
}
