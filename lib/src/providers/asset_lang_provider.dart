import '../services/services.dart';
import 'lang_provider.dart';

/// Asset-based language provider that loads translations from Flutter assets.
/// This class coordinates all the services needed for asset-based translation loading.
class AssetLangProvider implements LangProvider {
  /// Translation loader service.
  final TranslationLoader _loader;

  /// Parameter replacer service.
  final ParameterReplacer _parameterReplacer;

  /// Pluralization handler service.
  final PluralizationHandler _pluralizationHandler;

  /// Current locale.
  String _currentLocale = 'en';

  /// Fallback locale.
  String _fallbackLocale = 'en';

  /// Creates an AssetLangProvider with optional service overrides.
  AssetLangProvider({
    String basePath = 'lang/',
    TranslationLoader? loader,
    ParameterReplacer? parameterReplacer,
    PluralizationHandler? pluralizationHandler,
  })  : _loader = loader ?? AssetTranslationLoader(basePath: basePath),
        _parameterReplacer = parameterReplacer ?? DefaultParameterReplacer(),
        _pluralizationHandler = pluralizationHandler ?? DefaultPluralizationHandler();

  Future<void> initialize() async {
    try {
      await _loader.initialize();
    } catch (e) {
      // In test environments or when assets are not available,
      // gracefully handle the error and continue with empty cache
    }
  }

  @override
  void setLocale(String locale) {
    _currentLocale = locale;
  }

  @override
  String getLocale() => _currentLocale;

  @override
  void setFallbackLocale(String locale) {
    _fallbackLocale = locale;
  }

  @override
  String getFallbackLocale() => _fallbackLocale;

  @override
  String t(
    String key, {
    Map<String, dynamic>? parameters,
    String? locale,
    String? namespace,
  }) {
    final loc = locale ?? _currentLocale;
    final ns = namespace ?? '';

    // Try namespace first, then global
    String? msg = _loader.getTranslation(key, loc, namespace: ns) ??
                  _loader.getTranslation(key, loc, namespace: '');

    // Fallback to fallback locale
    if (msg == null && loc != _fallbackLocale) {
      msg = _loader.getTranslation(key, _fallbackLocale, namespace: ns) ??
            _loader.getTranslation(key, _fallbackLocale, namespace: '');
    }

    // Use key if not found
    msg ??= key;

    // Apply parameter replacement
    if (parameters != null) {
      msg = _parameterReplacer.replaceParameters(msg, parameters);
    }

    return msg;
  }

  @override
  String choice(
    String key,
    int count, {
    Map<String, dynamic>? parameters,
    String? locale,
    String? namespace,
  }) {
    final loc = locale ?? _currentLocale;
    final ns = namespace ?? '';

    String? msg = _loader.getTranslation(key, loc, namespace: ns) ??
                  _loader.getTranslation(key, loc, namespace: '');

    if (msg == null && loc != _fallbackLocale) {
      msg = _loader.getTranslation(key, _fallbackLocale, namespace: ns) ??
            _loader.getTranslation(key, _fallbackLocale, namespace: '');
    }

    msg ??= key;

    // Handle pluralization
    msg = _pluralizationHandler.applyPluralization(msg, count);

    // Add count to parameters
    final params = Map<String, dynamic>.from(parameters ?? {});
    params['count'] = count;

    return _parameterReplacer.replaceParameters(msg, params);
  }

  @override
  String field(String key, {String? locale, String? namespace}) {
    return t(key, locale: locale, namespace: namespace ?? "fields");
  }

  @override
  bool has(String key, {String? locale, String? namespace}) {
    final loc = locale ?? _currentLocale;
    final ns = namespace ?? '';
    return _loader.getTranslation(key, loc, namespace: ns) != null ||
        _loader.getTranslation(key, loc, namespace: '') != null ||
        (loc != _fallbackLocale &&
            (_loader.getTranslation(key, _fallbackLocale, namespace: ns) != null ||
                _loader.getTranslation(key, _fallbackLocale, namespace: '') != null));
  }

  @override
  String? get(String key, {String? locale, String? namespace}) {
    final loc = locale ?? _currentLocale;
    final ns = namespace ?? '';
    return _loader.getTranslation(key, loc, namespace: ns) ??
        _loader.getTranslation(key, loc, namespace: '') ??
        (loc != _fallbackLocale
            ? (_loader.getTranslation(key, _fallbackLocale, namespace: ns) ??
                _loader.getTranslation(key, _fallbackLocale, namespace: ''))
            : null);
  }

  @override
  void loadNamespace(
    String namespace,
    String locale,
    Map<String, String> translations,
  ) {
    // Store in the cache for dynamic loading
    (_loader as DefaultTranslationCache).storeNamespace(locale, namespace, translations);
  }

  @override
  void clearCache() {
    _loader.clearCache();
  }

  @override
  List<String> getAvailableLocales() {
    final locales = _loader.getAvailableLocales();
    // Return at least 'en' as a fallback for tests and when no assets are available
    return locales.isNotEmpty ? locales : ['en'];
  }

  @override
  void addParameterReplacer(
    String Function(
      String key,
      dynamic value,
      Map<String, dynamic> parameters,
    ) replacer,
  ) {
    _parameterReplacer.addReplacer(replacer);
  }
}