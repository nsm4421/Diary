## Supabase schema overview

This document mirrors the current DDL in `schema.sql` for the Supabase instance used by the app.

### Extensions
- `pgcrypto` (for `gen_random_uuid()`)

### Functions & triggers
- `public.set_updated_at()`  
  - Before-update trigger helper that stamps `updated_at` with `now()`.  
  - Applied to: `public.profiles`, `public.diaries`, `public.stories`.
- `public.create_profile_for_new_user()`  
  - After-insert trigger on `auth.users` (`on_auth_user_created`) that creates a profile record using `raw_user_meta_data.display_name` when present.  
  - Note: the function currently inserts into an `avatar_url` column that is **not** defined on `public.profiles`; adjust the table or function to keep them in sync.

### Tables

#### public.profiles
| column       | type        | constraints                                     | default    |
|--------------|-------------|-------------------------------------------------|------------|
| id           | uuid        | primary key; references `auth.users(id)` cascade | —          |
| display_name | text        | not null                                        | —          |
| created_at   | timestamptz | not null                                        | `now()`    |
| updated_at   | timestamptz | not null                                        | `now()`    |

Triggers: `tg_profile_set_updated_at` (before update) via `set_updated_at()`. Profiles are also auto-created after a new auth user via `on_auth_user_created`.

#### public.diaries
| column     | type        | constraints                                           | default         |
|------------|-------------|-------------------------------------------------------|-----------------|
| id         | uuid        | primary key                                           | `gen_random_uuid()` |
| title      | text        | nullable                                              | —               |
| created_by | uuid        | not null; references `auth.users(id)` cascade         | —               |
| created_at | timestamptz | not null                                              | `now()`         |
| updated_at | timestamptz | not null                                              | `now()`         |
| delete_at  | timestamptz | soft delete marker                                    | —               |

Triggers: `tg_diary_set_updated_at` (before update) via `set_updated_at()`.

#### public.stories
| column      | type        | constraints                                                       | default             |
|-------------|-------------|-------------------------------------------------------------------|---------------------|
| id          | uuid        | primary key                                                       | `gen_random_uuid()` |
| diary_id    | uuid        | not null; references `public.diaries(id)` cascade                 | —                   |
| sequence    | int         | not null; unique together with `diary_id`                         | `0`                 |
| description | text        | not null                                                          | —                   |
| media       | text[]      | not null                                                          | `{}`                |
| created_at  | timestamptz | not null                                                          | `now()`             |
| updated_at  | timestamptz | not null                                                          | `now()`             |
| delete_at   | timestamptz | soft delete marker                                                | —                   |

Triggers: `tg_story_set_updated_at` (before update) via `set_updated_at()`.
