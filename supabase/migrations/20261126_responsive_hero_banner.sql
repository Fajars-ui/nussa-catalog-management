-- NUSSA: separate desktop and mobile hero banner images.
-- Run once in Supabase SQL Editor. Existing hero_image_url is preserved.
ALTER TABLE public.site_settings
  ADD COLUMN IF NOT EXISTS hero_image_desktop_url text,
  ADD COLUMN IF NOT EXISTS hero_image_mobile_url text;

UPDATE public.site_settings
SET hero_image_desktop_url = COALESCE(hero_image_desktop_url, hero_image_url)
WHERE id = 1;

NOTIFY pgrst, 'reload schema';
