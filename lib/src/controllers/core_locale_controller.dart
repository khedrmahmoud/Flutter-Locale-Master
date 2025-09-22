import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import '../services/interfaces.dart';

/// Core locale controller that manages locale state and notifications.
/// This class focuses solely on state management and change notifications.
class CoreLocaleController extends ChangeNotifier {
  /// The current locale.
  ui.Locale _locale;

  /// The fallback locale.
  ui.Locale _fallbackLocale;

  /// Whether the controller has been initialized.
  bool _initialized = false;

  /// Locale detector service.
  final LocaleDetector _localeDetector;

  /// Locale validator service.
  final LocaleValidator _localeValidator;

  /// Creates a CoreLocaleController with required services.
  CoreLocaleController({
    required LocaleDetector localeDetector,
    required LocaleValidator localeValidator,
    ui.Locale? initialLocale,
    ui.Locale? fallbackLocale,
  }) : _localeDetector = localeDetector,
       _localeValidator = localeValidator,
       _locale = initialLocale ?? const ui.Locale('en'),
       _fallbackLocale = fallbackLocale ?? const ui.Locale('en');

  /// Gets the current locale.
  ui.Locale get locale => _locale;

  /// Gets the fallback locale.
  ui.Locale get fallbackLocale => _fallbackLocale;

  /// Gets the current locale as a string (language code).
  String get localeString => _locale.languageCode;

  /// Gets the fallback locale as a string (language code).
  String get fallbackLocaleString => _fallbackLocale.languageCode;

  /// Checks if the controller has been initialized.
  bool get isInitialized => _initialized;

  /// Initializes the controller by detecting the system locale.
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final systemLocale = await _localeDetector.detectSystemLocale();
      if (_localeValidator.isValidLocale(
        _localeValidator.formatLocale(systemLocale),
      )) {
        _locale = systemLocale;
      }
    } catch (e) {
      // Keep current locale if system detection fails
    }

    _initialized = true;
    notifyListeners();
  }

  /// Sets the current locale and notifies listeners.
  void setLocale(ui.Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }

  /// Sets the current locale from a language code string.
  void setLocaleFromString(String languageCode, {String? countryCode}) {
    final newLocale = _localeValidator.parseLocale(
      countryCode != null ? '$languageCode-$countryCode' : languageCode,
    );
    setLocale(newLocale);
  }

  /// Sets the fallback locale.
  void setFallbackLocale(ui.Locale locale) {
    if (_fallbackLocale == locale) return;
    _fallbackLocale = locale;
    notifyListeners();
  }

  /// Sets the fallback locale from a language code string.
  void setFallbackLocaleFromString(String languageCode, {String? countryCode}) {
    final newLocale = _localeValidator.parseLocale(
      countryCode != null ? '$languageCode-$countryCode' : languageCode,
    );
    setFallbackLocale(newLocale);
  }

  /// Toggles between two locales.
  void toggleLocale(ui.Locale locale1, ui.Locale locale2) {
    setLocale(_locale == locale1 ? locale2 : locale1);
  }

  /// Checks if the given locale is currently active.
  bool isCurrentLocale(ui.Locale locale) => _locale == locale;

  /// Checks if the given language code is currently active.
  bool isCurrentLanguage(String languageCode) =>
      _locale.languageCode == languageCode;

  /// Resets to the system locale.
  Future<void> resetToSystemLocale() async {
    try {
      final systemLocale = await _localeDetector.detectSystemLocale();
      setLocale(systemLocale);
    } catch (e) {
      // Keep current locale if reset fails
    }
  }
}
