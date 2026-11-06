// Latihan 5: kumpulan validasi keamanan untuk input pengguna
class SecurityValidator {
  SecurityValidator._();

  // Pola karakter/teks berbahaya: tag <script>, tag HTML apa pun,
  // skema "javascript:", dan karakter yang sering dipakai untuk injeksi.
  static final RegExp _dangerousPattern = RegExp(
    r'<\s*/?\s*script|javascript\s*:|[<>{}`;]',
    caseSensitive: false,
  );

  /// true jika [input] mengandung karakter atau teks berbahaya.
  static bool containsDangerousChars(String input) {
    return _dangerousPattern.hasMatch(input);
  }

  /// Validator nama untuk TextFormField.
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (containsDangerousChars(value)) {
      return 'Nama mengandung karakter berbahaya (mis. <script>)';
    }
    if (value.trim().length > 50) {
      return 'Nama maksimal 50 karakter';
    }
    return null;
  }
}
