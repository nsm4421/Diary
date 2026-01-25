import 'package:auth/auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_repository/src/features/auth/auth_repository_impl.dart';
import 'package:test/test.dart';

import '../../helpers/mocks.dart';
import '../../helpers/test_helper.dart';

void main() {
  setUpAll(registerTestFallbacks);

  late MockSupabaseClient mockClient;
  late MockGoTrueClient mockAuth;
  late AuthRepositoryImpl repository;

  const email = 'user@example.com';
  const password = 'password123!';
  const username = 'neo';
  const avatarUrl = 'https://example.com/avatar.png';

  User buildUser({
    String userId = 'user-id',
    String? userEmail,
    String? userName,
  }) {
    return User(
      id: userId,
      appMetadata: const {},
      userMetadata: {'username': userName ?? username},
      aud: 'authenticated',
      createdAt: '2024-01-01T00:00:00.000Z',
      updatedAt: '2024-01-02T00:00:00.000Z',
      email: userEmail ?? email,
    );
  }

  Session buildSession(User user) {
    return Session(
      accessToken: 'token',
      tokenType: 'bearer',
      user: user,
    );
  }

  setUp(() {
    mockClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    when(() => mockClient.auth).thenReturn(mockAuth);
    repository = AuthRepositoryImpl(mockClient);
  });

  group('authStream', () {
    test('signedIn은 유저로 매핑되고 signedOut은 null을 방출한다', () async {
      final user = buildUser();
      final session = buildSession(user);
      final stream = Stream<AuthState>.fromIterable([
        AuthState(AuthChangeEvent.signedIn, session),
        const AuthState(AuthChangeEvent.signedOut, null),
      ]);

      when(() => mockAuth.onAuthStateChange).thenAnswer((_) => stream);

      await expectLater(
        repository.authStream,
        emitsInOrder([
          isA<AuthUserModel>()
              .having((m) => m.id, 'id', 'user-id')
              .having((m) => m.email, 'email', email)
              .having((m) => m.username, 'username', username)
              .having(
                (m) => m.createdAt,
                'createdAt',
                DateTime.parse('2024-01-01T00:00:00.000Z'),
              )
              .having(
                (m) => m.updatedAt,
                'updatedAt',
                DateTime.parse('2024-01-02T00:00:00.000Z'),
              ),
          isNull,
        ]),
      );
    });
  });

  group('currentUser', () {
    test('currentUser가 있으면 매핑된 유저를 반환한다', () {
      final user = buildUser(userName: 'trinity');
      when(() => mockAuth.currentUser).thenReturn(user);

      final result = repository.currentUser;

      expect(result, isNotNull);
      expect(result!.id, 'user-id');
      expect(result.email, email);
      expect(result.username, 'trinity');
    });

    test('currentUser가 없으면 null을 반환한다', () {
      when(() => mockAuth.currentUser).thenReturn(null);

      final result = repository.currentUser;

      expect(result, isNull);
    });
  });

  group('signInWithEmail', () {
    test('성공 시 매핑된 유저를 반환한다', () async {
      final user = buildUser();
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

      expect(result, isNotNull);
      expect(result!.email, email);
      verify(
        () => mockAuth.signInWithPassword(email: email, password: password),
      ).called(1);
    });

    test('supabase 에러를 그대로 다시 던진다', () async {
      final exception = Exception('sign in failed');
      when(
        () => mockAuth.signInWithPassword(
          email: email,
          password: password,
        ),
      ).thenThrow(exception);

      await runSilently(
        () => expectLater(
          () => repository.signInWithEmail(email: email, password: password),
          throwsA(same(exception)),
        ),
      );
    });
  });

  group('signUpWithEmail', () {
    test('username을 전달하고 매핑된 유저를 반환한다', () async {
      final user = buildUser();
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

      expect(result, isNotNull);
      expect(result!.username, username);
      verify(
        () => mockAuth.signUp(
          email: email,
          password: password,
          data: any(
            named: 'data',
            that: equals({'username': username}),
          ),
        ),
      ).called(1);
    });

    test('avatarUrl이 있으면 메타데이터에 포함한다', () async {
      final user = buildUser();
      when(
        () => mockAuth.signUp(
          email: email,
          password: password,
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => AuthResponse(user: user));

      await repository.signUpWithEmail(
        email: email,
        username: username,
        password: password,
        avatarUrl: avatarUrl,
      );

      verify(
        () => mockAuth.signUp(
          email: email,
          password: password,
          data: any(
            named: 'data',
            that: equals({'username': username, 'avatar_url': avatarUrl}),
          ),
        ),
      ).called(1);
    });

    test('supabase 에러를 그대로 다시 던진다', () async {
      final exception = Exception('sign up failed');
      when(
        () => mockAuth.signUp(
          email: email,
          password: password,
          data: any(named: 'data'),
        ),
      ).thenThrow(exception);

      await runSilently(
        () => expectLater(
          () => repository.signUpWithEmail(
            email: email,
            username: username,
            password: password,
          ),
          throwsA(same(exception)),
        ),
      );
    });
  });

  group('signOut', () {
    test('global scope로 로그아웃한다', () async {
      when(() => mockAuth.signOut(scope: any(named: 'scope')))
          .thenAnswer((_) async {});

      await repository.signOut();

      verify(() => mockAuth.signOut(scope: SignOutScope.global)).called(1);
    });

    test('supabase 에러를 그대로 다시 던진다', () async {
      final exception = Exception('sign out failed');
      when(() => mockAuth.signOut(scope: any(named: 'scope')))
          .thenThrow(exception);

      await runSilently(
        () => expectLater(
          () => repository.signOut(),
          throwsA(same(exception)),
        ),
      );
    });
  });
}
