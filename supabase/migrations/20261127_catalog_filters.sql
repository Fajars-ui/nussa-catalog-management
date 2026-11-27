-- NUSSA catalog filters: additive fields; existing collection records are preserved.
ALTER TABLE public.collections
  ADD COLUMN IF NOT EXISTS audience_category text,
  ADD COLUMN IF NOT EXISTS package_type text,
  ADD COLUMN IF NOT EXISTS color text,
  ADD COLUMN IF NOT EXISTS popularity integer NOT NULL DEFAULT 0;

CREATE INDEX IF NOT EXISTS collections_filter_audience_idx ON public.collections (audience_category);
CREATE INDEX IF NOT EXISTS collections_filter_package_idx ON public.collections (package_type);
CREATE INDEX IF NOT EXISTS collections_filter_size_idx ON public.collections (size);
CREATE INDEX IF NOT EXISTS collections_filter_color_idx ON public.collections (color);
CREATE INDEX IF NOT EXISTS collections_popularity_idx ON public.collections (popularity DESC);
