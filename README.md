# ☁️ CuacaKu: Aplikasi Informasi Cuaca & Utilitas Multi-fitur ☀️


Aplikasi CuacaKu adalah aplikasi mobile inovatif yang dirancang untuk memberikan informasi cuaca real-time yang akurat, dilengkapi dengan berbagai fitur utilitas tambahan. Dibangun menggunakan Flutter, aplikasi ini menawarkan pengalaman pengguna yang intuitif dengan fungsionalitas seperti otentikasi pengguna lokal, notifikasi cuaca, konversi mata uang, konversi zona waktu, dan integrasi sensor perangkat.

## ✨ Fitur Utama

CuacaKu tidak hanya sekadar aplikasi cuaca, namun juga sebuah *tool* multifungsi yang berorientasi pada pengguna:

* **Informasi Cuaca Real-time:** Menampilkan suhu, kondisi, kelembaban, kecepatan angin, dan ramalan cuaca harian/mingguan dari data BMKG.
* **Pencarian Lokasi:** Kemampuan untuk mencari dan memilih lokasi spesifik untuk melihat informasi cuaca.
* **Sistem Otentikasi Lokal:** Pendaftaran, login, dan logout pengguna tanpa Firebase, menggunakan Hive sebagai database lokal dan enkripsi password `Rail Fence Cipher` untuk keamanan.
* **Manajemen Profil Pengguna:** Pengguna dapat melihat dan memperbarui informasi profil mereka.
* **Fitur Premium:** Akses ke ramalan cuaca lanjutan dan notifikasi kustom bagi pengguna premium.
* **Notifikasi Cuaca:** Mengirimkan notifikasi terjadwal atau peringatan cuaca penting.
* **Konversi Mata Uang:** Alat konversi cepat untuk minimal 3 mata uang (misal: IDR, SAR, EUR, MYR).
* **Konversi Zona Waktu:** Konversi waktu antar zona waktu utama (WIB, WITA, WIT, London, Riyadh).
* **Integrasi Sensor:** Menampilkan pembacaan data dari sensor *accelerometer* perangkat.
* **Saran & Kesan:** Fitur untuk memberikan umpan balik dan rating terhadap aplikasi/mata kuliah.

## 🚀 Teknologi yang Digunakan

* **Framework:** [Flutter](https://flutter.dev/)
* **Bahasa Pemrograman:** [Dart](https://dart.dev/)
* **Database Lokal:** [Hive](https://docs.hivedb.dev/)
* **Enkripsi Password:** [Rail Fence Cipher](https://en.wikipedia.org/wiki/Rail_fence_cipher) (implementasi kustom)
* **API Cuaca:** [API Publik BMKG](https://data.bmkg.go.id/)
* **API Konversi Mata Uang:** ((https://www.exchangerate-api.com/))
* **Manajemen Status/Stream:** [RxDart](https://pub.dev/packages/rxdart) (untuk `BehaviorSubject` di AuthService)
* **Notifikasi Lokal:** [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
* **Penanganan Waktu:** [timezone](https://pub.dev/packages/timezone)
* **HTTP Requests:** [http](https://pub.dev/packages/http)

## 📦 Instalasi & Penggunaan

Ikuti langkah-langkah di bawah ini untuk menjalankan aplikasi CuacaKu di perangkat lokal Anda.

### Prasyarat

* [Flutter SDK](https://flutter.dev/docs/get-started/install) terinstal di sistem Anda.
* Editor kode seperti [VS Code](https://code.visualstudio.com/) dengan ekstensi Flutter.
* Perangkat Android/iOS atau emulator/simulator.

### Langkah Instalasi

1.  **Clone repositori ini:**
    ```bash
    git clone [https://github.com/SiAnakAlim/App-Mobile-Cuacaku]
    ```


2.  **Instal dependensi:**
    ```bash
    flutter pub get
    ```

3.  **Hasilkan file adapter Hive (jika Anda mengubah model Hive):**
    ```bash
    flutter packages pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Siapkan API Keys:**
    * Untuk API BMKG, pastikan format respons API sesuai dengan model `WeatherData` Anda.
    * Untuk API Konversi Mata Uang, dapatkan API Key Anda dan masukkan ke dalam `ConversionService` jika diperlukan.

5.  **Jalankan aplikasi:**
    ```bash
    flutter run
    ```

### Cara Menggunakan Aplikasi

1.  **Daftar/Login:** Pada halaman pembuka, Anda akan diminta untuk mendaftar akun baru atau login jika sudah memiliki akun.
2.  **Jelajahi Cuaca:** Setelah login, Anda akan masuk ke Home Screen yang menampilkan cuaca. Gunakan fitur pencarian untuk melihat cuaca di berbagai lokasi.
3.  **Akses Fitur Lain:** Navigasi melalui `BottomNavigationBar` untuk mengakses:
    * **Profil:** Lihat dan edit profil Anda, atau logout.
    * **Saran & Kesan:** Berikan umpan balik tentang aplikasi.
    * **Konversi:** Gunakan alat konversi mata uang dan zona waktu.
    * **Sensor:** Lihat data dari sensor *accelerometer*.

## 🤝 Kontribusi

Proyek ini dikembangkan sebagai Final Project mata kuliah Teknologi Pemrograman Mobile. Kontribusi dalam bentuk *issue*, *feature request*, atau *pull request* dipersilakan.


## 📧 Kontak

Jika Anda memiliki pertanyaan atau saran, jangan ragu untuk menghubungi:

* **Nama:** Aryamukti Satria Hendrayana
* **NIM:** 123220181
* **Email:** aryamuktisatria@gmail.com

---
