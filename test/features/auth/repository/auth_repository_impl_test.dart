import 'dart:async';

import 'package:diary/features/auth/repository/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

void main() {
  late MockSupabaseClient mockClient;
  late MockGoTrueClient mockAuth;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    when(() => mockClient.auth).thenReturn(mockAuth);
    repository = AuthRepositoryImpl(mockClient);
  });

  test('인증 상태 스트림을 사용자 스트림으로 변환한다', () async {
    // 인증 상태 이벤트를 직접 흘려보내기 위해 컨트롤러를 사용한다.
    final controller = StreamController<AuthState>();
    final sessionUser = _buildUser(
      username: 'session-user',
      email: 'session@diary.com',
    );
    final currentUser = _buildUser(
      username: 'current-user',
      email: 'current@diary.com',
    );
    final session = Session(
      accessToken: 'access-token',
      tokenType: 'bearer',
      user: sessionUser,
    );

    when(() => mockAuth.onAuthStateChange).thenAnswer((_) => controller.stream);
    when(() => mockAuth.currentUser).thenReturn(currentUser);

    final stream = repository.getSupabaseUserStream();

    // signedIn -> session.user, userUpdated -> currentUser, signedOut -> null
    final expectation = expectLater(
      stream,
      emitsInOrder([sessionUser, currentUser, null]),
    );

    controller.add(AuthState(AuthChangeEvent.signedIn, session));
    controller.add(const AuthState(AuthChangeEvent.userUpdated, null));
    controller.add(const AuthState(AuthChangeEvent.signedOut, null));
    await controller.close();

    await expectation;

    verify(() => mockAuth.onAuthStateChange).called(1);
  });

  test('현재 사용자를 반환한다', () async {
    // auth.currentUser를 그대로 반환하는지 확인한다.
    final user = _buildUser(username: 'tester');
    when(() => mockAuth.currentUser).thenReturn(user);

    final result = await repository.getCurrentUser();

    expect(result, user);
    verify(() => mockAuth.currentUser).called(1);
  });

  test('이메일 회원가입 시 사용자 정보를 반환한다', () async {
    // 회원가입 요청 시 user가 반환되면 그대로 전달되는지 확인한다.
    const username = 'tester';
    const password = 'password123';
    const email = 'nsm4421@naver.com';
    final user = _buildUser(username: username);

    when(
      () => mockAuth.signUp(
        email: email,
        password: password,
        data: any(named: 'data'),
      ),
    ).thenAnswer((_) async => AuthResponse(user: user));

    final result = await repository.signUpWithEmail(
      email: email,
      username: username,
      password: password,
    );

    expect(result, user);

    final capturedData = verify(
      () => mockAuth.signUp(
        email: email,
        password: password,
        data: captureAny(named: 'data'),
      ),
    ).captured.single as Map<String, dynamic>?;

    expect(capturedData, isNotNull);
    expect(capturedData, containsPair('username', username));
  });

  test('이메일 로그인 시 사용자 정보를 반환한다', () async {
    // 로그인 성공 시 user가 반환되는지 확인한다.
    const email = 'nsm4421@naver.com';
    const password = 'password123';
    final user = _buildUser(email: email);

    when(
      () => mockAuth.signInWithPassword(
        email: email,
        password: password,
      ),
    ).thenAnswer((_) async => AuthResponse(user: user));

    final result = await repository.signInWithEmail(
      email: email,
      password: password,
    );

    expect(result, user);
    verify(
      () => mockAuth.signInWithPassword(
        email: email,
        password: password,
      ),
    ).called(1);
  });
}

User _buildUser({
  String username = 'test-username',
  String email = 'nsm4421@naver.com',
}) {
  return User(
    id: 'user-id',
    appMetadata: const {},
    userMetadata: {'username': username},
    aud: 'authenticated',
    email: email,
    createdAt: DateTime(2024, 1, 1).toIso8601String(),
  );
}
