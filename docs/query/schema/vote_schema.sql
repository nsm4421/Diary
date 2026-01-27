CREATE TABLE IF NOT EXISTS public.agendas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  created_by uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id),
  -- 목록 조회 성능을 위한 카운터 캐시
  like_count integer NOT NULL DEFAULT 0,
  dislike_count integer NOT NULL DEFAULT 0,
  comment_count integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.agendas ENABLE ROW LEVEL SECURITY;

CREATE POLICY "agendas_select_all"
ON public.agendas
FOR SELECT
USING (true);

CREATE POLICY "agendas_insert_own"
ON public.agendas
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = created_by);

CREATE POLICY "agendas_update_own"
ON public.agendas
FOR UPDATE
TO authenticated
USING (auth.uid() = created_by)
WITH CHECK (auth.uid() = created_by);

CREATE POLICY "agendas_delete_own"
ON public.agendas
FOR DELETE
TO authenticated
USING (auth.uid() = created_by);

CREATE TABLE IF NOT EXISTS public.agenda_choices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  agenda_id uuid NOT NULL REFERENCES public.agendas(id) ON DELETE CASCADE,
  label text NOT NULL,
  description text,
  position int NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT agenda_choices_unique_position UNIQUE (agenda_id, position),
  CONSTRAINT agenda_choices_unique_label UNIQUE (agenda_id, label)
);

ALTER TABLE public.agenda_choices ENABLE ROW LEVEL SECURITY;

CREATE POLICY "agenda_choices_select_all"
ON public.agenda_choices
FOR SELECT
USING (true);

CREATE POLICY "agenda_choices_insert_own"
ON public.agenda_choices
FOR INSERT
TO authenticated
WITH CHECK (
  auth.uid() = (
    SELECT agendas.created_by
    FROM public.agendas
    WHERE agendas.id = agenda_id
  )
);

CREATE POLICY "agenda_choices_update_own"
ON public.agenda_choices
FOR UPDATE
TO authenticated
USING (
  auth.uid() = (
    SELECT agendas.created_by
    FROM public.agendas
    WHERE agendas.id = agenda_id
  )
)
WITH CHECK (
  auth.uid() = (
    SELECT agendas.created_by
    FROM public.agendas
    WHERE agendas.id = agenda_id
  )
);

CREATE POLICY "agenda_choices_delete_own"
ON public.agenda_choices
FOR DELETE
TO authenticated
USING (
  auth.uid() = (
    SELECT agendas.created_by
    FROM public.agendas
    WHERE agendas.id = agenda_id
  )
);

CREATE TYPE public.vote_reaction AS ENUM ('like', 'dislike');

CREATE TABLE IF NOT EXISTS public.agenda_reactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  agenda_id uuid NOT NULL REFERENCES public.agendas(id) ON DELETE CASCADE,
  created_by uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id),
  reaction public.vote_reaction NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT agenda_reactions_unique_user UNIQUE (agenda_id, created_by)
);

CREATE OR REPLACE FUNCTION public.handle_agenda_reaction_counts()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
-- 좋아요/싫어요 변경에 따라 카운터 갱신
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE public.agendas
    SET like_count = like_count + CASE WHEN NEW.reaction = 'like' THEN 1 ELSE 0 END,
        dislike_count = dislike_count + CASE WHEN NEW.reaction = 'dislike' THEN 1 ELSE 0 END
    WHERE id = NEW.agenda_id;
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    IF NEW.agenda_id <> OLD.agenda_id THEN
      UPDATE public.agendas
      SET like_count = like_count - CASE WHEN OLD.reaction = 'like' THEN 1 ELSE 0 END,
          dislike_count = dislike_count - CASE WHEN OLD.reaction = 'dislike' THEN 1 ELSE 0 END
      WHERE id = OLD.agenda_id;

      UPDATE public.agendas
      SET like_count = like_count + CASE WHEN NEW.reaction = 'like' THEN 1 ELSE 0 END,
          dislike_count = dislike_count + CASE WHEN NEW.reaction = 'dislike' THEN 1 ELSE 0 END
      WHERE id = NEW.agenda_id;
    ELSIF NEW.reaction <> OLD.reaction THEN
      UPDATE public.agendas
      SET like_count = like_count + CASE WHEN NEW.reaction = 'like' THEN 1 ELSE 0 END
                        - CASE WHEN OLD.reaction = 'like' THEN 1 ELSE 0 END,
          dislike_count = dislike_count + CASE WHEN NEW.reaction = 'dislike' THEN 1 ELSE 0 END
                           - CASE WHEN OLD.reaction = 'dislike' THEN 1 ELSE 0 END
      WHERE id = NEW.agenda_id;
    END IF;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE public.agendas
    SET like_count = like_count - CASE WHEN OLD.reaction = 'like' THEN 1 ELSE 0 END,
        dislike_count = dislike_count - CASE WHEN OLD.reaction = 'dislike' THEN 1 ELSE 0 END
    WHERE id = OLD.agenda_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$;

CREATE TRIGGER agenda_reactions_update_count
AFTER INSERT OR UPDATE OR DELETE ON public.agenda_reactions
FOR EACH ROW
EXECUTE PROCEDURE public.handle_agenda_reaction_counts();

ALTER TABLE public.agenda_reactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "agenda_reactions_select_all"
ON public.agenda_reactions
FOR SELECT
USING (true);

CREATE POLICY "agenda_reactions_insert_own"
ON public.agenda_reactions
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = created_by);

CREATE POLICY "agenda_reactions_update_own"
ON public.agenda_reactions
FOR UPDATE
TO authenticated
USING (auth.uid() = created_by)
WITH CHECK (auth.uid() = created_by);

CREATE POLICY "agenda_reactions_delete_own"
ON public.agenda_reactions
FOR DELETE
TO authenticated
USING (auth.uid() = created_by);

CREATE TABLE IF NOT EXISTS public.agenda_comments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  agenda_id uuid NOT NULL REFERENCES public.agendas(id) ON DELETE CASCADE,
  parent_id uuid REFERENCES public.agenda_comments(id) ON DELETE SET NULL,
  content text NOT NULL,
  created_by uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id),
  deleted_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE OR REPLACE FUNCTION public.handle_comment_soft_delete()
RETURNS trigger
LANGUAGE plpgsql
AS $$
-- deleted_at이 있으면 내용을 "삭제된 댓글입니다"로 치환
BEGIN
  IF NEW.deleted_at IS NOT NULL THEN
    NEW.deleted_at := COALESCE(NEW.deleted_at, now());
    NEW.content := '삭제된 댓글입니다';
  ELSIF NEW.content = '삭제된 댓글입니다' THEN
    NEW.deleted_at := now();
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER agenda_comments_soft_delete
BEFORE INSERT OR UPDATE ON public.agenda_comments
FOR EACH ROW
EXECUTE PROCEDURE public.handle_comment_soft_delete();

CREATE OR REPLACE FUNCTION public.handle_agenda_comment_counts()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
-- 댓글 추가/삭제/이동에 따라 카운터 갱신
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF NEW.deleted_at IS NULL THEN
      UPDATE public.agendas
      SET comment_count = comment_count + 1
      WHERE id = NEW.agenda_id;
    END IF;
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    IF NEW.agenda_id <> OLD.agenda_id THEN
      IF OLD.deleted_at IS NULL THEN
        UPDATE public.agendas
        SET comment_count = comment_count - 1
        WHERE id = OLD.agenda_id;
      END IF;
      IF NEW.deleted_at IS NULL THEN
        UPDATE public.agendas
        SET comment_count = comment_count + 1
        WHERE id = NEW.agenda_id;
      END IF;
    ELSIF OLD.deleted_at IS NULL AND NEW.deleted_at IS NOT NULL THEN
      UPDATE public.agendas
      SET comment_count = comment_count - 1
      WHERE id = NEW.agenda_id;
    ELSIF OLD.deleted_at IS NOT NULL AND NEW.deleted_at IS NULL THEN
      UPDATE public.agendas
      SET comment_count = comment_count + 1
      WHERE id = NEW.agenda_id;
    END IF;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    IF OLD.deleted_at IS NULL THEN
      UPDATE public.agendas
      SET comment_count = comment_count - 1
      WHERE id = OLD.agenda_id;
    END IF;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$;

CREATE TRIGGER agenda_comments_update_count
AFTER INSERT OR UPDATE OR DELETE ON public.agenda_comments
FOR EACH ROW
EXECUTE PROCEDURE public.handle_agenda_comment_counts();

ALTER TABLE public.agenda_comments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "agenda_comments_select_all"
ON public.agenda_comments
FOR SELECT
USING (true);

CREATE POLICY "agenda_comments_insert_own"
ON public.agenda_comments
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = created_by);

CREATE POLICY "agenda_comments_update_own"
ON public.agenda_comments
FOR UPDATE
TO authenticated
USING (auth.uid() = created_by)
WITH CHECK (auth.uid() = created_by);

CREATE OR REPLACE VIEW public.agenda_comment_feed AS
SELECT
  c.id,
  c.agenda_id,
  c.parent_id,
  c.content,
  c.created_by,
  c.deleted_at,
  c.created_at,
  c.updated_at,
  p.username AS created_by_username,
  p.avatar_url AS created_by_avatar_url,
  COALESCE(child.child_comment_count, 0) AS child_comment_count
FROM public.agenda_comments c
LEFT JOIN public.profiles p ON p.id = c.created_by
LEFT JOIN (
  SELECT
    parent_id,
    COUNT(*) AS child_comment_count
  FROM public.agenda_comments
  WHERE deleted_at IS NULL
  GROUP BY parent_id
) child ON child.parent_id = c.id;

CREATE OR REPLACE VIEW public.agenda_feed AS
SELECT
  a.id,
  a.title,
  a.description,
  a.created_by,
  p.username AS created_by_username,
  p.avatar_url AS created_by_avatar_url,
  a.like_count,
  a.dislike_count,
  a.comment_count,
  a.created_at,
  a.updated_at,
  latest.latest_comment,
  my_reaction.my_reaction
FROM public.agendas a
-- 작성자 프로필 + 최신 댓글 1개를 함께 조회
LEFT JOIN public.profiles p ON p.id = a.created_by
LEFT JOIN LATERAL (
  SELECT to_jsonb(c) AS latest_comment
  FROM (
    SELECT
      c.id,
      c.agenda_id,
      c.parent_id,
      c.content,
      c.created_by,
      c.deleted_at,
      c.created_at,
      cp.username AS created_by_username,
      cp.avatar_url AS created_by_avatar_url
    FROM public.agenda_comments c
    LEFT JOIN public.profiles cp ON cp.id = c.created_by
    WHERE c.agenda_id = a.id
    ORDER BY c.created_at DESC
    LIMIT 1
  ) c
) latest ON true
-- 로그인 유저의 반응(없으면 NULL)
LEFT JOIN LATERAL (
  SELECT r.reaction AS my_reaction
  FROM public.agenda_reactions r
  WHERE r.agenda_id = a.id
    AND r.created_by = auth.uid()
  LIMIT 1
) my_reaction ON true;

CREATE OR REPLACE FUNCTION public.get_agenda_detail(
  p_agenda_id uuid
)
RETURNS jsonb
LANGUAGE sql
AS $$
  SELECT jsonb_build_object(
    'id', a.id,
    'created_at', a.created_at,
    'updated_at', a.updated_at,
    'title', a.title,
    'description', a.description,
    'like_count', a.like_count,
    'dislike_count', a.dislike_count,
    'comment_count', a.comment_count,
    'author_id', a.created_by,
    'author_username', p.username,
    'author_avatar_url', p.avatar_url,
    'my_reaction', my_reaction.my_reaction,
    'my_choice_id', NULL::uuid
  )
  FROM public.agendas a
  LEFT JOIN public.profiles p ON p.id = a.created_by
  LEFT JOIN LATERAL (
    SELECT r.reaction AS my_reaction
    FROM public.agenda_reactions r
    WHERE r.agenda_id = a.id
      AND r.created_by = auth.uid()
    LIMIT 1
  ) my_reaction ON true
  WHERE a.id = p_agenda_id
  LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION public.create_agenda_with_choices(
  p_agenda_id uuid,
  p_agenda_title text,
  p_agenda_description text DEFAULT NULL,
  p_choices jsonb DEFAULT '[]'::jsonb
)
RETURNS jsonb
LANGUAGE plpgsql
AS $$
DECLARE
  agenda_row public.agendas%ROWTYPE;
  choices_json jsonb;
BEGIN
  INSERT INTO public.agendas (id, title, description)
  VALUES (p_agenda_id, p_agenda_title, p_agenda_description)
  RETURNING * INTO agenda_row;

  INSERT INTO public.agenda_choices (id, agenda_id, label, position)
  SELECT
    (choice->>'id')::uuid,
    agenda_row.id,
    choice->>'label',
    COALESCE((choice->>'position')::int, ordinality)
  FROM jsonb_array_elements(COALESCE(p_choices, '[]'::jsonb))
    WITH ORDINALITY AS t(choice, ordinality);

  SELECT jsonb_agg(
           jsonb_build_object('position', position, 'label', label)
           ORDER BY position
         )
  INTO choices_json
  FROM public.agenda_choices
  WHERE agenda_id = agenda_row.id;

  RETURN jsonb_build_object(
    'id', agenda_row.id,
    'created_at', agenda_row.created_at,
    'updated_at', agenda_row.updated_at,
    'title', agenda_row.title,
    'description', agenda_row.description,
    'created_by', agenda_row.created_by,
    'like_count', agenda_row.like_count,
    'dislike_count', agenda_row.dislike_count,
    'comment_count', agenda_row.comment_count,
    'choices', COALESCE(choices_json, '[]'::jsonb)
  );
END;
$$;
