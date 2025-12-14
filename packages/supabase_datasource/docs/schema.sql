-- required for gen_random_uuid()
create extension if not exists "pgcrypto";

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

-- rename legacy tables if they still exist
do $$
begin
  if to_regclass('public.stories') is not null
     and to_regclass('public.diary_story') is null then
    execute 'alter table public.stories rename to diary_story';
  end if;

  if to_regclass('public.diary_media') is not null
     and to_regclass('public.story_media') is null then
    execute 'alter table public.diary_media rename to story_media';
  end if;
end $$;

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

-- public.diary_story
create table if not exists public.diary_story (
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

drop trigger if exists tg_story_set_updated_at on public.diary_story;
drop trigger if exists tg_diary_story_set_updated_at on public.diary_story;
create trigger tg_diary_story_set_updated_at
before update on public.diary_story
for each row
execute procedure public.set_updated_at();

-- public.story_media
create table if not exists public.story_media (
  id uuid primary key default gen_random_uuid(),
  created_by uuid not null references auth.users (id) on delete cascade,
  diary_id uuid not null references public.diaries (id) on delete cascade,
  story_id uuid not null references public.diary_story (id) on delete cascade,
  sequence int not null default 0,
  filename uuid not null,
  extension text not null,
  path text not null unique,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  unique (diary_id, story_id, sequence)
);

drop trigger if exists tg_diary_media_set_updated_at on public.story_media;
drop trigger if exists tg_story_media_set_updated_at on public.story_media;
create trigger tg_story_media_set_updated_at
before update on public.story_media
for each row
execute procedure public.set_updated_at();

alter table public.story_media
  alter column filename type uuid using filename::uuid;

alter table public.story_media
  add column if not exists extension text default '' not null;

-- views
drop view if exists public.diaries_view;
drop view if exists public.diary_list_view;
create or replace view public.diary_list_view as
select
  d.id,
  d.title,
  d.created_by,
  d.created_at,
  d.updated_at,
  d.delete_at as deleted_at,
  coalesce((
    select count(*)
    from public.diary_story s
    where s.diary_id = d.id
      and s.delete_at is null
  ), 0) as story_count
from public.diaries d
where d.delete_at is null;

drop view if exists public.diary_detail_view;
create or replace view public.diary_detail_view as
with story_media as (
  select
    s.id,
    s.diary_id,
    s.sequence,
    s.description,
    s.created_at,
    s.updated_at,
    s.delete_at,
  coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', m.id,
        'created_at', m.created_at,
        'updated_at', m.updated_at,
        'deleted_at', m.deleted_at,
        'created_by', m.created_by,
        'diary_id', m.diary_id,
        'story_id', m.story_id,
        'sequence', m.sequence,
        'filename', m.filename,
        'extension', m.extension,
        'path', m.path
      )
      order by m.sequence
    ) filter (where m.id is not null),
    '[]'::jsonb
  ) as media
  from public.diary_story s
  left join public.story_media m
    on m.story_id = s.id
   and m.deleted_at is null
  where s.delete_at is null
  group by s.id, s.diary_id, s.sequence, s.description, s.created_at, s.updated_at, s.delete_at
)
select
  d.id,
  d.title,
  d.created_by,
  d.created_at,
  d.updated_at,
  d.delete_at as deleted_at,
  coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', sm.id,
        'sequence', sm.sequence,
        'description', sm.description,
        'created_at', sm.created_at,
        'updated_at', sm.updated_at,
        'deleted_at', sm.delete_at,
        'created_by', d.created_by,
        'media', sm.media
      )
      order by sm.sequence
    ) filter (where sm.id is not null),
    '[]'::jsonb
  ) as stories
from public.diaries d
left join story_media sm on sm.diary_id = d.id
where d.delete_at is null
group by d.id, d.title, d.created_by, d.created_at, d.updated_at, d.delete_at;

-- RLS: diaries (owner-only)
alter table public.diaries enable row level security;
drop policy if exists diaries_select_owner on public.diaries;
create policy diaries_select_owner on public.diaries
for select using (created_by = auth.uid());

drop policy if exists diaries_insert_owner on public.diaries;
create policy diaries_insert_owner on public.diaries
for insert with check (created_by = auth.uid());

drop policy if exists diaries_update_owner on public.diaries;
create policy diaries_update_owner on public.diaries
for update using (created_by = auth.uid()) with check (created_by = auth.uid());

-- RLS: diary_story (owner-only via parent diary)
alter table public.diary_story enable row level security;
drop policy if exists stories_select_owner on public.diary_story;
create policy stories_select_owner on public.diary_story
for select using (
  exists (
    select 1 from public.diaries d
    where d.id = diary_id and d.created_by = auth.uid()
  )
);

drop policy if exists stories_insert_owner on public.diary_story;
create policy stories_insert_owner on public.diary_story
for insert with check (
  exists (
    select 1 from public.diaries d
    where d.id = diary_id and d.created_by = auth.uid()
  )
);

drop policy if exists stories_update_owner on public.diary_story;
create policy stories_update_owner on public.diary_story
for update using (
  exists (
    select 1 from public.diaries d
    where d.id = diary_id and d.created_by = auth.uid()
  )
) with check (
  exists (
    select 1 from public.diaries d
    where d.id = diary_id and d.created_by = auth.uid()
  )
);

-- RLS: story_media (owner-only via parent diary)
alter table public.story_media enable row level security;
drop policy if exists diary_media_select_owner on public.story_media;
create policy diary_media_select_owner on public.story_media
for select using (
  created_by = auth.uid()
  and exists (
    select 1 from public.diaries d
    where d.id = diary_id and d.created_by = auth.uid()
  )
);

drop policy if exists diary_media_insert_owner on public.story_media;
create policy diary_media_insert_owner on public.story_media
for insert with check (
  created_by = auth.uid()
  and exists (
    select 1 from public.diaries d
    where d.id = diary_id and d.created_by = auth.uid()
  )
);

drop policy if exists diary_media_update_owner on public.story_media;
create policy diary_media_update_owner on public.story_media
for update using (
  created_by = auth.uid()
  and exists (
    select 1 from public.diaries d
    where d.id = diary_id and d.created_by = auth.uid()
  )
) with check (
  created_by = auth.uid()
  and exists (
    select 1 from public.diaries d
    where d.id = diary_id and d.created_by = auth.uid()
  )
);

-- Storage: diary_media bucket (private)
insert into storage.buckets (id, name, public)
values ('diary_media', 'diary_media', false)
on conflict (id) do nothing;

drop policy if exists diary_media_storage_select on storage.objects;
create policy diary_media_storage_select on storage.objects
for select using (
  bucket_id = 'diary_media'
  and owner = auth.uid()
  and name like auth.uid()::text || '/%'
);

drop policy if exists diary_media_storage_insert on storage.objects;
create policy diary_media_storage_insert on storage.objects
for insert with check (
  bucket_id = 'diary_media'
  and owner = auth.uid()
  and name like auth.uid()::text || '/%'
);

drop policy if exists diary_media_storage_delete on storage.objects;
create policy diary_media_storage_delete on storage.objects
for delete using (
  bucket_id = 'diary_media'
  and owner = auth.uid()
  and name like auth.uid()::text || '/%'
);
