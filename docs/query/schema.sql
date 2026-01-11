CREATE TABLE IF NOT EXISTS public.agendas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  created_by uuid NOT NULL REFERENCES auth.users(id),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.agenda_options (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  agenda_id uuid NOT NULL REFERENCES public.agendas(id),
  sequence integer NOT NULL default 0,
  choice_count integer NOT NULL default 0,
  content text NOT NULL,
  UNIQUE (agenda_id, sequence)
);

CREATE TABLE IF NOT EXISTS public.agenda_option_choices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  agenda_id uuid NOT NULL REFERENCES public.agendas(id),
  agenda_option_id uuid NOT NULL REFERENCES public.agenda_options(id),
  created_by uuid NOT NULL REFERENCES auth.users(id),
  UNIQUE (agenda_id, created_by)
);
