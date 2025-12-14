## Supabase 스키마 개요

`docs/schema.sql`에 정의된 최신 DDL을 요약합니다.

### 확장
- `pgcrypto` (`gen_random_uuid()`용)

### 함수 & 트리거
- `public.set_updated_at()`  
  - `updated_at`를 `now()`로 덮어쓰는 before-update 트리거 헬퍼.  
  - 적용 대상: `public.diaries`, `public.diary_story`, `public.story_media`.

### 테이블

#### public.diaries
| column     | type        | constraints                                           | default             |
|------------|-------------|-------------------------------------------------------|---------------------|
| id         | uuid        | primary key                                           | `gen_random_uuid()` |
| title      | text        | nullable                                              | —                   |
| created_by | uuid        | not null; references `auth.users(id)` cascade         | —                   |
| created_at | timestamptz | not null                                              | `now()`             |
| updated_at | timestamptz | not null                                              | `now()`             |
| delete_at  | timestamptz | soft delete marker                                    | —                   |

트리거: `tg_diary_set_updated_at` (before update) via `set_updated_at()`.  
RLS: select/insert/update 모두 `created_by = auth.uid()`일 때만 허용.

#### public.diary_story
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

트리거: `tg_diary_story_set_updated_at` (before update) via `set_updated_at()`.  
RLS: 부모 `diaries`가 현재 사용자(`auth.uid()`)인 경우에만 select/insert/update 허용.

#### public.story_media
| column     | type        | constraints                                                       | default             |
|------------|-------------|-------------------------------------------------------------------|---------------------|
| id         | uuid        | primary key                                                       | `gen_random_uuid()` |
| created_by | uuid        | not null; references `auth.users(id)` cascade                      | —                   |
| diary_id   | uuid        | not null; references `public.diaries(id)` cascade                 | —                   |
| story_id   | uuid        | not null; references `public.diary_story(id)` cascade             | —                   |
| sequence   | int         | not null; unique together with `diary_id` and `story_id`          | `0`                 |
| path       | text        | not null; unique                                                  | —                   |
| created_at | timestamptz | not null                                                          | `now()`             |
| updated_at | timestamptz | not null                                                          | `now()`             |
| deleted_at | timestamptz | soft delete marker                                                | —                   |

트리거: `tg_story_media_set_updated_at` (before update) via `set_updated_at()`.  
RLS: `created_by = auth.uid()`이면서 부모 일기(`diary_id`)도 동일 소유자일 때만 select/insert/update 허용.

### 뷰
- `public.diary_list_view`  
  - 삭제되지 않은(`delete_at is null`) 내가 쓴 일기만 노출 (기본 테이블 RLS를 그대로 따름).  
  - 컬럼: `id`, `title`, `created_by`, `created_at`, `updated_at`, `deleted_at`(`delete_at`의 별칭), `story_count`(삭제되지 않은 스토리 개수).
- `public.diary_detail_view`  
  - 삭제되지 않은 일기만 노출하며, 각 일기의 스토리와 스토리별 미디어를 JSON 배열로 포함.  
  - 스토리는 `sequence` 순으로 정렬되어 집계되고, 스토리/미디어 모두 soft-delete 대상(`delete_at` 또는 `deleted_at`)은 제외.  
  - 스토리 객체 필드: `id`, `sequence`, `description`, `created_at`, `updated_at`, `deleted_at`, `created_by`(일기 작성자), `media`(배열).  
  - 미디어 객체 필드: `id`, `created_at`, `updated_at`, `deleted_at`, `created_by`, `diary_id`, `story_id`, `sequence`, `path` (미디어는 `sequence` 순으로 정렬).

### Storage

#### Bucket: `diary_media` (private)
- 경로 규칙: `[user-id]/[diary-id]/[story-id]/...` (모든 파일은 요청 사용자의 UUID 하위에 저장).
- 정책: `bucket_id = 'diary_media'`, `owner = auth.uid()`, `name`이 `auth.uid()/`로 시작할 때만 select/insert/delete 허용.

### Row-level security
- Diaries: 소유자만 select/insert/update 가능 (`created_by = auth.uid()`).
- Diary stories: 부모 `diaries`의 `created_by`가 현재 사용자일 때만 select/insert/update 가능.
- Story media: `created_by = auth.uid()`이고 부모 일기도 같은 사용자일 때 select/insert/update 가능.
- Storage (`diary_media` 버킷): 소유자 폴더(`auth.uid()/`) 아래 객체만 select/insert/delete 가능.
