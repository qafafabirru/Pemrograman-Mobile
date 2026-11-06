import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

// Daftar key SharedPreferences yang dipakai di aplikasi
class PrefKeys {
  static const String userName = 'user_name';
  static const String userEmail = 'user_email';
  static const String isLoggedIn = 'is_logged_in';
  static const String isDarkMode = 'is_dark_mode'; // Latihan 1
}

// InheritedWidget: menyediakan data ke seluruh widget di bawahnya (subtree)
class UserProvider extends InheritedWidget {
  final User user;
  final Future<void> Function(User) updateUser;
  final VoidCallback logout;
  final bool isLoading;

  // Latihan 1: preferensi tema
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const UserProvider({
    super.key,
    required this.user,
    required this.updateUser,
    required this.logout,
    required this.isLoading,
    required this.isDarkMode,
    required this.toggleTheme,
    required super.child,
  });

  // of(): dipakai di build(). Widget akan di-rebuild saat data berubah.
  static UserProvider of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<UserProvider>();
    assert(provider != null, 'UserProvider tidak ditemukan di context');
    return provider!;
  }

  // read(): dipakai di initState() atau event handler (tombol).
  // Tidak mendaftarkan dependency, sehingga aman dipanggil di initState.
  static UserProvider read(BuildContext context) {
    final provider =
        context.getInheritedWidgetOfExactType<UserProvider>();
    assert(provider != null, 'UserProvider tidak ditemukan di context');
    return provider!;
  }

  // Menentukan apakah widget dependents perlu di-rebuild
  @override
  bool updateShouldNotify(UserProvider oldWidget) {
    return oldWidget.user != user ||
        oldWidget.isLoading != isLoading ||
        oldWidget.isDarkMode != isDarkMode;
  }
}

// StatefulWidget yang membungkus InheritedWidget
class UserProviderWrapper extends StatefulWidget {
  final Widget child;

  const UserProviderWrapper({super.key, required this.child});

  @override
  State<UserProviderWrapper> createState() => _UserProviderWrapperState();
}

class _UserProviderWrapperState extends State<UserProviderWrapper> {
  User _user = User(name: '', email: '');
  bool _isLoading = true;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // Memuat data user dan preferensi dari SharedPreferences
  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(PrefKeys.userName) ?? '';
    final email = prefs.getString(PrefKeys.userEmail) ?? '';
    final isLoggedIn = prefs.getBool(PrefKeys.isLoggedIn) ?? false;

    // Latihan 1: muat preferensi tema
    final isDarkMode = prefs.getBool(PrefKeys.isDarkMode) ?? false;

    if (!mounted) return;
    setState(() {
      _user = User(
        name: name,
        email: email,
        isLoggedIn: isLoggedIn,
      );
      _isDarkMode = isDarkMode;
      _isLoading = false;
    });
  }

  // Menyimpan data user ke SharedPreferences
  Future<void> _updateUser(User newUser) async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefKeys.userName, newUser.name);
    await prefs.setString(PrefKeys.userEmail, newUser.email);
    await prefs.setBool(PrefKeys.isLoggedIn, newUser.isLoggedIn);

    if (!mounted) return;
    setState(() {
      _user = newUser;
      _isLoading = false;
    });
  }

  // Logout: hapus data user (kecuali email)
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(PrefKeys.userName);
    await prefs.setBool(PrefKeys.isLoggedIn, false);

    if (!mounted) return;
    setState(() {
      _user = _user.copyWith(name: '', isLoggedIn: false);
    });
  }

  // Latihan 1: ganti tema Light/Dark lalu simpan ke SharedPreferences
  Future<void> _toggleTheme() async {
    final newValue = !_isDarkMode;
    setState(() {
      _isDarkMode = newValue;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PrefKeys.isDarkMode, newValue);
  }

  @override
  Widget build(BuildContext context) {
    return UserProvider(
      user: _user,
      updateUser: _updateUser,
      logout: _logout,
      isLoading: _isLoading,
      isDarkMode: _isDarkMode,
      toggleTheme: _toggleTheme,
      child: widget.child,
    );
  }
}
