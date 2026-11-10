import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service untuk menyimpan token secara terenkripsi (dari pertemuan 5).
class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  /// Menyimpan [token].
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Membaca token, atau `null` jika belum ada.
  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  /// Menghapus token.
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
