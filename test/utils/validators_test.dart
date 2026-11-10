import 'package:flutter_test/flutter_test.dart';
import 'package:rpl_keamanan/utils/validators.dart';

void main() {
  group('isValidEmail', () {
    test('email benar', () {
      expect(Validators.isValidEmail('budi@students.amikom.ac.id'), isTrue);
    });
    test('tanpa @', () {
      expect(Validators.isValidEmail('budi.amikom.ac.id'), isFalse);
    });
    test('domain tanpa titik', () {
      expect(Validators.isValidEmail('budi@amikom'), isFalse);
    });
    test('string kosong', () {
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
    test('spasi di awal dan akhir dihapus', () {
      expect(Validators.sanitize('  Budi  '), 'Budi');
    });
  });

  group('validateText', () {
    test('kosong', () {
      expect(Validators.validateText('', fieldName: 'Nama'),
          'Nama tidak boleh kosong');
    });
    test('terlalu pendek', () {
      expect(Validators.validateText('ab', fieldName: 'Nama', minLength: 3),
          'Nama harus antara 3-100 karakter');
    });
    test('terlalu panjang (101 karakter)', () {
      expect(Validators.validateText('a' * 101, fieldName: 'Nama'),
          'Nama harus antara 1-100 karakter');
    });
    test('panjang pas (100 karakter)', () {
      expect(Validators.validateText('a' * 100), isNull);
    });
  });
}
