/// Interface for language providers that handle translation loading and management.
///
/// Implementations should support:
/// - Loading translations from various sources (files, assets, etc.)
/// - Namespace support for organizing translations
/// - Parameter replacement and pluralization
/// - Fallback locales
/// - Caching for performance
abstract class LangProvider {
  /// Sets the current locale for translations.
  ///
  /// If the locale is not available, implementations should fall back
  /// to the fallback locale.
  void setLocale(String locale);

  /// Gets the current locale.
  String getLocale();

  /// Sets the fallback locale to use when translations are not found.
  void setFallbackLocale(String locale);

  /// Gets the fallback locale.
  String getFallbackLocale();

  /// Translates a key with optional parameters and namespace.
  ///
  /// [key] The translation key to look up.
  /// [parameters] Optional parameters to replace in the translation.
  /// [locale] Optional locale override (defaults to current locale).
  /// [namespace] Optional namespace for the translation.
  ///
  /// Returns the translated string, or the key if not found.
  String t(
    String key, {
    Map<String, dynamic>? parameters,
    String? locale,
    String? namespace,
  });

  /// Translates a key with pluralization based on count.
  ///
  /// [key] The translation key to look up.
  /// [count] The count to determine singular/plural form.
  /// [parameters] Optional parameters to replace in the translation.
  /// [locale] Optional locale override (defaults to current locale).
  /// [namespace] Optional namespace for the translation.
  ///
  /// Returns the translated string with pluralization applied.
  String choice(
    String key,
    int count, {
    Map<String, dynamic>? parameters,
    String? locale,
    String? namespace,
  });

  /// Translates a field key with automatic "fields" namespace.
  ///
  /// [key] The field translation key.
  /// [locale] Optional locale override.
  /// [namespace] Optional namespace override (defaults to "fields").
  ///
  /// Returns the translated field name.
  String field(String key, {String? locale, String? namespace});

  /// Checks if a translation key exists.
  ///
  /// [key] The translation key to check.
  /// [locale] Optional locale override.
  /// [namespace] Optional namespace for the translation.
  ///
  /// Returns true if the key exists in any namespace or fallback locale.
  bool has(String key, {String? locale, String? namespace});

  /// Gets a translation without parameter replacement.
  ///
  /// [key] The translation key to look up.
  /// [locale] Optional locale override.
  /// [namespace] Optional namespace for the translation.
  ///
  /// Returns the raw translation string, or null if not found.
  String? get(String key, {String? locale, String? namespace});

  /// Loads translations for a specific namespace and locale.
  ///
  /// [namespace] The namespace for the translations.
  /// [locale] The locale for the translations.
  /// [translations] Map of key-value translation pairs.
  void loadNamespace(
    String namespace,
    String locale,
    Map<String, String> translations,
  );

  /// Clears any cached translations, forcing reload on next access.
  void clearCache();

  /// Gets the list of available locales.
  ///
  /// Returns a list of locale codes that have translations available.
  List<String> getAvailableLocales();

  /// Adds a custom parameter replacer function.
  ///
  /// [replacer] A function that takes (key, value, parameters) and returns
  /// the replacement string. Return ':key' to use default replacement.
  void addParameterReplacer(
    String Function(
      String key,
      dynamic value,
      Map<String, dynamic> parameters,
    ) replacer,
  );
}
