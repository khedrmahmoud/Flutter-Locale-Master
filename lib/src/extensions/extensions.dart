import 'package:flutter/widgets.dart';

import '../widgets/providers/localization_provider.dart';

/// Extension methods on [BuildContext] for convenient localization access.
///
/// These extensions provide a fluent API for accessing translations, locale
/// information, and localization features directly from any [BuildContext].
/// They automatically find the nearest [LocalizationProvider] and delegate
/// to the underlying localization system.
///
/// ## Core Features
///
/// - **Translation methods**: [tr], [plural], [field]
/// - **Locale management**: [setLocale], [setLocaleObj], [currentLocale], [currentLocaleObj]
/// - **Locale information**: [supportedLocales], [fallbackLocale], [textDirection], [isRTL]
/// - **Translation checking**: [hasTranslation]
///
/// ## Basic Usage
///
/// ```dart
/// class MyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(
///         title: Text(context.tr('app_title')),
///       ),
///       body: Center(
///         child: Column(
///           mainAxisAlignment: MainAxisAlignment.center,
///           children: [
///             // Simple translation
///             Text(
///               context.tr('welcome'),
///               style: Theme.of(context).textTheme.headlineMedium,
///             ),
///
///             // Translation with parameters
///             Text(
///               context.tr('greeting', parameters: {'name': 'John'}),
///             ),
///
///             // Pluralization
///             Text(context.plural('item_count', itemCount)),
///
///             // Field labels
///             TextFormField(
///               decoration: InputDecoration(
///                 labelText: context.field('email'),
///                 hintText: context.field('email_hint'),
///               ),
///             ),
///
///             // Locale-aware layout
///             if (context.isRTL) ...[
///               // RTL specific widgets
///             ] else ...[
///               // LTR specific widgets
///             ],
///
///             // Language switcher
///             ElevatedButton(
///               onPressed: () => context.setLocaleObj(
///                 context.currentLocaleObj?.languageCode == 'en'
///                     ? const Locale('ar')
///                     : const Locale('en'),
///               ),
///               child: Text(context.tr('switch_language')),
///             ),
///           ],
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
/// ## Advanced Usage
///
/// ### Conditional Translations
///
/// ```dart
/// String getWelcomeMessage(BuildContext context) {
///   final userName = getCurrentUser()?.name;
///   if (userName != null && context.hasTranslation('welcome_user')) {
///     return context.tr('welcome_user', parameters: {'name': userName});
///   }
///   return context.tr('welcome_guest');
/// }
/// ```
///
/// ### Locale Validation
///
/// ```dart
/// void switchToLocale(BuildContext context, Locale newLocale) {
///   final supported = context.supportedLocales
///       .map((s) => s.toLowerCase())
///       .toList();
///
///   if (supported.contains(newLocale.languageCode.toLowerCase())) {
///     context.setLocaleObj(newLocale);
///   } else {
///     // Fallback to current locale or show error
///     ScaffoldMessenger.of(context).showSnackBar(
///       SnackBar(content: Text(context.tr('locale_not_supported'))),
///     );
///   }
/// }
/// ```
///
/// ## Error Handling
///
/// If no [LocalizationProvider] is found in the widget tree, methods will:
/// - Translation methods ([tr], [plural], [field]): Return the key unchanged
/// - Locale methods ([currentLocale], etc.): Return null
/// - Boolean methods ([hasTranslation], [isRTL]): Return false
///
/// Make sure your app is wrapped with [FlutterLocaleMaster.wrapApp] or
/// manually include [LocalizationProvider] in your widget tree.
///
/// ## Performance Notes
///
/// - Extensions are lightweight and don't create additional objects
/// - Provider lookup uses Flutter's inherited widget system
/// - Translations are cached and don't involve disk I/O after initialization
/// - Locale changes trigger minimal rebuilds of affected widgets
extension LocalizationContext on BuildContext {
  /// Gets the [LocalizationProvider] from this context.
  ///
  /// Returns null if no provider is found. Use [requireLocalizationProvider]
  /// if you need to ensure a provider exists.
  LocalizationProvider? get localizationProvider {
    return LocalizationProvider.maybeOf(this);
  }

  /// Gets the [LocalizationProvider] from this context.
  ///
  /// Throws an assertion error if no provider is found.
  LocalizationProvider get requireLocalizationProvider {
    return LocalizationProvider.of(this);
  }

  /// Translates a key with optional parameters and namespace.
  ///
  /// [key] The translation key to look up.
  /// [parameters] Optional parameters to replace in the translation.
  /// [namespace] Optional namespace for the translation.
  ///
  /// Returns the translated string, or the key if no provider is found.
  String tr(String key, {Map<String, dynamic>? parameters, String? namespace}) {
    final provider = localizationProvider;
    if (provider == null) return key;

    return provider.provider.t(
      key,
      parameters: parameters,
      namespace: namespace,
    );
  }

  /// Translates a key with pluralization based on count.
  ///
  /// [key] The translation key to look up.
  /// [count] The count to determine singular/plural form.
  /// [parameters] Optional parameters to replace in the translation.
  /// [namespace] Optional namespace for the translation.
  ///
  /// Returns the translated string with pluralization applied.
  String plural(
    String key,
    int count, {
    Map<String, dynamic>? parameters,
    String? namespace,
  }) {
    final provider = localizationProvider;
    if (provider == null) return key;

    return provider.provider.choice(
      key,
      count,
      parameters: parameters,
      namespace: namespace,
    );
  }

  /// Translates a field key with automatic "fields" namespace.
  ///
  /// [key] The field translation key.
  /// [namespace] Optional namespace override (defaults to "fields").
  ///
  /// Returns the translated field name.
  String field(String key, {String? namespace}) {
    final provider = localizationProvider;
    if (provider == null) return key;

    return provider.provider.field(key, namespace: namespace);
  }

  /// Checks if a translation key exists.
  ///
  /// [key] The translation key to check.
  /// [namespace] Optional namespace for the translation.
  ///
  /// Returns true if the key exists, false otherwise.
  bool hasTranslation(String key, {String? namespace}) {
    final provider = localizationProvider;
    if (provider == null) return false;

    return provider.provider.has(key, namespace: namespace);
  }

  /// Gets the current locale string.
  ///
  /// Returns the current locale language code, or null if no provider.
  String? get currentLocale {
    final provider = localizationProvider;
    return provider?.notifier?.localeString;
  }

  /// Gets the current locale as a Locale object.
  ///
  /// Returns the current locale, or null if no provider.
  Locale? get currentLocaleObj {
    final provider = localizationProvider;
    return provider?.notifier?.locale;
  }

  /// Gets the fallback locale string.
  ///
  /// Returns the fallback locale language code, or null if no provider.
  String? get fallbackLocale {
    final provider = localizationProvider;
    return provider?.notifier?.fallbackLocaleString;
  }

  /// Gets the list of supported locales.
  ///
  /// Returns the available locales from the provider, or ['en'] if no provider.
  List<String> get supportedLocales {
    final provider = localizationProvider;
    return provider?.notifier?.getSupportedLocales() ?? ['en'];
  }

  /// Changes the current locale.
  ///
  /// [locale] The new locale to set.
  ///
  /// This is a convenience method that delegates to the controller.
  void setLocale(String locale) {
    final provider = localizationProvider;
    provider?.notifier?.setLocaleFromString(locale);
  }

  /// Changes the current locale with a Locale object.
  ///
  /// [locale] The new locale to set.
  void setLocaleObj(Locale locale) {
    final provider = localizationProvider;
    provider?.notifier?.setLocale(locale);
  }

  /// Changes the fallback locale.
  ///
  /// [locale] The new fallback locale to set.
  ///
  /// This is a convenience method that delegates to the controller.
  void setFallbackLocale(String locale) {
    final provider = localizationProvider;
    provider?.notifier?.setFallbackLocaleFromString(locale);
  }

  /// Gets the text direction for the current locale.
  ///
  /// Returns [TextDirection.rtl] for RTL languages and [TextDirection.ltr] for LTR.
  TextDirection? get textDirection {
    return Directionality.of(this);
  }

  /// Checks if the current locale is RTL.
  ///
  /// Returns true for RTL languages (Arabic, Hebrew, etc.).
  bool get isRTL => Directionality.of(this) == TextDirection.rtl;
}
