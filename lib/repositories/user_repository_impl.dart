import '../models/user.dart';
import '../services/api_service.dart';
import 'user_repository.dart';

/// Implementasi konkret dari [UserRepository].
///
/// Class ini menggunakan [ApiService] untuk mengambil data dari API.
class UserRepositoryImpl implements UserRepository {
  final ApiService _apiService;

  /// Membuat repository. Jika [apiService] tidak diberikan,
  /// dibuat instance [ApiService] baru.
  UserRepositoryImpl({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  @override
  Future<List<User>> getUsers() async {
    return await _apiService.getUsers();
  }

  @override
  Future<User> getUserById(int id) async {
    if (id <= 0) {
      throw ApiException('ID pengguna harus berupa angka positif');
    }
    return await _apiService.getUserById(id);
  }

  /// Menutup resource yang digunakan.
  void dispose() {
    _apiService.dispose();
  }
}
