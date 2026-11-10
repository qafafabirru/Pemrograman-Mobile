import 'package:flutter/widgets.dart';

import '../repositories/post_repository.dart';
import '../repositories/post_repository_impl.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import '../services/api_service.dart';

/// Menyediakan instance ApiService dan repository (Latihan 2).
///
/// Memakai singleton pattern sehingga hanya ada satu [ApiService]
/// yang dipakai bersama oleh semua repository.
class DependencyInjector {
  static final DependencyInjector _instance = DependencyInjector._internal();

  factory DependencyInjector() => _instance;

  DependencyInjector._internal();

  final ApiService apiService = ApiService();

  late final UserRepository userRepository =
      UserRepositoryImpl(apiService: apiService);

  late final PostRepository postRepository =
      PostRepositoryImpl(apiService: apiService);
}

/// InheritedWidget untuk menyediakan [DependencyInjector] ke widget tree.
class DependencyProvider extends InheritedWidget {
  final DependencyInjector injector;

  const DependencyProvider({
    super.key,
    required this.injector,
    required super.child,
  });

  /// Mengambil [DependencyInjector] terdekat dari [context].
  static DependencyInjector of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DependencyProvider>()!
        .injector;
  }

  @override
  bool updateShouldNotify(DependencyProvider oldWidget) =>
      injector != oldWidget.injector;
}
