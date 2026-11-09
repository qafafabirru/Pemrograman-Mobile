import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../models/user.dart';
import 'app_logger.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration defaultTimeout = Duration(seconds: 10);

  /// Helper GET + error handling (dipakai semua endpoint).
  Future<dynamic> _getJson(String path, Duration timeout) async {
    try {
      AppLogger.d('Request GET: $path');
      final response =
          await http.get(Uri.parse('$_baseUrl$path')).timeout(timeout);

      // Logging aman: hanya status code
      AppLogger.d('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException(
          'Gagal memuat data. Status: ${response.statusCode}',
        );
      }
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw ApiException(
        'Request timeout (${timeout.inSeconds} detik). Periksa koneksi internet Anda.',
      );
    } on SocketException {
      throw ApiException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on http.ClientException {
      throw ApiException('Tidak dapat terhubung ke server.');
    } on FormatException {
      throw ApiException('Format data tidak valid.');
    } catch (_) {
      throw ApiException('Terjadi kesalahan yang tidak terduga.');
    }
  }

  // GET /users (timeout bisa dikonfigurasi, default 10 detik)
  Future<List<User>> getUsers({Duration timeout = defaultTimeout}) async {
    final data = await _getJson('/users', timeout) as List<dynamic>;
    return data
        .map((json) => User.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // GET /users/{id}
  Future<User> getUserById(int id,
      {Duration timeout = defaultTimeout}) async {
    final data = await _getJson('/users/$id', timeout) as Map<String, dynamic>;
    return User.fromJson(data);
  }

  // GET /posts
  Future<List<Post>> getPosts({Duration timeout = defaultTimeout}) async {
    final data = await _getJson('/posts', timeout) as List<dynamic>;
    return data
        .map((json) => Post.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Simulasi login untuk mendapatkan token
  Future<String> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.trim().isEmpty || password.isEmpty) {
      throw ApiException('Email dan password tidak boleh kosong');
    }

    // Token dummy (di aplikasi nyata, token berasal dari server)
    final token = 'dummy_token_${DateTime.now().millisecondsSinceEpoch}';

    // Logging aman: tidak mencetak token maupun email
    AppLogger.d('Login berhasil');
    return token;
  }
}