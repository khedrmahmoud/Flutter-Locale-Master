import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_locale_master/src/controllers/locale_controller.dart';
import 'package:flutter_locale_master/src/providers/asset_lang_provider.dart';

void main() {
  group('LocaleController', () {
    late LocaleController controller;
    late AssetLangProvider provider;

    setUp(() {
      provider = AssetLangProvider(basePath: 'lang/');
      controller = LocaleController(provider: provider);
    });

    test('should initialize with default values', () {
      expect(controller.locale.languageCode, 'en');
      expect(controller.fallbackLocale.languageCode, 'en');
      expect(controller.isInitialized, false);
    });

    test('should set locale correctly', () {
      controller.setLocale(const Locale('fr'));
      expect(controller.locale.languageCode, 'fr');
    });

    test('should set locale from string', () {
      controller.setLocaleFromString('ar');
      expect(controller.locale.languageCode, 'ar');
    });

    test('should set fallback locale correctly', () {
      controller.setFallbackLocale(const Locale('fr'));
      expect(controller.fallbackLocale.languageCode, 'fr');
    });

    test('should set fallback locale from string', () {
      controller.setFallbackLocaleFromString('de');
      expect(controller.fallbackLocale.languageCode, 'de');
    });

    test('should toggle between locales', () {
      controller.setLocale(const Locale('en'));
      controller.toggleLocale(const Locale('en'), const Locale('fr'));
      expect(controller.locale.languageCode, 'fr');

      controller.toggleLocale(const Locale('en'), const Locale('fr'));
      expect(controller.locale.languageCode, 'en');
    });

    test('should check current locale', () {
      controller.setLocale(const Locale('en'));
      expect(controller.isCurrentLocale(const Locale('en')), true);
      expect(controller.isCurrentLocale(const Locale('fr')), false);
    });

    test('should check current language', () {
      controller.setLocale(const Locale('en'));
      expect(controller.isCurrentLanguage('en'), true);
      expect(controller.isCurrentLanguage('fr'), false);
    });

    test('should get supported locales', () {
      final locales = controller.getSupportedLocales();
      expect(locales, isNotEmpty);
      expect(locales, contains('en'));
    });

    test('should notify listeners when locale changes', () {
      bool notified = false;
      controller.addListener(() {
        notified = true;
      });

      controller.setLocale(const Locale('fr'));
      expect(notified, true);
    });

    test('should not notify listeners when setting same locale', () {
      controller.setLocale(const Locale('en'));
      bool notified = false;
      controller.addListener(() {
        notified = true;
      });

      controller.setLocale(const Locale('en'));
      expect(notified, false);
    });
  });
}
