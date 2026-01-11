import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:notes_crud_app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // Mock SharedPreferences supaya tidak error di test
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App shows Splash then navigates to Login when not logged in',
      (WidgetTester tester) async {
    // Jalankan app
    await tester.pumpWidget(const MyApp());

    // 1) Splash tampil dulu
    expect(find.text('Notes CRUD App'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 2) Tunggu animasi/delay splash (2 detik)
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // 3) Karena belum login (prefs kosong), harus masuk ke Login
    expect(find.text('Login'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);
  });

  testWidgets('If session logged in, app navigates to Home',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'is_logged_in': true,
      'username': 'TestUser',
    });

    await tester.pumpWidget(const MyApp());

    // Splash tampil
    expect(find.text('Notes CRUD App'), findsOneWidget);

    // Tunggu pindah ke Home
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Home punya header Welcome
    expect(find.textContaining('Welcome'), findsOneWidget);
    expect(find.text('TestUser'), findsOneWidget);
  });
}
