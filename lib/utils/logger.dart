import 'package:flutter/foundation.dart';

/// Level log yang tersedia, dari paling detail ke paling penting.
enum LogLevel { debug, info, warning, error }

/// Logger terstruktur (Latihan 4).
///
/// - Log hanya dicetak saat mode debug ([kDebugMode]); di build release
///   tidak ada log sama sekali.
/// - Setiap pesan disamarkan dulu lewat [mask] sehingga token, API key,
///   password, PIN, dan email tidak pernah tercetak ke log.
class Logger {
  Logger._();

  /// Log detail untuk keperluan debugging.
  static void debug(String message) => _log(LogLevel.debug, message);

  /// Log informasi alur aplikasi yang normal.
  static void info(String message) => _log(LogLevel.info, message);

  /// Log kondisi tidak biasa yang belum menjadi error.
  static void warning(String message) => _log(LogLevel.warning, message);

  /// Log error. Hanya tipe [error] yang dicatat, bukan isinya,
  /// agar data sensitif di dalam pesan error tidak bocor.
  static void error(String message, [Object? error]) {
    final detail = error == null ? '' : ' (${error.runtimeType})';
    _log(LogLevel.error, '$message$detail');
  }

  /// Menyamarkan data sensitif di dalam [message].
  ///
  /// Contoh: `token=abc123` menjadi `token=***`,
  /// `budi@mail.com` menjadi `***@***`.
  static String mask(String message) {
    final keyValue = RegExp(
      r'(token|api[_-]?key|password|pin)(\s*[:=]\s*)(\S+)',
      caseSensitive: false,
    );
    final email = RegExp(r'[\w.+-]+@[\w-]+(\.[\w-]+)+');
    return message
        .replaceAllMapped(keyValue, (m) => '${m[1]}${m[2]}***')
        .replaceAll(email, '***@***');
  }

  static void _log(LogLevel level, String message) {
    if (!kDebugMode) return;
    final now = DateTime.now();
    final time = '${_two(now.hour)}:${_two(now.minute)}:${_two(now.second)}';
    final tag = level.name.toUpperCase().padRight(7);
    debugPrint('[$time] [$tag] ${mask(message)}');
  }

  static String _two(int n) => n.toString().padLeft(2, '0');
}
