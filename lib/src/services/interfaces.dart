import 'package:flutter/widgets.dart';

/// Core service interfaces for the Flutter Locale Master package.
/// These interfaces define the contracts for various services used throughout
/// the localization system, enabling dependency injection and testability.

/// Service for managing locale state and operations.
abstract class LocaleService {
  /// Gets the current locale.
  Locale get currentLocale;

  /// Gets the fallback locale.
  Locale get fallbackLocale;

  /// Gets the current text direction.
  TextDirection get textDirection;

  /// Checks if the current locale is RTL.
  bool get isRTL;

  /// Sets the current locale.
  void setLocale(Locale locale);

  /// Sets the fallback locale.
  void setFallbackLocale(Locale locale);

  /// Gets supported locales.
  List<String> getSupportedLocales();
}

/// Service for handling translation operations.
abstract class TranslationService {
  /// Translates a key with optional parameters and namespace.
  String translate(
    String key, {
    Map<String, dynamic>? parameters,
    String? namespace,
  });

  /// Translates with pluralization based on count.
  String plural(
    String key,
    int count, {
    Map<String, dynamic>? parameters,
    String? namespace,
  });

  /// Translates a field key.
  String field(String key, {String? namespace});

  /// Checks if a translation key exists.
  bool hasTranslation(String key, {String? namespace});
}

/// Service for loading and caching translations.
abstract class TranslationLoader {
  /// Initializes the loader.
  Future<void> initialize();

  /// Loads translations for a specific locale.
  Future<void> loadLocale(String locale);

  /// Gets a translation for the given key.
  String? getTranslation(String key, String locale, {String? namespace});

  /// Clears the translation cache.
  void clearCache();

  /// Gets available locales.
  List<String> getAvailableLocales();
}

/// Service for resolving text direction based on locale.
abstract class TextDirectionResolver {
  /// Gets the text direction for a locale.
  TextDirection getTextDirection(Locale locale);

  /// Checks if a locale is RTL.
  bool isRTL(Locale locale);
}

/// Service for detecting system locale.
abstract class LocaleDetector {
  /// Detects the system locale.
  Future<Locale> detectSystemLocale();

  /// Gets system locales in order of preference.
  Future<List<Locale>> getSystemLocales();
}

/// Service for validating and converting locales.
abstract class LocaleValidator {
  /// Validates if a locale string is valid.
  bool isValidLocale(String locale);

  /// Converts a locale string to a Locale object.
  Locale parseLocale(String locale);

  /// Formats a Locale object to string.
  String formatLocale(Locale locale);
}

/// Service for replacing parameters in translation strings.
abstract class ParameterReplacer {
  /// Replaces parameters in a message string.
  String replaceParameters(String message, Map<String, dynamic> parameters);

  /// Adds a custom parameter replacer.
  void addReplacer(String Function(String key, dynamic value, Map<String, dynamic> parameters) replacer);
}

/// Service for handling pluralization logic.
abstract class PluralizationHandler {
  /// Applies pluralization to a message based on count.
  String applyPluralization(String message, int count);

  /// Gets the plural form for a count.
  String getPluralForm(String singular, String plural, int count);
}