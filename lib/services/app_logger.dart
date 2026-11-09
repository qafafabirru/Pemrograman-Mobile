import 'package:flutter/foundation.dart';

/// Logger sederhana: hanya aktif saat mode debug.
/// JANGAN pernah memasukkan token, password, PIN, atau email ke pesan log.
class AppLogger {
  static void d(String message) {
    if (kDebugMode) {
      debugPrint('[LOG] $message');
    }
  }
}