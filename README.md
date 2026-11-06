# rpl_keamanan

Praktikum Pemrograman Mobile (ST407) Pertemuan 6: Prinsip RPL & Keamanan Kode.

Fitur: Repository pattern (User & Post), konfigurasi `.env` (tanpa hardcoded
credential), validasi & sanitasi input, logger aman, dependency injection
sederhana, dokumentasi dartdoc, dan unit test.

## Cara menjalankan

1. Salin `.env.example` menjadi `.env`, lalu isi `BASE_URL` dan `API_KEY`.
2. Buat folder platform (sekali saja, file yang sudah ada tidak ditimpa):

   ```bash
   flutter create --project-name rpl_keamanan .
   ```

3. Unduh package lalu jalankan:

   ```bash
   flutter pub get
   flutter run
   ```

4. Jalankan test:

   ```bash
   flutter test
   ```

## Struktur

```
lib/
├── main.dart
├── config/        app_config.dart, dependency_injector.dart
├── models/        user.dart, post.dart
├── repositories/  user_repository(.dart|_impl.dart), post_repository(.dart|_impl.dart)
├── services/      api_service.dart, secure_storage_service.dart
├── utils/         validators.dart, logger.dart
├── screens/       login, home, user_list, post_list, validation_form
└── widgets/       user_card.dart
test/
├── widget_test.dart
└── utils/         validators_test.dart, logger_test.dart
```
