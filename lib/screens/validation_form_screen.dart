import 'package:flutter/material.dart';

import '../utils/validators.dart';

/// Halaman demo validasi dan sanitasi input (Latihan 3).
///
/// Setiap field divalidasi dengan [Validators]. Setelah valid, nilai
/// teks disanitasi dengan [Validators.sanitize] sebelum ditampilkan.
class ValidationFormScreen extends StatefulWidget {
  /// Membuat [ValidationFormScreen].
  const ValidationFormScreen({super.key});

  @override
  State<ValidationFormScreen> createState() => _ValidationFormScreenState();
}

class _ValidationFormScreenState extends State<ValidationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _urlController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _urlController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Memvalidasi form lalu menampilkan hasil yang sudah disanitasi.
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final name = Validators.sanitize(_nameController.text);
    final email = Validators.sanitize(_emailController.text);
    final phone = _phoneController.text.trim();
    final url = Validators.sanitize(_urlController.text);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data valid & tersanitasi'),
        content: Text(
          'Nama: $name\n'
          'Email: $email\n'
          'Telepon: $phone\n'
          'Website: $url\n'
          'Password: ******** (tidak ditampilkan)',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Validasi Input'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Coba ketik <b>Budi</b>',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => Validators.validateText(
                  v,
                  fieldName: 'Nama',
                  minLength: 3,
                  maxLength: 50,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  hintText: '10-13 digit angka',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validatePhone,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _urlController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Website',
                  hintText: 'https://contoh.com',
                  prefixIcon: Icon(Icons.link),
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validateUrl,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Min. 8, huruf kapital, angka, simbol',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: const Text('Validasi & Simpan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
