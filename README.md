# NUSSA Online Catalog

Katalog digital publik penyewaan busana adat NUSSA Pontianak. Pengunjung dapat melihat koleksi tanpa login; admin masuk melalui halaman `/admin` untuk menambah, mengedit, menghapus, dan mengunggah foto koleksi.

## Fitur
- Katalog publik tanpa akun/login untuk penyewa.
- Pencarian dan filter Melayu, Dayak, Jawa, Bali, serta Nusantara Lainnya.
- Tombol WhatsApp pada setiap koleksi, terhubung ke admin NUSSA.
- Panel admin privat di `/admin`.
- Upload foto dan pengelolaan status ketersediaan.
- Draft koleksi dapat disembunyikan dari pengunjung.

## A. Siapkan Supabase
1. Buat project di https://supabase.com.
2. Buka **SQL Editor**.
3. Buka file `supabase/schema.sql` di repositori ini. Ganti setiap teks `ADMIN_EMAIL_HERE` dengan email admin yang akan digunakan untuk login Supabase.
4. Jalankan SQL tersebut.
5. Buka **Authentication → Users → Add user** dan buat user dengan email yang sama persis dengan email pada SQL.
6. Dari **Project Settings → API**, salin Project URL dan anon/public key. Jangan gunakan service_role key di website.

## B. Deploy ke Vercel
1. Buka https://vercel.com dan login menggunakan GitHub.
2. Pilih **Add New → Project**, lalu import repository `Fajars-ui/nussa-catalog-management`.
3. Framework akan terdeteksi sebagai Next.js.
4. Tambahkan Environment Variables:
   - `NEXT_PUBLIC_SUPABASE_URL` = Project URL Supabase
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY` = anon/public key Supabase
   - `NEXT_PUBLIC_WHATSAPP_NUMBER` = `6289521032797`
5. Klik **Deploy**. Setelah selesai, Vercel memberikan alamat publik `*.vercel.app`.

## C. Mengelola katalog
- Pengunjung: buka alamat utama website, tidak perlu login.
- Admin: buka `https://ALAMAT-WEBSITE.vercel.app/admin`, lalu login memakai akun Supabase.
- Isi kode, nama, kategori, status, harga (jika ingin ditampilkan), ukuran, kelengkapan, deskripsi, dan foto.
- Centang **Tampilkan di katalog publik** agar koleksi terlihat oleh penyewa.

## Keamanan
- Row Level Security membatasi perubahan data dan upload foto hanya untuk email admin yang ditetapkan pada SQL.
- Jangan pernah menaruh Supabase service_role key atau password di GitHub/Vercel source.
- Jangan mengaktifkan pendaftaran publik untuk akun admin.
- Uji akses katalog dari mode incognito dan uji login admin sebelum dibagikan ke pelanggan.

## Struktur
- `app/page.tsx`: katalog publik
- `app/admin/page.tsx`: panel admin
- `supabase/schema.sql`: tabel dan kebijakan keamanan
- `.env.example`: contoh environment variables
