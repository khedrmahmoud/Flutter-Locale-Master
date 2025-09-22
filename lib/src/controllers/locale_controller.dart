import 'dart:ui' as ui;

import 'core_locale_controller.dart';
import '../services/services.dart';

/// Locale controller that manages locale state and synchronizes with translation providers.
/// This class extends the core controller and adds provider synchronization capabilities.
class LocaleController extends CoreLocaleController {
  /// The language provider for translations.
  dynamic _provider;

  /// Configured supported locales.
  List<ui.Locale>? _configuredSupportedLocales;

  /// Creates a LocaleController with optional provider and initial locales.
  LocaleController({
    dynamic provider,
    ui.Locale? initialLocale,
    ui.Locale? fallbackLocale,
    List<ui.Locale>? supportedLocales,
    TextDirectionResolver? textDirectionResolver,
    LocaleDetector? localeDetector,
    LocaleValidator? localeValidator,
  }) : super(
         localeDetector: localeDetector ?? DefaultLocaleDetector(),
         localeValidator: localeValidator ?? DefaultLocaleValidator(),
         initialLocale: initialLocale,
         fallbackLocale: fallbackLocale,
       ) {
    _provider = provider;
    _configuredSupportedLocales = supportedLocales;
    // Set initial locale on provider if available
    if (_provider != null) {
      final localeToUse = initialLocale ?? const ui.Locale('en');
      _provider.setLocale(localeToUse.languageCode);
      final fallbackToUse = fallbackLocale ?? const ui.Locale('en');
      _provider.setFallbackLocale(fallbackToUse.languageCode);
    }
  }

  /// Gets the list of supported locales from the provider.
  List<String> getSupportedLocales() {
    if (_configuredSupportedLocales != null) {
      return _configuredSupportedLocales!
          .map((locale) => locale.languageCode)
          .toList();
    }
    if (_provider != null) {
      return _provider.getAvailableLocales();
    }
    return ['en'];
  }

  @override
  void setLocale(ui.Locale locale) {
    super.setLocale(locale);
    if (_provider != null) {
      _provider.setLocale(locale.languageCode);
    }
  }

  @override
  void setFallbackLocale(ui.Locale locale) {
    super.setFallbackLocale(locale);
    if (_provider != null) {
      _provider.setFallbackLocale(locale.languageCode);
    }
  }
}
