# GADAIIN — Mini Project 2

**Nama : Muhammad Arifin Alqi. AB**

**NIM  :2409116106**

---

## Deskripsi Aplikasi

GADAIIN adalah aplikasi mobile manajemen transaksi gadai yang dibangun menggunakan Flutter dengan backend Supabase. Aplikasi ini merupakan kelanjutan dari Mini Project 1, dikembangkan dengan menambahkan integrasi database cloud, autentikasi pengguna, serta tampilan yang ditingkatkan dengan dukungan tema gelap dan terang.

---

## Fitur Aplikasi

### Fitur Wajib
- **Create** — Tambah data transaksi gadai baru ke Supabase
- **Read** — Menampilkan seluruh daftar transaksi dari Supabase secara real-time
- **Update** — Edit data transaksi yang sudah ada
- **Delete** — Hapus data transaksi dengan konfirmasi dialog
- **Navigasi multi-halaman** — Home (list data) → Form Tambah/Edit → Detail Transaksi
- **Minimal 3 field input** — Form memiliki 5 field: Nama Nasabah, Nomor HP, Jenis Barang, Deskripsi Barang, Nilai Taksiran
- **Database Supabase** — Semua data disimpan dan diambil dari tabel `pegadaian` di Supabase, bukan dari list lokal

### Nilai Tambah
- **Login & Register menggunakan Supabase Auth** — Pengguna wajib login sebelum mengakses aplikasi. Tersedia halaman registrasi akun baru. `AuthWrapper` di `main.dart` secara otomatis mengarahkan ke halaman yang sesuai berdasarkan status sesi.
- **Light Mode & Dark Mode** — Tema dapat diubah melalui ikon di header halaman Home maupun melalui toggle switch di halaman Profil. State tema dikelola menggunakan `ChangeNotifier` melalui `ThemeProvider`.

---

## Struktur Proyek

```
lib/
├── main.dart               
├── models/
│   └── transaksi.dart       
├── providers/
│   └── theme_provider.dart  
├── services/
│   └── supabase_service.dart  
└── pages/
    ├── main_page.dart         
    ├── login_page.dart        
    ├── register_page.dart     
    ├── home_page.dart        
    ├── form_page.dart         
    ├── detail_page.dart       
    └── profile_page.dart      
```

---

## Cara Kerja Aplikasi

1. **Saat pertama dibuka**, `AuthWrapper` mengecek sesi login via Supabase. Jika belum login diarahkan ke `LoginPage`, jika sudah diarahkan ke `NavbarPage`.
2. **Di halaman Home**, aplikasi mengambil seluruh data dari tabel `pegadaian` di Supabase dan menampilkannya sebagai daftar card. Header menampilkan total transaksi dan total pinjaman secara dinamis.
3. **Tambah transaksi** dilakukan melalui FAB di tengah navbar yang membuka `FormPage`. Pinjaman dihitung otomatis sebesar 70% dari nilai taksiran yang diinput.
4. **Edit transaksi** dilakukan dengan menekan ikon pensil pada card di Home, membuka `FormPage` yang sudah terisi data lama.
5. **Hapus transaksi** dilakukan dengan menekan ikon tempat sampah, disertai dialog konfirmasi sebelum data dihapus dari Supabase.
6. **Detail transaksi** ditampilkan saat card ditekan, menampilkan semua informasi nasabah dan barang gadai secara lengkap.
7. **Halaman Profil** dapat diakses dari tab kanan navbar, berisi info akun, toggle tema, dan tombol logout.

---

## Setup & Konfigurasi

### Tabel Supabase
```sql
create table pegadaian (
  id bigint generated always as identity primary key,
  nama_lengkap text,
  no_hp text,
  jn_brng text,
  dskri_brng text,
  nilai_tafs numeric,
  pinjaman numeric,
  created_at timestamptz default now()
);
```

### Environment Variable
Supabase URL dan API Key disimpan di file `.env` dan tidak di-push ke GitHub.
```
url: 'https://vayieyzozxvrpuksbbvd.supabase.co',
anonKey: 'sb_publishable_qtDilMiLRwHh8cRN8xr9oA_5ydfEC02',
```

### Menjalankan Aplikasi
```bash
flutter pub get
flutter run
```

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.5.6
  provider: ^6.1.2

flutter_launcher_icons:
  android: "ic_launcher"
  image_path: "assets/logo.png"
  min_sdk_android: 21
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/logo.png"
  web:
    generate: false
```
