import 'package:flutter_test/flutter_test.dart';
import 'package:rpl_keamanan/utils/logger.dart';

/// Unit test untuk penyamaran data sensitif di [Logger] (Latihan 4).
void main() {
  test('token disamarkan', () {
    expect(Logger.mask('token=dummy_token_123'), 'token=***');
  });
  test('API key disamarkan', () {
    expect(Logger.mask('API_KEY: abc123'), 'API_KEY: ***');
  });
  test('email disamarkan', () {
    expect(Logger.mask('login oleh budi@mail.com'), 'login oleh ***@***');
  });
  test('pesan biasa tidak berubah', () {
    expect(Logger.mask('[GET] /users'), '[GET] /users');
  });
}
