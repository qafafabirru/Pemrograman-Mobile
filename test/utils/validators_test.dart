import 'package:flutter_test/flutter_test.dart';
import 'package:rpl_keamanan/utils/validators.dart';

/// Unit test untuk [Validators] (Latihan 5).
void main() {
  group('isValidEmail', () {
    test('email normal valid', () {
      expect(Validators.isValidEmail('budi@students.amikom.ac.id'), isTrue);
    });
    test('tanpa @ tidak valid', () {
      expect(Validators.isValidEmail('budi.amikom.ac.id'), isFalse);
    });
    test('tanpa domain tidak valid', () {
      expect(Validators.isValidEmail('budi@'), isFalse);
    });
    test('domain tanpa titik tidak valid', () {
      expect(Validators.isValidEmail('budi@amikom'), isFalse);
    });
    test('mengandung spasi tidak valid', () {
      expect(Validators.isValidEmail('bu di@amikom.ac.id'), isFalse);
    });
    test('string kosong tidak valid', () {
      expect(Validators.isValidEmail(''), isFalse);
    });
  });

  group('sanitize', () {
    test('tag script diubah menjadi entity', () {
      expect(
        Validators.sanitize('<script>alert("x")</script>'),
        '&lt;script&gt;alert(&quot;x&quot;)&lt;/script&gt;',
      );
    });
    test('kutip tunggal diubah', () {
      expect(Validators.sanitize("O'Reilly"), 'O&#x27;Reilly');
    });
    test('ampersand diubah tanpa dobel encode', () {
      expect(Validators.sanitize('a & <b>'), 'a &amp; &lt;b&gt;');
    });
    test('spasi di awal dan akhir dihapus', () {
      expect(Validators.sanitize('   halo   '), 'halo');
    });
    test('teks biasa tidak berubah', () {
      expect(Validators.sanitize('Budi Santoso'), 'Budi Santoso');
    });
  });

  group('validateText', () {
    test('null -> pesan kosong', () {
      expect(Validators.validateText(null, fieldName: 'Nama'),
          'Nama tidak boleh kosong');
    });
    test('hanya spasi -> pesan kosong', () {
      expect(Validators.validateText('   ', fieldName: 'Nama'),
          'Nama tidak boleh kosong');
    });
    test('terlalu pendek', () {
      expect(Validators.validateText('ab', fieldName: 'Nama', minLength: 3),
          'Nama harus antara 3-100 karakter');
    });
    test('tepat 100 karakter valid', () {
      expect(Validators.validateText('a' * 100), isNull);
    });
    test('101 karakter tidak valid', () {
      expect(Validators.validateText('a' * 101, fieldName: 'Nama'),
          'Nama harus antara 1-100 karakter');
    });
    test('teks normal valid', () {
      expect(Validators.validateText('Budi'), isNull);
    });
  });

  group('validateEmail', () {
    test('kosong', () {
      expect(Validators.validateEmail(''), 'Email tidak boleh kosong');
    });
    test('format salah', () {
      expect(Validators.validateEmail('abc'), 'Format email tidak valid');
    });
    test('valid (dengan spasi di pinggir)', () {
      expect(Validators.validateEmail('  budi@mail.com '), isNull);
    });
  });

  group('validatePhone (Latihan 3)', () {
    test('11 digit valid', () {
      expect(Validators.validatePhone('08123456789'), isNull);
    });
    test('13 digit valid', () {
      expect(Validators.validatePhone('0812345678901'), isNull);
    });
    test('9 digit terlalu pendek', () {
      expect(Validators.validatePhone('081234567'),
          'Nomor telepon harus 10-13 digit');
    });
    test('14 digit terlalu panjang', () {
      expect(Validators.validatePhone('08123456789012'),
          'Nomor telepon harus 10-13 digit');
    });
    test('mengandung huruf/simbol', () {
      expect(Validators.validatePhone('0812-3456-789'),
          'Nomor telepon hanya boleh berisi angka');
    });
  });

  group('validateUrl (Latihan 3)', () {
    test('https valid', () {
      expect(Validators.validateUrl('https://amikom.ac.id'), isNull);
    });
    test('http dengan path valid', () {
      expect(Validators.validateUrl('http://contoh.com/halaman?id=1'), isNull);
    });
    test('tanpa skema tidak valid', () {
      expect(Validators.validateUrl('amikom.ac.id'),
          'URL harus diawali http:// atau https://');
    });
    test('skema ftp tidak valid', () {
      expect(Validators.validateUrl('ftp://contoh.com'),
          'URL harus diawali http:// atau https://');
    });
    test('tanpa domain tidak valid', () {
      expect(Validators.validateUrl('https://'), 'Format URL tidak valid');
    });
  });

  group('validatePassword (Latihan 3)', () {
    test('password kuat valid', () {
      expect(Validators.validatePassword('Rahasia123!'), isNull);
    });
    test('kurang dari 8 karakter', () {
      expect(Validators.validatePassword('Ab1!'), 'Password minimal 8 karakter');
    });
    test('tanpa huruf kapital', () {
      expect(Validators.validatePassword('rahasia123!'),
          'Password harus mengandung huruf kapital');
    });
    test('tanpa angka', () {
      expect(Validators.validatePassword('Rahasiaku!'),
          'Password harus mengandung angka');
    });
    test('tanpa simbol', () {
      expect(Validators.validatePassword('Rahasia123'),
          'Password harus mengandung simbol');
    });
  });
}
