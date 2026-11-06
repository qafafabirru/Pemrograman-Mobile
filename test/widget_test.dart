import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rpl_keamanan/models/user.dart';
import 'package:rpl_keamanan/widgets/user_card.dart';

/// Widget test sederhana: [UserCard] menampilkan data pengguna.
void main() {
  testWidgets('UserCard menampilkan nama, username, dan email', (tester) async {
    final user = User(
      id: 1,
      name: 'Budi Santoso',
      username: 'budi',
      email: 'budi@mail.com',
      phone: '08123456789',
      website: 'budi.com',
      companyName: 'Amikom',
    );

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: UserCard(user: user))),
    );

    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('@budi'), findsOneWidget);
    expect(find.text('budi@mail.com'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });
}
