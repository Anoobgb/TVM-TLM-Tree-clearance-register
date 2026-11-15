-- Run this as ONE statement in Supabase SQL Editor.
DO $$
BEGIN
  CREATE TABLE IF NOT EXISTS public.tree_clearance_records (
    id text PRIMARY KEY,
    record jsonb NOT NULL,
    updated_at timestamptz NOT NULL DEFAULT now()
  );

  ALTER TABLE public.tree_clearance_records ENABLE ROW LEVEL SECURITY;

  DROP POLICY IF EXISTS "Authenticated users can read tree records" ON public.tree_clearance_records;
  CREATE POLICY "Authenticated users can read tree records"
    ON public.tree_clearance_records FOR SELECT TO authenticated USING (true);

  DROP POLICY IF EXISTS "Authenticated users can insert tree records" ON public.tree_clearance_records;
  CREATE POLICY "Authenticated users can insert tree records"
    ON public.tree_clearance_records FOR INSERT TO authenticated WITH CHECK (true);

  DROP POLICY IF EXISTS "Authenticated users can update tree records" ON public.tree_clearance_records;
  CREATE POLICY "Authenticated users can update tree records"
    ON public.tree_clearance_records FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

  DROP POLICY IF EXISTS "Authenticated users can delete tree records" ON public.tree_clearance_records;
  CREATE POLICY "Authenticated users can delete tree records"
    ON public.tree_clearance_records FOR DELETE TO authenticated USING (true);

  GRANT SELECT, INSERT, UPDATE, DELETE ON public.tree_clearance_records TO authenticated;
  REVOKE ALL ON public.tree_clearance_records FROM anon;
END $$;
