import 'interfaces.dart';

/// Implementation of TranslationLoader that handles caching of translations.
class DefaultTranslationCache implements TranslationLoader {
  /// The translations cache: locale -> namespace -> key -> value
  final Map<String, Map<String, Map<String, String>>> _cache = {};

  /// Available locales that have been loaded.
  final List<String> _availableLocales = [];

  @override
  Future<void> initialize() async {
    // Cache initialization - no-op for now
  }

  @override
  Future<void> loadLocale(String locale) async {
    // This would be implemented by concrete loaders
    // For now, just mark as available if not already
    if (!_availableLocales.contains(locale)) {
      _availableLocales.add(locale);
    }
  }

  @override
  String? getTranslation(String key, String locale, {String? namespace}) {
    final ns = namespace ?? '';
    return _cache[locale]?[ns]?[key];
  }

  @override
  void clearCache() {
    _cache.clear();
    _availableLocales.clear();
  }

  @override
  List<String> getAvailableLocales() {
    return List.from(_availableLocales);
  }

  /// Stores a translation in the cache.
  void storeTranslation(String locale, String namespace, String key, String value) {
    _cache.putIfAbsent(locale, () => {});
    _cache[locale]!.putIfAbsent(namespace, () => {});
    _cache[locale]![namespace]![key] = value;
  }

  /// Stores multiple translations for a namespace.
  void storeNamespace(String locale, String namespace, Map<String, String> translations) {
    _cache.putIfAbsent(locale, () => {});
    _cache[locale]![namespace] = Map.from(translations);
  }

  /// Checks if a locale is cached.
  bool isLocaleCached(String locale) {
    return _cache.containsKey(locale);
  }

  /// Gets all translations for a locale.
  Map<String, Map<String, String>>? getLocaleTranslations(String locale) {
    return _cache[locale];
  }
}