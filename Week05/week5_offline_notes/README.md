# 05 | Local Storage & Offline-First di Flutter

## Identitas Mahasiswa
* **Nama**: Muhammad Febriansyah
* **NIM**: 244107020199
* **Mata Kuliah**: Pemrograman Mobile — Minggu 5
* **Program Studi**: S1 Teknologi Informasi

## Tujuan Praktikum
1. Menerapkan penyimpanan persisten untuk data preferensi (Key-Value) menggunakan `SharedPreferences`.
2. Membangun struktur *database* relasional lokal untuk manajemen data yang lebih kompleks menggunakan `sqflite` (SQLite).
3. Mengelola *State* secara asinkron menggunakan `flutter_riverpod` (`AsyncNotifier` dan `Provider`).
4. Mengimplementasikan arsitektur *Offline-First* dengan strategi *cache-first* dan sinkronisasi antrean (*dirty flag*).

---

## 1. Praktikum 1: SharedPreferences
Pada tahap ini, dilakukan pembuatan fitur penyimpanan pengaturan sederhana berupa *toggle Dark Mode* dan pencatatan waktu terakhir aplikasi dibuka. Logika penyimpanan dipisahkan ke dalam `PrefsRepository` agar tidak bercampur dengan UI, dan dihubungkan ke antarmuka menggunakan Riverpod untuk menghindari UI *blocking*.

**Screenshot Praktikum 1:** 
![Settings & Dark Mode](screenshots/praktikum1_settings.jpg)

---

## 2. Praktikum 2: SQLite dan Repository Catatan
Mengubah aplikasi untuk dapat menyimpan daftar catatan panjang menggunakan *database* SQLite. Dibuat entitas `Note` yang memiliki status `dirty` (menandai data belum disinkronisasi ke server). Seluruh proses akses *database* (CRUD) diabstraksi melalui `NoteRepository` sehingga komponen UI tidak pernah memanggil perintah SQL secara langsung.

**Screenshot Praktikum 2:** 
![Daftar Catatan Offline](screenshots/praktikum2_notes.jpg)

---

## 3. Praktikum 3 & 7: Sinkronisasi Offline & Refactoring
Mengimplementasikan strategi sinkronisasi data secara otomatis di latar belakang (*background sync*). Menambahkan fitur simulasi `Force Offline` untuk keperluan *testing*, serta membungkus daftar catatan dengan `RefreshIndicator` (*pull-to-refresh*) untuk mengirim antrean catatan *dirty* ke *server* bayangan. Baris catatan juga diekstrak menjadi widget `NoteTile` yang mandiri (*reusable*).

**Screenshot Praktikum 3 & Simulasi Offline:**
1. Tambah Catatan (Status Dirty / Belum Sync)
![Sebelum Sync](screenshots/praktikum3_sebelum_sync.jpg)
2. Setelah Tarik Layar ke Bawah (Sinkronisasi Berhasil)
![Sesudah Sync](screenshots/praktikum3_sesudah_sync.jpg)
3. Pesan Error saat Force Offline Aktif
![Error Offline](screenshots/praktikum3_error_offline.jpg)

---

## Tugas Utama & AI Design Exploration
Aplikasi disempurnakan dengan dukungan navigasi `GoRouter` untuk halaman Detail Catatan. Seluruh kode dipastikan lolos pengecekan `flutter analyze` tanpa teguran, dan lulus pengujian `flutter test` menggunakan simulasi `FakeNoteRepository`.

**Checklist Verifikasi:**
1. `flutter analyze` tidak menghasilkan error (0 issues).
![Checklist Analyze](screenshots/tugas_analyze.jpg)
2. `flutter test` lulus semua pengujian unit (*null safety*, persistensi *dirty flag*, dan respons *provider* palsu).
![Checklist Test](screenshots/tugas_test.jpg)

### Hasil Eksplorasi AI (Design Prompt Challenge)
* **Prompt:** "Bandingkan penggunaan SQLite, SharedPreferences, dan Hive untuk arsitektur Offline-First pada aplikasi Flutter. Berikan rekomendasi mana yang terbaik untuk skenario aplikasi Offline Notes."
* **Hasil Analisis AI:** 
  * **SharedPreferences:** Paling ringan, namun hanya cocok untuk data key-value sederhana (seperti token atau tema). Tidak mendukung *query* atau relasi.
  * **SQLite (sqflite):** Sangat tangguh untuk data terstruktur yang butuh *sorting* atau *filtering* kompleks. Mendukung *transaction* untuk menjaga keamanan data saat sinkronisasi gagal.
  * **Hive (NoSQL):** Kecepatan baca/tulis sangat tinggi karena berjalan di memori (*memory-mapped*). Sangat bagus untuk *caching* respon API, namun tidak mendukung *query* relasional sekuat SQLite.
  * **Keputusan Akhir:** Memilih gabungan **SharedPreferences** untuk tema UI, dan **SQLite** untuk catatan. Penggunaan Hive ditolak karena untuk skala *mini project*, SQLite sudah lebih dari cukup dan mencegah penambahan *library* (bloatware) yang berlebihan.

---

## Refleksi Praktikum

**1. Mengapa daftar catatan tidak boleh disimpan di SharedPreferences? Apa yang rusak jika aturan ini dilanggar?**
`SharedPreferences` dirancang untuk data kecil dan akan memuat seluruh isinya ke dalam memori (RAM) secara otomatis ketika aplikasi berjalan. Jika daftar catatan menjadi ratusan atau ribuan baris, aplikasi akan boros memori, menjadi lambat, dan berisiko mengalami *crash* (*Out of Memory*). Selain itu, SharedPreferences tidak mendukung fitur pencarian data atau pengurutan (seperti `ORDER BY updated_at`).

**2. Kapan cache-first cukup, dan kapan Anda membutuhkan strategi lain (misalnya network-first untuk data harga real-time)?**
Strategi *Cache-First* sangat ideal untuk aplikasi di mana kecepatan akses dan ketersediaan *offline* adalah prioritas utama (contoh: artikel, catatan, media sosial), karena pembacaan lokal jauh lebih cepat. Namun, strategi *Network-First* wajib digunakan untuk data yang sensitif terhadap waktu atau akurasi (misal: saldo bank, *booking* tiket, atau harga kripto/saham), di mana menampilkan data lawas (*stale data*) justru akan merugikan pengguna.

**3. Bagaimana dirty flag berubah menjadi antrean sync tanpa memblokir UI? Kapan antrean terpisah (tabel outbox) menjadi perlu?**
Dengan menggunakan state management `AsyncNotifier` dari Riverpod, proses membaca data `dirty` dan mengirimnya ke server dijalankan secara asinkron (di *background*). UI tidak menunggu proses ini selesai dan tetap mulus. Antrean terpisah (seperti tabel *Outbox Pattern*) baru diperlukan jika urutan aksi (*create, edit, delete*) sangat kompleks dan harus dikirim secara ketat (berurutan) agar tidak terjadi konflik data saat dua perangkat menyinkronkan data di waktu yang sama.

**4. Bagian mana dari rekomendasi AI yang Anda tolak, dan mengapa?**
Saya menolak rekomendasi AI yang menyarankan untuk menginstal *database NoSQL* seperti Hive secara bersamaan dengan SQLite untuk menangani *caching* hasil API JSONPlaceholder. Alasannya, untuk skala aplikasi *offline notes* ini, penggunaan satu alat (SQLite) sudah mampu menangani operasi CRUD catatan dan menyimpan data JSON *cache* dalam format teks murni. Menambah *library database* baru hanya akan menambah ukuran aplikasi dan kompleksitas *maintenance* tanpa memberikan manfaat kecepatan yang signifikan.