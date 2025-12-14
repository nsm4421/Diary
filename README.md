# Diary (Supabase 기반)

Supabase 백엔드를 사용하는 Flutter 일기 앱입니다. 이메일/비밀번호 인증, RLS가 적용된 일기/스토리 테이블, Supabase Storage에 미디어 업로드를 지원합니다.

## 핵심 기능
- Supabase Auth로 이메일/비밀번호 가입·로그인 및 세션 스트림 제공.
- 일기(`diaries`)와 스토리(`stories`) CRUD, 커서 기반 조회.
- 스토리 이미지 업로드: Supabase Storage `story` 버킷에 파일 저장 후 경로 반환.
- DI/상태관리: get_it + injectable, flutter_bloc, AutoRoute 라우팅.
- 공용 모듈: `shared`(에러/Env), `extensions`, `theme`, `supabase_datasource`(데이터 소스).

## 폴더 구조 (요약)
```
lib/
  core/                # DI, 로거, 공통 응답
  domain/              # 엔티티, 리포지토리 인터페이스, 유스케이스
  data/                # 리포지토리 구현, 매퍼 (Supabase 데이터 소스 의존)
  presentation/        # 라우팅, BLoC, 화면/위젯
packages/
  shared/              # ApiException, Envied 환경변수 래퍼 등
  supabase_datasource/ # Auth/DB/Storage 데이터소스 + 스키마 문서
  extensions/, theme/  # 공용 확장, 테마
supabase/              # Supabase CLI 설정(config.toml)
```

## Supabase 스키마 & RLS
- DDL: `packages/supabase_datasource/docs/schema.sql`
- 문서: `packages/supabase_datasource/docs/schema.md`
- RLS 요약: `diaries`는 작성자(`created_by = auth.uid()`)만 select/insert/update, `stories`도 부모 일기의 작성자만 접근/수정 가능.
- 스토리지 버킷: `story`(이미지 업로드 용), 필요 시 `avatar` 등 추가 버킷을 콘솔에서 생성.

## 개발 환경 준비
1. Flutter 3.19+/Dart 3.9, Supabase CLI 설치.
2. 루트에 `.env.local` 생성 (Envied 사용):
   ```
   SUPABASE_API_URL=...
   SUPABASE_PUBLISHABLE_KEY=...
   ```
3. 의존성 설치 & 코드 생성  
   ```bash
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Supabase 스키마 적용  
   - Supabase 대시보드 SQL 에디터에서 `schema.sql` 실행하거나, CLI로 프로젝트에 반영합니다.  
   - Storage 버킷을 콘솔에서 생성합니다(예: `story`는 private 권장).
5. 앱 실행  
   ```bash
   flutter run
   ```

## 빌드/배포 (Android)
- keystore 생성 후 `android/app/key.properties`를 작성하고 `build.gradle`의 `signingConfigs.release`에 연결합니다.  
  빌드: `flutter build appbundle --release`
