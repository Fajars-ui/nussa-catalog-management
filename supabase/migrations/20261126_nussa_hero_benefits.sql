-- Update the public NUSSA hero copy and its four selling points.
-- Safe to run repeatedly; preserves all other CMS fields.
UPDATE public.site_content
SET content = COALESCE(content, '{}'::jsonb) || jsonb_build_object(
  'hero_title', 'Kenapa Sewa Di NUSSA?',
  'hero_description', '',
  'hero_benefits', jsonb_build_array(
    'Koleksi Lengkap',
    'Produksi Mandiri',
    'Fitting Instan',
    'Layanan Fleksibel'
  )
),
updated_at = now()
WHERE id = 1;

NOTIFY pgrst, 'reload schema';
