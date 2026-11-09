import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app_logger.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  static const String _tokenKey = 'auth_token';
  static const String _pinKey = 'user_pin';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    AppLogger.d('Token berhasil disimpan');
  }

  Future<String?> getToken() async {
    final token = await _storage.read(key: _tokenKey);
    AppLogger.d(token != null ? 'Token ditemukan' : 'Token tidak ditemukan');
    return token;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    AppLogger.d('Token berhasil dihapus');
  }

  Future<void> savePin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
    AppLogger.d('PIN berhasil disimpan');
  }

  Future<String?> getPin() async {
    return await _storage.read(key: _pinKey);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
    AppLogger.d('Semua data berhasil dihapus');
  }

  Future<bool> hasToken() async {
    return await _storage.containsKey(key: _tokenKey);
  }
}