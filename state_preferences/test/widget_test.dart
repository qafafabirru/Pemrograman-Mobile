import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:state_preferences/main.dart';

void main() {
  testWidgets('Home menampilkan sapaan tamu', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Selamat datang, Tamu!'), findsOneWidget);
  });
}
