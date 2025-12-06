# Supabase 스키마 요약

`packages/supabase_datasource/docs/schema.sql`에 포함된 쿼리를 설명합니다. SQL을 그대로 실행하면 됩니다.

## 1) `public.profiles` 테이블

사용자 프로필 저장용 테이블입니다. `auth.users.id`를 기본 키로 두고, 사용자 삭제 시 함께 삭제되도록 `ON DELETE CASCADE`를 설정했습니다.

```sql
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  avatar_url text,
  bio text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
```

### updated_at 자동 갱신 트리거

```sql
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists tg_set_updated_at on public.profiles;
create trigger tg_set_updated_at
before update on public.profiles
for each row
execute procedure public.set_updated_at();
```

## 2) 회원 가입 시 프로필 자동 생성 트리거

`auth.users`에 새로운 유저가 삽입되면 동일한 `id`와 `email`로 `public.profiles`에 기본 프로필을 생성합니다. 이미 있으면 무시합니다.

```sql
create or replace function public.create_profile_for_new_user()
returns trigger
language plpgsql
as $$
begin
  insert into public.profiles (id, email)
  values (new.id, new.email)
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row
execute procedure public.create_profile_for_new_user();
```
