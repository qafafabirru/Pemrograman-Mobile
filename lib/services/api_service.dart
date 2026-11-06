import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../utils/logger.dart';

/// Exception API dengan pesan yang aman ditampilkan ke pengguna.
///
/// Pesan tidak memuat detail teknis (stack trace, URL lengkap, header)
/// agar tidak membocorkan informasi internal aplikasi.
class ApiException implements Exception {
  /// Pesan error yang ramah pengguna.
  final String message;

  /// Membuat [ApiException] dengan [message].
  ApiException(this.message);

  @override
  String toString() => message;
}

/// Service untuk komunikasi HTTP dengan REST API.
///
/// Class ini menangani semua request HTTP ke API, termasuk
/// penanganan error dan timeout. Base URL dan API key diambil dari
/// [AppConfig] (file `.env`), tidak ditulis langsung di kode.
class ApiService {
  final http.Client _client;
  final String _baseUrl;

  /// Timeout default untuk setiap request.
  static const Duration defaultTimeout =
      Duration(seconds: AppConfig.timeoutSeconds);

  /// Membuat [ApiService].
  ///
  /// [client] dan [baseUrl] dapat diganti saat pengujian
  /// (dependency injection). Jika tidak diisi, dipakai `http.Client()`
  /// dan [AppConfig.baseUrl].
  ApiService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? AppConfig.baseUrl;

  /// Mengambil daftar pengguna dari endpoint `/users`.
  ///
  /// Mengembalikan [List<User>] jika berhasil.
  /// Melempar [ApiException] dengan pesan yang ramah pengguna jika gagal.
  Future<List<User>> getUsers() async {
    final data = await _getJson('/users') as List<dynamic>;
    return data
        .map((json) => User.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Mengambil pengguna berdasarkan [id] dari endpoint `/users/{id}`.
  Future<User> getUserById(int id) async {
    final data = await _getJson('/users/$id') as Map<String, dynamic>;
    return User.fromJson(data);
  }

  /// Mengambil daftar post dari endpoint `/posts` (Latihan 1).
  Future<List<Post>> getPosts() async {
    final data = await _getJson('/posts') as List<dynamic>;
    return data
        .map((json) => Post.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Simulasi login untuk mendapatkan token.
  ///
  /// Di aplikasi nyata token berasal dari server. Email, password,
  /// dan token tidak pernah dicetak ke log.
  Future<String> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.trim().isEmpty || password.isEmpty) {
      throw ApiException('Email dan password tidak boleh kosong');
    }

    final token = 'dummy_token_${DateTime.now().millisecondsSinceEpoch}';
    Logger.info('Login berhasil');
    return token;
  }

  /// Helper GET + penanganan error yang dipakai semua endpoint.
  Future<dynamic> _getJson(String endpoint) async {
    try {
      _logRequest('GET', endpoint);

      final response = await _client
          .get(Uri.parse('$_baseUrl$endpoint'), headers: _buildHeaders())
          .timeout(defaultTimeout);

      _logResponse(response.statusCode);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw ApiException('Gagal memuat data. Status: ${response.statusCode}');
    } on ApiException {
      rethrow;
    } on TimeoutException {
      Logger.warning('Request timeout: $endpoint');
      throw ApiException('Request timeout. Periksa koneksi internet Anda.');
    } on SocketException {
      Logger.warning('Tidak ada koneksi: $endpoint');
      throw ApiException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on http.ClientException catch (e) {
      Logger.error('Client error', e);
      throw ApiException('Tidak dapat terhubung ke server.');
    } on FormatException catch (e) {
      Logger.error('Format data tidak valid', e);
      throw ApiException('Format data tidak valid.');
    } catch (e) {
      Logger.error('Kesalahan tak terduga', e);
      throw ApiException('Terjadi kesalahan yang tidak terduga.');
    }
  }

  /// Membangun header untuk request HTTP.
  ///
  /// Menyertakan API key dari konfigurasi (tidak di-hardcode).
  Map<String, String> _buildHeaders() {
    return {
      'Content-Type': 'application/json',
      'X-API-Key': AppConfig.apiKey,
    };
  }

  /// Logging request yang aman (tidak mencetak header/API key).
  void _logRequest(String method, String endpoint) {
    Logger.debug('[$method] $endpoint');
  }

  /// Logging response yang aman (hanya status code, bukan body).
  void _logResponse(int statusCode) {
    Logger.debug('Response status: $statusCode');
  }

  /// Menutup HTTP client.
  void dispose() {
    _client.close();
  }
}
