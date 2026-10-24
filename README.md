# Amadya Coffee & Eatery — Catalog & Ordering App

Aplikasi mobile (Flutter) berupa direktori menu, informasi produk, dan pemesanan digital untuk kafe **Amadya Coffee & Eatery**.
Dibuat untuk **Ujian Tengah Semester (UTS) Mobile Programming — Semester Ganjil 2025/2026**.

> Nama: _Dika Larasati_ · NIM: _240605110028_ · Kelas: _Mobile Programming Practicum J_

![Desain UI](docs/desain_ui_amadya.png)

## Tema & Tujuan

Pelanggan dapat melihat menu kafe (kopi, non-kopi, makanan berat, pastry/dessert), membaca detail rasa dan komposisi, memilih ukuran porsi, lalu menyusun pesanan. Desain bernuansa natural dan hangat: **Hijau Army** (primary), **Krem/Putih Tulang** (latar), **Cokelat Tua** (teks), **Gold** (aksen rating & tombol aksi), dengan **motif biji kopi** sebagai dekorasi.

## Daftar Halaman

| # | Halaman | File | Fungsi |
|---|---------|------|--------|
| 1 | Beranda | `lib/screens/home_page.dart` | Sambutan "Mau ngopi apa hari ini, Kak?", search bar, kategori menu, rekomendasi Best Seller |
| 2 | Daftar Menu | `lib/screens/menu_list_page.dart` | Seluruh menu dengan filter kategori, pencarian, dan toggle `GridView.builder` / `ListView.builder` |
| 3 | Detail Menu | `lib/screens/menu_detail_page.dart` | Nama, kategori, harga, deskripsi rasa, komposisi, ukuran porsi, jumlah, tombol tambah ke pesanan |
| 4 | Keranjang | `lib/screens/cart_page.dart` | Ringkasan pesanan, ubah jumlah / geser untuk hapus, data pemesan, subtotal, pajak 10%, total |

Navigasi: `BottomNavigationBar` (Beranda · Menu · Keranjang) pada `lib/screens/main_shell.dart`, dan `Navigator.push` ke Halaman Detail dengan passing objek `MenuItem` lewat konstruktor.

## Struktur Proyek

```
lib/
├── main.dart                     # entry point & MaterialApp
├── theme/app_theme.dart          # palet warna, gaya teks, ThemeData
├── models/menu_item.dart         # MenuItem, PortionSize, MenuCategory (+ fromJson/toJson)
├── data/dummy_menu.dart          # data dummy 17 menu
├── services/
│   ├── menu_repository.dart      # akses data menu (siap diganti API)
│   ├── menu_filter_controller.dart
│   └── cart_controller.dart      # state keranjang (ChangeNotifier)
├── screens/                      # 4 halaman + main_shell
├── widgets/                      # komponen reusable (kartu menu, motif biji kopi, dll.)
└── utils/format.dart             # format Rupiah
docs/                             # gambar desain, mockup, kerangka laporan
```

## Data Dummy & Kesiapan API

Data ada di `lib/data/dummy_menu.dart` dan dibaca lewat `MenuRepository`. Model `MenuItem` sudah memiliki `fromJson` / `toJson` (kunci snake_case), sehingga pada tahap berikutnya cukup mengganti isi `MenuRepository` dengan permintaan HTTP ke API tanpa mengubah UI. Contoh ada pada komentar di `menu_repository.dart`.

Gambar menu memakai ilustrasi bawaan bermotif biji kopi. Isi field `imageUrl` untuk memakai gambar dari server.

## Cara Menjalankan

Prasyarat: Flutter SDK 3.10 atau lebih baru dan emulator / perangkat Android.

```bash
# 1. clone repositori
git clone <https://github.com/dikalarasati/amadyacoffee.git>
cd amadya_coffee

# 2. buat folder platform (android/ios/web) yang belum ada di repo
flutter create . --project-name amadya_coffee

# 3. unduh dependensi
flutter pub get

# 4. jalankan
flutter run
```

> Jika `flutter create .` meminta menimpa file, pastikan folder `lib/` dan `pubspec.yaml` dari repo tetap yang dipakai.

## Fitur

- Navigasi multi-halaman (BottomNavigationBar + Navigator.push)
- Pencarian dan filter kategori real-time
- Tampilan grid responsif (jumlah kolom menyesuaikan lebar layar) atau list
- Keranjang dengan jumlah, hapus dengan geser, perhitungan pajak
- Desain konsisten dengan motif biji kopi (CustomPainter)
