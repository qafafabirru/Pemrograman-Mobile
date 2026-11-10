import '../models/post.dart';

/// Abstraksi repository untuk mengelola data post (Latihan 1).
abstract class PostRepository {
  /// Mengambil daftar semua post.
  ///
  /// Mengembalikan [List<Post>] jika berhasil.
  /// Melempar [Exception] jika terjadi error.
  Future<List<Post>> getPosts();
}
