import 'package:flutter/foundation.dart';

/// Logger terstruktur dengan level debug, info, warning, dan error (Latihan 4).
///
/// Log hanya ditampilkan di mode debug ([kDebugMode]). Jangan kirim data
/// sensitif seperti token, password, atau API key ke logger ini.
class Logger {
  /// Log detail untuk keperluan debugging.
  static void debug(String message) => _log('DEBUG', message);

  /// Log informasi alur aplikasi.
  static void info(String message) => _log('INFO', message);

  /// Log peringatan.
  static void warning(String message) => _log('WARNING', message);

  /// Log error.
  static void error(String message) => _log('ERROR', message);

  static void _log(String level, String message) {
    if (kDebugMode) {
      debugPrint('[$level] $message');
    }
  }
}
