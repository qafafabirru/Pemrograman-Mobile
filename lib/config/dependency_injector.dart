import 'package:flutter/widgets.dart';

import '../repositories/post_repository.dart';
import '../repositories/post_repository_impl.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import '../services/api_service.dart';
import '../services/secure_storage_service.dart';

/// Penyedia dependency aplikasi (Latihan 2).
///
/// Memakai singleton pattern: hanya ada satu [DependencyInjector]
/// sehingga hanya ada satu [ApiService] yang dipakai bersama oleh
/// semua repository.
class DependencyInjector {
  DependencyInjector._internal();

  /// Instance tunggal (singleton).
  static final DependencyInjector instance = DependencyInjector._internal();

  /// Satu-satunya [ApiService] di aplikasi.
  late final ApiService apiService = ApiService();

  /// Service penyimpanan aman untuk token.
  late final SecureStorageService secureStorage = SecureStorageService();

  /// Repository pengguna yang memakai [apiService] bersama.
  late final UserRepository userRepository =
      UserRepositoryImpl(apiService: apiService);

  /// Repository post yang memakai [apiService] bersama.
  late final PostRepository postRepository =
      PostRepositoryImpl(apiService: apiService);
}

/// InheritedWidget yang menyediakan [DependencyInjector] ke widget tree.
///
/// Dipasang paling atas di `main.dart`, lalu widget di bawahnya cukup
/// memanggil `DependencyProvider.of(context)`.
class DependencyProvider extends InheritedWidget {
  /// Injector yang dibagikan ke seluruh widget di bawahnya.
  final DependencyInjector injector;

  /// Membuat provider untuk [injector] dengan [child] sebagai subtree.
  const DependencyProvider({
    super.key,
    required this.injector,
    required super.child,
  });

  /// Mengambil injector dari dalam method `build`.
  static DependencyInjector of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<DependencyProvider>();
    assert(provider != null, 'DependencyProvider tidak ditemukan di atas widget ini');
    return provider!.injector;
  }

  /// Mengambil injector dari luar `build` (misalnya di `onPressed`
  /// atau `didChangeDependencies`) tanpa mendaftarkan dependency.
  static DependencyInjector read(BuildContext context) {
    final provider = context.getInheritedWidgetOfExactType<DependencyProvider>();
    assert(provider != null, 'DependencyProvider tidak ditemukan di atas widget ini');
    return provider!.injector;
  }

  @override
  bool updateShouldNotify(DependencyProvider oldWidget) =>
      injector != oldWidget.injector;
}
