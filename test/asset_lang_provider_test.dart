import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_locale_master/src/providers/asset_lang_provider.dart';

void main() {
  group('AssetLangProvider', () {
    late AssetLangProvider provider;

    setUp(() async {
      provider = AssetLangProvider(basePath: 'lang/');
      await provider.initialize();
    });

    test('should initialize with default locale', () {
      expect(provider.getLocale(), 'en');
      expect(provider.getFallbackLocale(), 'en');
    });

    test('should set locale correctly', () {
      provider.setLocale('en');
      expect(provider.getLocale(), 'en');
    });

    test('should set fallback locale correctly', () {
      provider.setFallbackLocale('fr');
      expect(provider.getFallbackLocale(), 'fr');
    });

    test('should handle missing keys', () {
      provider.setLocale('en');
      expect(provider.t('nonexistent'), 'nonexistent');
      expect(provider.has('nonexistent'), false);
    });

    test('should handle field translations', () {
      provider.setLocale('en');
      expect(provider.field('test'), 'test'); // No fields namespace, returns key
    });

    test('should load namespace translations', () {
      provider.loadNamespace('auth', 'en', {'login': 'Sign In'});
      expect(provider.t('login', namespace: 'auth'), 'Sign In');
    });

    test('should clear cache', () {
      provider.setLocale('en');
      provider.clearCache();
      expect(provider.getLocale(), 'en'); // Should still have the locale set
    });

    test('should get available locales', () {
      final locales = provider.getAvailableLocales();
      expect(locales, isNotEmpty);
      expect(locales, contains('en'));
    });

    test('should handle parameter replacers', () {
      provider.addParameterReplacer((key, value, parameters) {
        if (key == 'test') {
          return 'replaced';
        }
        return ':$key';
      });

      provider.loadNamespace('', 'en', {'test': ':test'});
      provider.setLocale('en');
      expect(provider.t('test', parameters: {'test': 'value'}), 'replaced');
    });
  });
}