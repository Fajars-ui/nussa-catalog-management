-- NUSSA Online Catalog: jalankan sekali di Supabase SQL Editor.
-- WAJIB: ganti fajarkoma@gmail.com dengan email akun admin yang dibuat di Supabase Auth.
create table if not exists public.collections (
 id uuid primary key default gen_random_uuid(),
 sku text unique not null,
 name text not null,
 category text not null check (category in ('Melayu','Dayak','Jawa','Bali','Nusantara Lainnya')),
 description text,
 size text,
 included text,
 price integer,
 stock integer not null default 0 check (stock >= 0),
 status text not null default 'Tersedia' check (status in ('Tersedia','Disewa','Perawatan','Tidak aktif')),
 image_url text,
 is_published boolean not null default false,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
alter table public.collections add column if not exists stock integer not null default 0 check (stock >= 0);
alter table public.collections enable row level security;
drop policy if exists "Public can view published collections" on public.collections;
drop policy if exists "Admin can view all collections" on public.collections;
drop policy if exists "Admin can manage collections" on public.collections;
create policy "Public can view published collections" on public.collections
 for select to anon, authenticated using (is_published = true);
create policy "Admin can view all collections" on public.collections
 for select to authenticated using ((auth.jwt() ->> 'email') = 'fajarkoma@gmail.com');
create policy "Admin can manage collections" on public.collections
 for all to authenticated
 using ((auth.jwt() ->> 'email') = 'fajarkoma@gmail.com')
 with check ((auth.jwt() ->> 'email') = 'fajarkoma@gmail.com');

create table if not exists public.site_settings (
 id integer primary key default 1 check (id = 1),
 promo_text text not null default 'Sewa Baju Adat untuk Momen Istimewamu',
 hero_image_url text,
 updated_at timestamptz not null default now()
);
insert into public.site_settings (id) values (1) on conflict (id) do nothing;
alter table public.site_settings enable row level security;
drop policy if exists "Public can view site settings" on public.site_settings;
drop policy if exists "Admin can manage site settings" on public.site_settings;
create policy "Public can view site settings" on public.site_settings
 for select to anon, authenticated using (true);
create policy "Admin can manage site settings" on public.site_settings
 for all to authenticated
 using ((auth.jwt() ->> 'email') = 'fajarkoma@gmail.com')
 with check ((auth.jwt() ->> 'email') = 'fajarkoma@gmail.com');
grant usage on schema public to anon, authenticated;
grant select on public.collections, public.site_settings to anon, authenticated;
grant insert, update, delete on public.collections, public.site_settings to authenticated;

insert into storage.buckets (id,name,public)
 values ('collection-photos','collection-photos',true)
 on conflict (id) do nothing;
drop policy if exists "Public can view collection photos" on storage.objects;
drop policy if exists "Admin can upload collection photos" on storage.objects;
drop policy if exists "Admin can update collection photos" on storage.objects;
drop policy if exists "Admin can delete collection photos" on storage.objects;
create policy "Public can view collection photos" on storage.objects
 for select to anon, authenticated using (bucket_id = 'collection-photos');
create policy "Admin can upload collection photos" on storage.objects
 for insert to authenticated with check (
  bucket_id = 'collection-photos' and (auth.jwt() ->> 'email') = 'fajarkoma@gmail.com'
 );
create policy "Admin can update collection photos" on storage.objects
 for update to authenticated using (
  bucket_id = 'collection-photos' and (auth.jwt() ->> 'email') = 'fajarkoma@gmail.com'
 ) with check (
  bucket_id = 'collection-photos' and (auth.jwt() ->> 'email') = 'fajarkoma@gmail.com'
 );
create policy "Admin can delete collection photos" on storage.objects
 for delete to authenticated using (
  bucket_id = 'collection-photos' and (auth.jwt() ->> 'email') = 'fajarkoma@gmail.com'
 );
-- Buat user admin di Supabase Dashboard > Authentication > Users > Add user.
