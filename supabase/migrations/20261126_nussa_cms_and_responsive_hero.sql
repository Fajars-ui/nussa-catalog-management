-- NUSSA CMS + responsive Hero Banner migration.
-- Safe to run more than once. Existing catalog data and old hero URL are preserved.
ALTER TABLE public.site_settings
  ADD COLUMN IF NOT EXISTS hero_image_desktop_url text,
  ADD COLUMN IF NOT EXISTS hero_image_mobile_url text;

UPDATE public.site_settings
SET hero_image_desktop_url = COALESCE(hero_image_desktop_url, hero_image_url)
WHERE id = 1;

-- NUSSA CMS: editable public page content. Additive migration; does not modify catalog tables.
CREATE TABLE IF NOT EXISTS public.site_content (
  id integer PRIMARY KEY DEFAULT 1 CHECK (id = 1),
  content jsonb NOT NULL DEFAULT '{}'::jsonb,
  updated_at timestamptz NOT NULL DEFAULT now()
);
INSERT INTO public.site_content (id, content)
VALUES (1, '{
  "hero_title":"NUSSA Pasti Pas",
  "hero_description":"Temukan busana adat pilihan untuk merayakan momen istimewa, tampil percaya diri, dan tetap dekat dengan warisan budaya Indonesia.",
  "hero_cta":"Sewa Sekarang!",
  "about_title":"Warisan Budaya, Momen Istimewa",
  "about_description":"NUSSA hadir sebagai pusat penyewaan baju adat di Pontianak dengan pilihan busana dari berbagai daerah Nusantara. Kami juga memproduksi koleksi busana sendiri dan membantu pelanggan menemukan pilihan yang sesuai untuk setiap acara.",
  "category_title":"Pilih Baju Adatmu",
  "category_description":"Jelajahi ragam busana adat dari berbagai daerah Nusantara untuk acara, perayaan, dan momen spesial.",
  "products_title":"Koleksi Busana Adat",
  "products_description":"Pilih koleksi favorit dan masukkan ke keranjang untuk mengajukan penyewaan.",
  "info_title":"Mudah Memilih, Praktis Menyewa",
  "info_benefits":[
    {"title":"Ragam Budaya","description":"Melayu, Dayak, Jawa, Bali, dan koleksi Nusantara lainnya."},
    {"title":"Konsultasi Ukuran","description":"Hubungi admin untuk menanyakan ukuran dan kecocokan busana."},
    {"title":"Pemesanan Praktis","description":"Pilih koleksi dan kirim permintaan sewa langsung melalui WhatsApp."}
  ],
  "contact_address":"Jl. Sepakat 2 Untan Gg. Amali No. 7, Kota Pontianak",
  "contact_map_url":"https://maps.app.goo.gl/V7bqV3XFUg4zqm1VA",
  "instagram_handle":"@nussa.pnk",
  "instagram_url":"https://www.instagram.com/nussa.pnk?cnvx=MW4weWc2Mnp1Y2tncA==",
  "whatsapp_number":"6289693621442",
  "operating_hours":"Setiap hari, 08.00–20.00 WIB",
  "visibility":{"about":true,"categories":true,"products":true,"information":true,"contact":true}
}'::jsonb)
ON CONFLICT (id) DO NOTHING;

ALTER TABLE public.site_content ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public can view site content" ON public.site_content;
DROP POLICY IF EXISTS "Admin can manage site content" ON public.site_content;
CREATE POLICY "Public can view site content" ON public.site_content
  FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "Admin can manage site content" ON public.site_content
  FOR ALL TO authenticated
  USING ((auth.jwt() ->> 'email') = 'fajarkoma@gmail.com')
  WITH CHECK ((auth.jwt() ->> 'email') = 'fajarkoma@gmail.com');
GRANT SELECT ON public.site_content TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON public.site_content TO authenticated;
NOTIFY pgrst, 'reload schema';
