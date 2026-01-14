-- Reference: https://github.com/Khuwn-Soulutions/supabase_codegen/blob/main/packages/supabase_codegen/bin/sql/get_enum_types.dart
CREATE OR REPLACE FUNCTION public.get_enum_types()
RETURNS TABLE (
  enum_name text,
  enum_value text
)
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  RETURN QUERY
  SELECT
    t.typname::text as enum_name,
    e.enumlabel::text as enum_value
  FROM
    pg_type t
    JOIN pg_enum e ON t.oid = e.enumtypid
    JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
  WHERE
    n.nspname = 'public'
  ORDER BY
    t.typname,
    e.enumsortorder;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.get_enum_types FROM public, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.get_enum_types TO service_role;
