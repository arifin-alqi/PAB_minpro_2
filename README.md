# GADAIIN — Mini Project 2

Aplikasi transaksi gadai berbasis Flutter + Supabase.

---

## Screenshots

### Login & Register
| Login | Register |
|-------|----------|
| ![Login]() | ![Register]() |

### Home & Detail
| Home | Detail |
|------|--------|
| ![Home]() | ![Detail]() |

### Form & Profil
| Form | Profil |
|------|--------|
| ![Form]() | ![Profil]() |

---

## Fitur

### Wajib
- CRUD transaksi ke Supabase (Create, Read, Update, Delete)
- Navigasi: Home → Form → Detail
- 5 field input: Nama, No HP, Jenis Barang, Deskripsi, Nilai Taksiran

### Nilai Tambah
- **Login & Register** — Supabase Auth dengan validasi input
- **Dark / Light Mode** — toggle di header Home dan halaman Profil

---

## Teknologi

```yaml
supabase_flutter: ^2.5.6
provider: ^6.1.2
```

---

## Setup

1. Buat tabel di Supabase:
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

2. Aktifkan RLS policy:
```sql
create policy "allow all" on pegadaian
  for all using (true) with check (true);
```

3. Isi credentials di `lib/main.dart`:
```dart
await Supabase.initialize(
  url: 'ISI_SUPABASE_URL_KAMU',
  anonKey: 'ISI_SUPABASE_ANON_KEY_KAMU',
);
```

4. Jalankan:
```bash
flutter pub get
flutter run
```

---

> Pinjaman = 70% dari nilai taksiran. Email confirmation Supabase harus dimatikan.
