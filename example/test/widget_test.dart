// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_locale_master/flutter_locale_master.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_locale_master_example/main.dart';

void main() {
  late FlutterLocaleMaster localeMaster;
  setUp(() async {
    localeMaster = await FlutterLocaleMaster.initialize(
      basePath: 'lang/',
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
      fallbackLocale: const Locale('en'),
    );
  });
  testWidgets('Localization app loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(localeMaster: localeMaster));

    // Wait for initialization
    await tester.pumpAndSettle();

    // Verify that our app shows the welcome message in the app bar
    expect(find.text('Welcome to Flutter Locale Master'), findsWidgets);

    // Verify language selector is present
    expect(find.byType(PopupMenuButton<String>), findsOneWidget);

    // Verify we can find basic translation sections
    expect(find.text('Basic Translations'), findsOneWidget);
    expect(find.text('Pluralization'), findsOneWidget);
  });
}
