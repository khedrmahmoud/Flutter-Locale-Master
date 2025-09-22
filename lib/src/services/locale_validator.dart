import 'package:flutter/widgets.dart';

import 'interfaces.dart';

/// Implementation of LocaleValidator for validating and converting locales.
class DefaultLocaleValidator implements LocaleValidator {
  /// Basic validation - just check if language code is not empty and reasonable length.
  @override
  bool isValidLocale(String locale) {
    try {
      final parsed = parseLocale(locale);
      // Basic validation: language code should be 2-3 characters
      final langCode = parsed.languageCode;
      return langCode.isNotEmpty && langCode.length >= 2 && langCode.length <= 3;
    } catch (e) {
      return false;
    }
  }

  @override
  Locale parseLocale(String locale) {
    // Handle formats like 'en', 'en-US', 'en_US'
    final parts = locale.replaceAll('_', '-').split('-');
    final languageCode = parts[0].toLowerCase();

    if (parts.length > 1) {
      final countryCode = parts[1].toUpperCase();
      return Locale(languageCode, countryCode);
    }

    return Locale(languageCode);
  }

  @override
  String formatLocale(Locale locale) {
    if (locale.countryCode != null) {
      return '${locale.languageCode}-${locale.countryCode}';
    }
    return locale.languageCode;
  }
}