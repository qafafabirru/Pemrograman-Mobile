import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/logger.dart';

/// Service untuk menyimpan data sensitif (token, PIN) secara terenkripsi.
///
/// Di Android memakai EncryptedSharedPreferences, di iOS memakai Keychain.
/// Nilai token/PIN tidak pernah dicetak ke log.
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _tokenKey = 'auth_token';
  static const String _pinKey = 'user_pin';

  /// Menyimpan [token] login.
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    Logger.info('Token disimpan');
  }

  /// Membaca token login, atau `null` jika belum ada.
  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  /// Menghapus token login (logout).
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    Logger.info('Token dihapus');
  }

  /// Menyimpan [pin] pengguna.
  Future<void> savePin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
    Logger.info('PIN disimpan');
  }

  /// Membaca PIN pengguna, atau `null` jika belum ada.
  Future<String?> getPin() async {
    return _storage.read(key: _pinKey);
  }

  /// Menghapus semua data di secure storage.
  Future<void> deleteAll() async {
    await _storage.deleteAll();
    Logger.info('Semua data secure storage dihapus');
  }

  /// Mengecek apakah token login sudah tersimpan.
  Future<bool> hasToken() async {
    return _storage.containsKey(key: _tokenKey);
  }
}
