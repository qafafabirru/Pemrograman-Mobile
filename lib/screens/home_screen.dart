import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../config/dependency_injector.dart';
import 'post_list_screen.dart';
import 'user_list_screen.dart';
import 'validation_form_screen.dart';

/// Halaman utama berisi status konfigurasi `.env` dan menu.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final di = DependencyProvider.of(context);
    final configured = AppConfig.isConfigured();

    return Scaffold(
      appBar: AppBar(
        title: const Text('RPL & Keamanan Kode'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
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
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.people),
            label: const Text('Daftar Pengguna'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserListScreen(repository: di.userRepository),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.article),
            label: const Text('Daftar Post'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PostListScreen(repository: di.postRepository),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.fact_check),
            label: const Text('Form Validasi'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ValidationFormScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
