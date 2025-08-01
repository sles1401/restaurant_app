## 📱 Restaurant App

Aplikasi Flutter yang menampilkan daftar restoran, detail restoran, fitur pencarian, dan menyimpan restoran favorit. Proyek ini merupakan submission untuk kelas **Belajar Fundamental Aplikasi Flutter** Dicoding.

---

### ✨ Fitur Utama

* **Daftar Restoran**: Menampilkan semua restoran yang tersedia.
* **Detail Restoran**: Menampilkan detail seperti menu, lokasi, dan rating.
* **Pencarian Restoran**: Cari restoran berdasarkan kata kunci.
* **Favorit**: Simpan dan hapus restoran dari daftar favorit (disimpan lokal dengan Hive).
* **Notifikasi Harian**: Rekomendasi restoran setiap hari pukul 11.00 (Android).
2
---

### 📸 Screenshots

---

### 🔧 Teknologi yang Digunakan

* [Flutter](https://flutter.dev/)
* [Provider](https://pub.dev/packages/provider) – state management
* [HTTP](https://pub.dev/packages/http) – konsumsi API
* [Hive](https://pub.dev/packages/hive) – penyimpanan lokal untuk favorit
* [flutter\_local\_notifications](https://pub.dev/packages/flutter_local_notifications) – notifikasi harian
* [android\_alarm\_manager\_plus](https://pub.dev/packages/android_alarm_manager_plus) – penjadwalan background task

---

### ▶️ Cara Menjalankan

1. **Clone repository ini:**

   ```bash
   git clone https://github.com/username/restaurant_app.git
   cd restaurant_app
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi:**

   ```bash
   flutter run
   ```

---

### 🧪 Testing

Proyek ini sudah memiliki unit test dan widget test. Jalankan dengan:

```bash
flutter test
```

---

### ⚠️ Catatan

* Aplikasi ini menggunakan **Dicoding Restaurant API**:
  [https://restaurant-api.dicoding.dev](https://restaurant-api.dicoding.dev)
* Fitur notifikasi hanya berjalan di Android.
* Pastikan sudah menjalankan `flutter clean` jika ada error build.
