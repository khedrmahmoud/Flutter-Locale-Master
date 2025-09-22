import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'interfaces.dart';

/// Implementation of LocaleDetector that uses Flutter's system locale detection.
class DefaultLocaleDetector implements LocaleDetector {
  @override
  Future<Locale> detectSystemLocale() async {
    final systemLocales = ui.window.locales;
    if (systemLocales.isNotEmpty) {
      return _convertToFlutterLocale(systemLocales.first);
    }
    return const Locale('en');
  }

  @override
  Future<List<Locale>> getSystemLocales() async {
    final systemLocales = ui.window.locales;
    return systemLocales.map(_convertToFlutterLocale).toList();
  }

  /// Converts a ui.Locale to a Flutter Locale.
  Locale _convertToFlutterLocale(ui.Locale uiLocale) {
    if (uiLocale.countryCode != null) {
      return Locale(uiLocale.languageCode, uiLocale.countryCode);
    }
    return Locale(uiLocale.languageCode);
  }
}