import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_datasource/src/auth/auth_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  late _FakeSupabaseClient fakeSupabaseClient;
  late _FakeGoTrueClient fakeAuth;
  late SupabaseAuthDataSource dataSource;

  User _fakeUser({
    String id = 'user-123',
    String email = 'test@example.com',
    String displayName = 'Test User',
  }) {
    final user = User.fromJson({
      'id': id,
      'app_metadata': {'provider': 'email'},
      'user_metadata': {'display_name': displayName},
      'aud': 'authenticated',
      'email': email,
      'created_at': '2024-01-01T00:00:00Z',
    });
    return user!;
  }

  Session _fakeSession(User user) {
    return Session(
      accessToken: 'access-token-${user.id}',
      tokenType: 'bearer',
      user: user,
      expiresIn: 3600,
      refreshToken: 'refresh-token',
    );
  }

  setUp(() {
    fakeAuth = _FakeGoTrueClient();
    fakeSupabaseClient = _FakeSupabaseClient(fakeAuth);
    dataSource = SupabaseAuthDataSourceImpl(fakeSupabaseClient);
  });

  group('SupabaseAuthDataSourceImpl', () {
    group('currentUser', () {
      test('현재 사용자를 모델로 변환한다', () {
        final user = _fakeUser();
        fakeAuth.currentUserResult = user;

        final result = dataSource.currentUser;

        expect(result?.id, user.id);
        expect(result?.email, user.email);
        expect(result?.displayName, user.userMetadata?['display_name']);
      });
    });

    group('authStream', () {
      test('인증 상태 변경 시 매핑된 유저를 스트림으로 전달한다', () async {
        final user = _fakeUser(displayName: 'Stream User');
        final session = _fakeSession(user);
        fakeAuth.authStateStream =
            Stream.value(AuthState(AuthChangeEvent.signedIn, session));

        final result = await dataSource.authStream.first;

        expect(result, isNotNull);
        expect(result!.id, user.id);
        expect(result.email, user.email);
        expect(result.displayName, 'Stream User');
      });
    });

    group('signInWithPassword', () {
      test('GoTrue 호출 후 반환 유저를 매핑한다', () async {
        final user = _fakeUser(
          email: 'signin@test.com',
          displayName: 'Sign In',
        );
        fakeAuth.signInResponse = AuthResponse(user: user);

        final result = await dataSource.signInWithPassword(
          email: 'signin@test.com',
          password: 'secret',
        );

        expect(result?.id, user.id);
        expect(result?.displayName, 'Sign In');
        expect(fakeAuth.lastSignInEmail, 'signin@test.com');
        expect(fakeAuth.lastSignInPassword, 'secret');
      });
    });

    group('signUpWithPassword', () {
      test('프로필 메타데이터를 전달하고 유저를 매핑한다', () async {
        final user = _fakeUser(
          email: 'new@test.com',
          displayName: 'New User',
        );
        fakeAuth.signUpResponse = AuthResponse(user: user);

        final result = await dataSource.signUpWithPassword(
          email: 'new@test.com',
          password: 'password123',
          displayName: 'New User',
          avatarUrl: 'https://example.com/avatar.png',
          bio: 'bio text',
        );

        final capturedMetadata = fakeAuth.lastSignUpMetadata;

        expect(capturedMetadata?['display_name'], 'New User');
        expect(
          capturedMetadata?['avatar_url'],
          'https://example.com/avatar.png',
        );
        expect(capturedMetadata?['bio'], 'bio text');
        expect(result?.id, user.id);
        expect(result?.displayName, 'New User');
      });
    });

    group('signOut', () {
      test('기본 local scope로 위임 호출한다', () async {
        await dataSource.signOut();

        expect(fakeAuth.lastSignOutScope, SignOutScope.local);
      });
    });

    group('setUserAttribute', () {
      test('display_name 메타데이터를 업데이트하고 유저를 매핑한다', () async {
        final user = _fakeUser(displayName: 'Updated Name');
        fakeAuth.updateUserResponse = UserResponse.fromJson(user.toJson());

        final result =
            await dataSource.setUserAttribute(displayName: 'Updated Name');

        expect(fakeAuth.lastUserAttributes?.data,
            {'display_name': 'Updated Name'});
        expect(result?.displayName, 'Updated Name');
      });
    });
  });
}

class _FakeSupabaseClient extends Fake implements SupabaseClient {
  _FakeSupabaseClient(this.authClient);

  final GoTrueClient authClient;

  @override
  GoTrueClient get auth => authClient;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeGoTrueClient extends Fake implements GoTrueClient {
  User? currentUserResult;
  Stream<AuthState> authStateStream = const Stream<AuthState>.empty();
  AuthResponse? signInResponse;
  AuthResponse? signUpResponse;
  UserResponse? updateUserResponse;

  String? lastSignInEmail;
  String? lastSignInPassword;
  String? lastSignUpEmail;
  String? lastSignUpPassword;
  Map<String, dynamic>? lastSignUpMetadata;
  SignOutScope? lastSignOutScope;
  UserAttributes? lastUserAttributes;

  @override
  Stream<AuthState> get onAuthStateChange => authStateStream;

  @override
  User? get currentUser => currentUserResult;

  @override
  Future<AuthResponse> signInWithPassword({
    String? email,
    String? phone,
    required String password,
    String? captchaToken,
  }) async {
    lastSignInEmail = email;
    lastSignInPassword = password;
    return signInResponse ?? AuthResponse(user: currentUserResult);
  }

  @override
  Future<AuthResponse> signUp({
    String? email,
    String? phone,
    required String password,
    String? emailRedirectTo,
    Map<String, dynamic>? data,
    String? captchaToken,
    OtpChannel channel = OtpChannel.sms,
  }) async {
    lastSignUpEmail = email;
    lastSignUpPassword = password;
    lastSignUpMetadata = data;
    return signUpResponse ?? AuthResponse(user: currentUserResult);
  }

  @override
  Future<void> signOut({SignOutScope scope = SignOutScope.local}) async {
    lastSignOutScope = scope;
  }

  @override
  Future<UserResponse> updateUser(
    UserAttributes attributes, {
    String? emailRedirectTo,
  }) async {
    lastUserAttributes = attributes;
    return updateUserResponse ??
        UserResponse.fromJson(currentUserResult?.toJson() ?? {});
  }

  }
