import 'dart:async';

import 'package:diary/features/auth/model/auth_user_model.dart';
import 'package:diary/features/auth/repository/auth_repository.dart';
import 'package:diary/features/auth/service/auth_failure.dart';
import 'package:diary/features/auth/service/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockLogger extends Mock implements Logger {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockLogger mockLogger;
  late AuthServiceImpl authService;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockLogger = MockLogger();
    authService = AuthServiceImpl(mockAuthRepository, mockLogger);
  });

  group('authUserStream', () {
    test('인증 사용자 스트림을 AuthUserModel로 변환한다', () async {
      // 스트림으로 들어온 Supabase User가 모델로 변환되어 전달되는지 확인한다.
      final controller = StreamController<User?>();
      final supabaseUser = _buildUser(
        id: 'user-1',
        email: 'user1@diary.com',
        username: 'tester',
      );

      when(() => mockAuthRepository.getSupabaseUserStream())
          .thenAnswer((_) => controller.stream);

      final stream = authService.authUserStream;
      final expectation = expectLater(
        stream,
        emitsInOrder([
          isA<AuthUserModel>()
              .having((user) => user.id, 'id', supabaseUser.id)
              .having((user) => user.email, 'email', supabaseUser.email)
              .having((user) => user.username, 'username', 'tester'),
          null,
        ]),
      );

      controller.add(supabaseUser);
      controller.add(null);
      await controller.close();

      await expectation;

      verify(() => mockAuthRepository.getSupabaseUserStream()).called(1);
    });
  });

  group('getCurrentUser', () {
    test('현재 사용자가 있으면 Right로 반환한다', () async {
      // 저장소에서 받은 사용자가 모델로 변환되는지 확인한다.
      final supabaseUser = _buildUser(
        id: 'user-2',
        email: 'current@diary.com',
        username: 'current',
      );

      when(() => mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => supabaseUser);

      final result = await authService.getCurrentUser().run();

      result.match(
        (failure) => fail('Right가 기대되지만 Left가 반환됨: $failure'),
        (user) {
          expect(user, isNotNull);
          expect(user!.id, supabaseUser.id);
          expect(user.email, supabaseUser.email);
          expect(user.username, 'current');
        },
      );
    });

    test('현재 사용자가 없으면 Right(null)을 반환한다', () async {
      // null 케이스를 정상적으로 전달하는지 확인한다.
      when(() => mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => null);

      final result = await authService.getCurrentUser().run();

      result.match(
        (failure) => fail('Right가 기대되지만 Left가 반환됨: $failure'),
        (user) => expect(user, isNull),
      );
    });
  });

  group('signInWithEmail', () {
    test('이메일 로그인은 입력값을 trim해서 전달하고 사용자 정보를 반환한다', () async {
      // 공백이 포함된 입력값을 정리해 저장소에 전달하는지 확인한다.
      final supabaseUser = _buildUser(
        id: 'user-3',
        email: 'login@diary.com',
        username: 'login',
      );

      when(
        () => mockAuthRepository.signInWithEmail(
          email: 'login@diary.com',
          password: 'password123',
        ),
      ).thenAnswer((_) async => supabaseUser);

      final result = await authService
          .signInWithEmail(
            email: '  login@diary.com  ',
            password: '  password123  ',
          )
          .run();

      result.match(
        (failure) => fail('Right가 기대되지만 Left가 반환됨: $failure'),
        (user) {
          expect(user.id, supabaseUser.id);
          expect(user.email, supabaseUser.email);
          expect(user.username, 'login');
        },
      );

      verify(
        () => mockAuthRepository.signInWithEmail(
          email: 'login@diary.com',
          password: 'password123',
        ),
      ).called(1);
    });

    test('이메일 로그인 실패 시 AuthFailure를 반환한다', () async {
      // 저장소에서 예외가 발생하면 실패로 감싸서 반환하는지 확인한다.
      when(
        () => mockAuthRepository.signInWithEmail(
          email: 'fail@diary.com',
          password: 'password123',
        ),
      ).thenThrow(Exception('sign in failed'));

      final result = await authService
          .signInWithEmail(
            email: 'fail@diary.com',
            password: 'password123',
          )
          .run();

      result.match(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, 'sign in failed');
        },
        (_) => fail('Left가 기대되지만 Right가 반환됨'),
      );
    });
  });

  group('signUpWithEmail', () {
    test('이메일 회원가입은 사용자명이 있으면 trim해서 전달한다', () async {
      // 사용자명이 주어질 때 공백 제거 후 전달되는지 확인한다.
      final supabaseUser = _buildUser(
        id: 'user-4',
        email: 'signup@diary.com',
        username: 'newbie',
      );

      when(
        () => mockAuthRepository.signUpWithEmail(
          email: 'signup@diary.com',
          username: 'newbie',
          password: 'password123',
        ),
      ).thenAnswer((_) async => supabaseUser);

      final result = await authService
          .signUpWithEmail(
            email: '  signup@diary.com ',
            clientUsername: '  newbie  ',
            password: '  password123  ',
          )
          .run();

      result.match(
        (failure) => fail('Right가 기대되지만 Left가 반환됨: $failure'),
        (user) {
          expect(user.id, supabaseUser.id);
          expect(user.email, supabaseUser.email);
          expect(user.username, 'newbie');
        },
      );

      verify(
        () => mockAuthRepository.signUpWithEmail(
          email: 'signup@diary.com',
          username: 'newbie',
          password: 'password123',
        ),
      ).called(1);
    });

    test('이메일 회원가입은 사용자명이 비어있으면 null로 전달한다', () async {
      // 빈 사용자명은 null로 치환되어 저장소에 전달되는지 확인한다.
      final supabaseUser = _buildUser(
        id: 'user-5',
        email: 'signup2@diary.com',
        username: 'unknown',
      );

      when(
        () => mockAuthRepository.signUpWithEmail(
          email: 'signup2@diary.com',
          username: null,
          password: 'password123',
        ),
      ).thenAnswer((_) async => supabaseUser);

      final result = await authService
          .signUpWithEmail(
            email: 'signup2@diary.com',
            clientUsername: '',
            password: 'password123',
          )
          .run();

      result.match(
        (failure) => fail('Right가 기대되지만 Left가 반환됨: $failure'),
        (user) => expect(user.id, supabaseUser.id),
      );

      verify(
        () => mockAuthRepository.signUpWithEmail(
          email: 'signup2@diary.com',
          username: null,
          password: 'password123',
        ),
      ).called(1);
    });
  });

  group('signOut', () {
    test('로그아웃 성공 시 Right(void)을 반환한다', () async {
      // 저장소 로그아웃이 성공하면 Right로 반환되는지 확인한다.
      when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});

      final result = await authService.signOut().run();

      result.match(
        (failure) => fail('Right가 기대되지만 Left가 반환됨: $failure'),
        (_) => expect(true, isTrue),
      );

      verify(() => mockAuthRepository.signOut()).called(1);
    });

    test('로그아웃 실패 시 AuthFailure를 반환한다', () async {
      // 저장소 예외가 AuthFailure로 감싸지는지 확인한다.
      when(() => mockAuthRepository.signOut()).thenThrow(Exception('sign out'));

      final result = await authService.signOut().run();

      result.match(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, 'sign out failed');
        },
        (_) => fail('Left가 기대되지만 Right가 반환됨'),
      );
    });
  });
}

User _buildUser({
  String id = 'user-id',
  String username = 'test-username',
  String email = 'user@diary.com',
}) {
  return User(
    id: id,
    appMetadata: const {},
    userMetadata: {'username': username},
    aud: 'authenticated',
    email: email,
    createdAt: DateTime(2024, 1, 1).toIso8601String(),
  );
}
