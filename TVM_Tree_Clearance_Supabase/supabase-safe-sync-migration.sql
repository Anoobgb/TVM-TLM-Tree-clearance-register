-- Safe sync migration for TVM Tree Clearance Register.
-- Run once in Supabase SQL Editor after backing up the existing table.
ALTER TABLE public.tree_clearance_records
  ADD COLUMN IF NOT EXISTS revision bigint NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS deleted boolean NOT NULL DEFAULT false;

CREATE OR REPLACE FUNCTION public.save_tree_clearance_record(
  p_id text,
  p_record jsonb,
  p_expected_revision bigint,
  p_deleted boolean DEFAULT false
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public
AS $$
DECLARE
  v_revision bigint;
BEGIN
  UPDATE public.tree_clearance_records
     SET record = p_record,
         deleted = p_deleted,
         revision = revision + 1,
         updated_at = now()
   WHERE id = p_id
     AND revision = p_expected_revision
  RETURNING revision INTO v_revision;

  IF FOUND THEN
    RETURN jsonb_build_object('ok', true, 'revision', v_revision);
  END IF;

  IF p_expected_revision = 0 THEN
    INSERT INTO public.tree_clearance_records (id, record, revision, deleted, updated_at)
    VALUES (p_id, p_record, 1, p_deleted, now())
    ON CONFLICT (id) DO NOTHING
    RETURNING revision INTO v_revision;

    IF FOUND THEN
      RETURN jsonb_build_object('ok', true, 'revision', v_revision);
    END IF;
  END IF;

  SELECT revision INTO v_revision
    FROM public.tree_clearance_records
   WHERE id = p_id;

  RETURN jsonb_build_object('ok', false, 'revision', COALESCE(v_revision, 0));
END;
$$;

REVOKE ALL ON FUNCTION public.save_tree_clearance_record(text, jsonb, bigint, boolean) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.save_tree_clearance_record(text, jsonb, bigint, boolean) TO authenticated;
