import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'config/app_config.dart';
import 'config/dependency_injector.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'utils/logger.dart';

/// Entry point aplikasi.
///
/// Memuat konfigurasi dari file `.env` sebelum menjalankan aplikasi,
/// lalu menyediakan dependency lewat [DependencyProvider].
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Muat file .env
  await dotenv.load(fileName: '.env');

  // Periksa konfigurasi
  if (!AppConfig.isConfigured()) {
    Logger.warning('Konfigurasi .env tidak lengkap. Periksa file .env Anda.');
  } else {
    Logger.info('Konfigurasi .env berhasil dimuat');
  }

  runApp(
    DependencyProvider(
      injector: DependencyInjector.instance,
      child: const MyApp(),
    ),
  );
}

/// Root widget aplikasi.
class MyApp extends StatelessWidget {
  /// Membuat [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RPL & Keamanan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

/// Menentukan halaman awal berdasarkan keberadaan token login.
///
/// Jika token ada di secure storage, langsung ke [HomeScreen];
/// jika tidak, ke [LoginScreen].
class AuthGate extends StatefulWidget {
  /// Membuat [AuthGate].
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Future<bool>? _hasTokenFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hasTokenFuture ??=
        DependencyProvider.read(context).secureStorage.hasToken();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasTokenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data == true ? const HomeScreen() : const LoginScreen();
      },
    );
  }
}
