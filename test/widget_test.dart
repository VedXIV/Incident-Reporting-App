import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_123/main.dart';

void main() {
  testWidgets('App loads splash screen', (WidgetTester tester) async {
    // We skip Hive init in tests
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));
    expect(find.text('RespondX'), findsOneWidget);
  });
}
