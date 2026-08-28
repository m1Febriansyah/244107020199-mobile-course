# 01 | Mobile Development Ecosystem & Flutter Refresh

## Identitas Mahasiswa
* **Nama**: Febriansyah
* **NIM**: 230101001 *(Sesuaikan dengan NIM Anda)*
* **Mata Kuliah**: Pemrograman Mobile — Minggu 1
* **Program Studi**: Teknik Informatika

## Tujuan Praktikum
1. Menyiapkan dan mengonfigurasi *environment development* Flutter, Android SDK, Git, dan VS Code.
2. Memverifikasi kelayakan environment hingga target build Android bebas dari kendala kritis (`flutter doctor`).
3. Menghubungkan dan mengonfigurasi perangkat target (HP Fisik Android via USB Debugging / Emulator).
4. Membuat, memodifikasi, dan mengompilasi proyek aplikasi Flutter pertama.

## Fitur Utama
* **Tampilan Profil Mahasiswa**: Menampilkan elemen visual identitas mahasiswa meliputi Ikon Institusi (`Icon`), Nama Mahasiswa (`Text`), NIM, dan Program Studi.
* **Pengujian Hot Reload & Hot Restart**: Pembaruan tampilan antarmuka secara instan tanpa perlu mengompilasi ulang seluruh aplikasi dari awal.

## Hasil yang Dicapai
Setup Environment Fully Verified: flutter doctor mengonfirmasi komponen Flutter SDK dan Android Toolchain [✓] Centang Hijau.
Koneksi Perangkat Berhasil: Perangkat fisik OPPO (CPH2159) terdeteksi sempurna sebagai target instalasi aplikasi.
Aplikasi Berjalan Lancar: Aplikasi Profil Mahasiswa berhasil di-compile (assembleDebug) dan terpasang di HP fisik tanpa error.

## Screenshots
Screenshots/flutterdoctor.jpg — Bukti verifikasi flutter doctor.
Screenshots/apppreview.jpg — Tangkapan layar aplikasi Profil Mahasiswa yang berjalan di HP fisik.

## Refleksi Praktikum
1. Kapan native lebih tepat dipilih daripada cross-platform?
Akses API & Perangkat Keras Spesifik: Ketika aplikasi memerlukan akses low-level ke sensor khusus, integrasi Bluetooth Low Energy yang sangat kompleks, atau fitur AR/VR tingkat lanjut.
2. Bagaimana perubahan state berhubungan dengan widget tree dan UI deklaratif?
Widget Tree: Pohon hirarki widget di Flutter bersifat immutable (tidak dapat diubah setelah dibentuk).
3. Mengapa commit kecil dengan pesan jelas (Atomic Commit) bermanfaat bagi pekerjaan tim dan portfolio?
Kolaborasi Tim: Commit kecil memudahkan proses code review, mengurangi risiko bentrokan penggabungan kode (merge conflict), serta mempermudah pembatalan kode (git revert) jika ditemukan bug.