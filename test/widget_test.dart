import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:proyecto_5_semestre/data/services/database_service.dart';
import 'package:proyecto_5_semestre/presentation/screens/shared/splash_screen.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  testWidgets('App runs without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

    // Verify that the app shows the splash screen.
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
