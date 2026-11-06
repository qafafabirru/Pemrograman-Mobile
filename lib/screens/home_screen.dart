import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../config/dependency_injector.dart';
import 'login_screen.dart';
import 'post_list_screen.dart';
import 'user_list_screen.dart';
import 'validation_form_screen.dart';

/// Halaman utama setelah login.
///
/// Menampilkan status konfigurasi `.env` dan menu ke halaman lain.
/// Repository diambil dari [DependencyProvider] lalu disuntikkan ke
/// halaman tujuan (dependency injection lewat constructor).
class HomeScreen extends StatelessWidget {
  /// Membuat [HomeScreen].
  const HomeScreen({super.key});

  /// Logout dengan konfirmasi, lalu kembali ke [LoginScreen].
  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;

    await DependencyProvider.read(context).secureStorage.deleteToken();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final di = DependencyProvider.of(context);
    final configured = AppConfig.isConfigured();

    return Scaffold(
      appBar: AppBar(
        title: const Text('RPL & Keamanan Kode'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: configured ? Colors.green[50] : Colors.red[50],
            child: ListTile(
              leading: Icon(
                configured ? Icons.check_circle : Icons.error,
                color: configured ? Colors.green : Colors.red,
              ),
              title: Text(
                configured ? 'Konfigurasi .env termuat' : '.env tidak lengkap',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                configured
                    ? 'BASE_URL dan API_KEY dibaca dari file .env'
                    : 'Periksa BASE_URL dan API_KEY di file .env',
              ),
            ),
          ),
          const SizedBox(height: 16),
          _MenuButton(
            icon: Icons.people,
            label: 'Daftar Pengguna',
            color: Colors.deepPurple,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserListScreen(repository: di.userRepository),
              ),
            ),
          ),
          _MenuButton(
            icon: Icons.article,
            label: 'Daftar Posts',
            color: Colors.teal,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PostListScreen(repository: di.postRepository),
              ),
            ),
          ),
          _MenuButton(
            icon: Icons.fact_check,
            label: 'Form Validasi Input',
            color: Colors.orange,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ValidationFormScreen()),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.amber[50],
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Catatan keamanan:\n'
                '1. Base URL & API key disimpan di .env (tidak di-commit).\n'
                '2. Input divalidasi dan disanitasi sebelum diproses.\n'
                '3. Log hanya muncul di mode debug dan tanpa data sensitif.\n'
                '4. Token login disimpan terenkripsi di secure storage.',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tombol menu lebar penuh di [HomeScreen].
class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
