/// Model data pengguna dari endpoint `/users` JSONPlaceholder.
class User {
  /// ID unik pengguna.
  final int id;

  /// Nama lengkap pengguna.
  final String name;

  /// Username pengguna.
  final String username;

  /// Alamat email pengguna.
  final String email;

  /// Nomor telepon pengguna.
  final String phone;

  /// Alamat website pengguna.
  final String website;

  /// Nama perusahaan tempat pengguna bekerja.
  final String companyName;

  /// Membuat objek [User].
  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.companyName,
  });

  /// Membuat [User] dari data JSON hasil response API.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      companyName: json['company']?['name'] ?? '',
    );
  }

  /// Huruf pertama nama (dipakai sebagai avatar).
  String get initial {
    if (name.isEmpty) return '?';
    return name[0].toUpperCase();
  }
}
