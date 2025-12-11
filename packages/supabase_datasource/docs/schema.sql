-- required for gen_random_uuid()
create extension if not exists "pgcrypto";

-- public.profiles
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- keep updated_at fresh on write
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists tg_profile_set_updated_at on public.profiles;
create trigger tg_profile_set_updated_at
before update on public.profiles
for each row
execute procedure public.set_updated_at();

--- auto-insert profile after user signup
create or replace function public.create_profile_for_new_user()
returns trigger
language plpgsql
as $$
declare
  meta jsonb := coalesce(new.raw_user_meta_data, '{}'::jsonb);
begin
  insert into public.profiles (id, display_name, avatar_url)
  values (
    new.id,
    nullif(meta ->> 'display_name', ''),
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row
execute procedure public.create_profile_for_new_user();

-- public.diaries
create table if not exists public.diaries (
  id uuid primary key default gen_random_uuid(),
  title text,
  created_by uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  delete_at timestamptz
);

drop trigger if exists tg_diary_set_updated_at on public.diaries;
create trigger tg_diary_set_updated_at
before update on public.diaries
for each row
execute procedure public.set_updated_at();

-- public.stories
create table if not exists public.stories (
  id uuid primary key default gen_random_uuid(),
  diary_id uuid not null references public.diaries (id) on delete cascade,
  sequence int not null default 0,
  description text not null,
  media text[] not null default '{}',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  delete_at timestamptz,
  unique(diary_id, sequence)
);

drop trigger if exists tg_story_set_updated_at on public.stories;
create trigger tg_story_set_updated_at
before update on public.stories
for each row
execute procedure public.set_updated_at();