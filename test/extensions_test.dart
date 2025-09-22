import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_locale_master/src/extensions/extensions.dart';
import 'package:flutter_locale_master/src/controllers/locale_controller.dart';
import 'package:flutter_locale_master/src/providers/asset_lang_provider.dart';
import 'package:flutter_locale_master/src/widgets/providers/localization_provider.dart';

void main() {
  group('BuildContext Extensions', () {
    late LocaleController controller;
    late AssetLangProvider provider;

    setUp(() async {
      provider = AssetLangProvider(basePath: 'lang/');
      await provider.initialize();
      controller = LocaleController(provider: provider);
      
      // Load test translations
      provider.loadNamespace('', 'en', {
        'greeting': 'Hello :name!',
        'welcome': 'Welcome',
        'items': 'item|items',
      });
    });

    testWidgets('should translate simple key', (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: LocalizationProvider(
            controller: controller,
            provider: provider,
            child: Builder(
              builder: (context) {
                return Text(context.tr('greeting'));
              },
            ),
          ),
        ),
      );

      expect(find.text('Hello :name!'), findsOneWidget);
    });

    testWidgets('should translate with parameters', (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: LocalizationProvider(
            controller: controller,
            provider: provider,
            child: Builder(
              builder: (context) {
                return Text(context.tr('greeting', parameters: {'name': 'John'}));
              },
            ),
          ),
        ),
      );

      expect(find.text('Hello John!'), findsOneWidget);
    });

    testWidgets('should translate plural', (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: LocalizationProvider(
            controller: controller,
            provider: provider,
            child: Builder(
              builder: (context) {
                return Text(context.plural('items', 1));
              },
            ),
          ),
        ),
      );

      expect(find.text('item'), findsOneWidget);
    });

    testWidgets('should translate plural with multiple items', (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: LocalizationProvider(
            controller: controller,
            provider: provider,
            child: Builder(
              builder: (context) {
                return Text(context.plural('items', 3));
              },
            ),
          ),
        ),
      );

      expect(find.text('items'), findsOneWidget);
    });

    testWidgets('should get current locale', (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: LocalizationProvider(
            controller: controller,
            provider: provider,
            child: Builder(
              builder: (context) {
                expect(context.currentLocale, 'en');
                return const Text('Test');
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should get text direction', (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: LocalizationProvider(
            controller: controller,
            provider: provider,
            child: Builder(
              builder: (context) {
                expect(context.textDirection, TextDirection.ltr);
                return const Text('Test');
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should check if RTL', (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: LocalizationProvider(
            controller: controller,
            provider: provider,
            child: Builder(
              builder: (context) {
                expect(context.isRTL, false);
                return const Text('Test');
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should get localization provider', (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: LocalizationProvider(
            controller: controller,
            provider: provider,
            child: Builder(
              builder: (context) {
                expect(context.localizationProvider, isNotNull);
                return const Text('Test');
              },
            ),
          ),
        ),
      );
    });
  });
}