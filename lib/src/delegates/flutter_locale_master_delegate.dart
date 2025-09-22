import 'dart:async';

import 'package:flutter/widgets.dart';

import '../providers/lang_provider.dart';
import '../controllers/locale_controller.dart';

/// A localization delegate that integrates with Flutter's built-in localization system.
///
/// This delegate allows the package to work with Flutter's [Localizations] widget
/// and ensures proper locale synchronization. It works with any [LangProvider]
/// implementation and [LocaleController].
///
/// ## Usage
///
/// ```dart
/// MaterialApp(
///   localizationsDelegates: [
///     FlutterLocaleMasterDelegate(
///       provider: assetProvider,
///       controller: localeController,
///     ),
///     GlobalMaterialLocalizations.delegate,
///     GlobalWidgetsLocalizations.delegate,
///   ],
///   supportedLocales: [
///     Locale('en'),
///     Locale('fr'),
///     Locale('es'),
///   ],
///   locale: localeController.locale,
/// )
/// ```
///
/// ## Integration
///
/// The delegate automatically syncs with the [LocaleController] and updates
/// when the locale changes. Use the BuildContext extensions for translation access.
class FlutterLocaleMasterDelegate extends LocalizationsDelegate<Object> {
  /// The language provider for translations.
  final LangProvider provider;

  /// The locale controller for locale management.
  final LocaleController controller;

  /// Creates a FlutterLocaleMasterDelegate.
  ///
  /// [provider] The language provider to use for translations.
  /// [controller] The locale controller to sync with.
  const FlutterLocaleMasterDelegate({
    required this.provider,
    required this.controller,
  });

  @override
  bool isSupported(Locale locale) {
    final supportedLocales = provider.getAvailableLocales();
    return supportedLocales.contains(locale.languageCode);
  }

  @override
  Future<Object> load(Locale locale) async {
    // Sync the provider with the new locale
    provider.setLocale(locale.languageCode);
    // Return a dummy object since we use extensions instead of Localizations.of
    return Object();
  }

  @override
  bool shouldReload(FlutterLocaleMasterDelegate old) {
    return old.provider != provider || old.controller != controller;
  }

  @override
  String toString() => 'FlutterLocaleMasterDelegate';
}