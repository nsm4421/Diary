# Diary

## delete-user Edge Function
- 생성: `supabase functions new delete-user`
- 코드 위치: `supabase/functions/delete-user/index.ts`
- 로컬 환경 변수: `supabase/.env`에 `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY` 설정
- 로컬 실행: `supabase functions serve`
- 배포 전 비밀키 설정: `supabase secrets set SUPABASE_SERVICE_ROLE_KEY=...`
- 배포: `supabase functions deploy delete-user`
