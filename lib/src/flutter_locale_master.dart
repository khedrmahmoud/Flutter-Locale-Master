import 'package:flutter/material.dart';
import 'package:flutter_locale_master/flutter_locale_master.dart';

/// Flutter Locale Master - Advanced localization management for Flutter apps.
///
/// A comprehensive, production-ready localization package that provides:
/// - **Asset-based translations** with automatic file discovery
/// - **Automatic text direction** switching (RTL/LTR) based on locale
/// - **Reactive UI updates** when locale changes
/// - **Namespace support** for organized translation files
/// - **Pluralization** with ICU-like syntax
/// - **Parameter replacement** in translations
/// - **Type-safe API** with full Dart null-safety
/// - **Performance optimized** with caching and preloading
/// - **Easy integration** with MaterialApp and custom widgets
///
/// ## Architecture
///
/// Flutter Locale Master follows a clean architecture pattern:
/// - **Services Layer**: Handles core functionality (loading, caching, validation)
/// - **Providers Layer**: Manages translation data and locale state
/// - **Controllers Layer**: Coordinates locale changes and notifications
/// - **Widgets Layer**: Provides reactive UI components
/// - **Extensions Layer**: Offers convenient context and string methods
///
/// ## Basic Usage
///
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   // Initialize with asset translations
///   final localeMaster = await FlutterLocaleMaster.initialize(
///     basePath: 'lang/',
///     initialLocale: const Locale('en'),
///     fallbackLocale: const Locale('en'),
///   );
///
///   runApp(MyApp(localeMaster: localeMaster));
/// }
///
/// class MyApp extends StatelessWidget {
///   final FlutterLocaleMaster localeMaster;
///
///   const MyApp({super.key, required this.localeMaster});
///
///   @override
///   Widget build(BuildContext context) {
///     return localeMaster.wrapApp(
///       (locale, textDirection) => MaterialApp(
///         title: 'My App',
///         localizationsDelegates: [
///           localeMaster.delegate,
///           GlobalMaterialLocalizations.delegate,
///           GlobalWidgetsLocalizations.delegate,
///           GlobalCupertinoLocalizations.delegate,
///         ],
///         supportedLocales: localeMaster.supportedLocales,
///         locale: locale,
///         home: const HomePage(),
///       ),
///     );
///   }
/// }
/// ```
///
/// ## Advanced Usage
///
/// ### Using Extensions
///
/// ```dart
/// class HomePage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(
///         title: Text(context.tr('app_title')),
///       ),
///       body: Center(
///         child: Column(
///           children: [
///             // Simple translation
///             Text(context.tr('welcome')),
///
///             // With parameters
///             Text(context.tr('greeting', parameters: {'name': 'John'})),
///
///             // Pluralization
///             Text(context.plural('item_count', 5)),
///
///             // Field translation
///             Text(context.field('email')),
///
///             // Using string extensions
///             Text('hello'.tr()),
///             Text('item'.plural(3)),
///           ],
///         ),
///       ),
///       floatingActionButton: FloatingActionButton(
///         onPressed: () => context.setLocaleObj(const Locale('ar')),
///         child: const Icon(Icons.language),
///       ),
///     );
///   }
/// }
/// ```
///
/// ### Using Widgets
///
/// ```dart
/// class ProfilePage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: Column(
///         children: [
///           // Automatic translation updates
///           TranslatedText('profile_title'),
///
///           // With rich text support
///           TranslatedRichText(
///             'welcome_user',
///             parameters: {'name': user.name},
///             style: const TextStyle(fontSize: 18),
///           ),
///
///           // Reactive consumer
///           LocaleConsumer(
///             builder: (context, localization, child) {
///               return Text(localization.provider.t('current_locale'));
///             },
///           ),
///         ],
///       ),
///     );
///   }
/// }
/// ```
///
/// ## Translation Files Structure
///
/// ```
/// assets/
///   lang/
///     en/
///       messages.json
///       fields.json
///       validation.json
///     ar/
///       messages.json
///       fields.json
///       validation.json
/// ```
///
/// ### messages.json
/// ```json
/// {
///   "hello": "Hello",
///   "welcome": "Welcome {name}",
///   "item_count": "no items | {count} item | {count} items",
///   "current_time": "Current time is {time}"
/// }
/// ```
///
/// ### fields.json
/// ```json
/// {
///   "name": "Name",
///   "email": "Email Address",
///   "password": "Password"
/// }
/// ```
///
/// ## Features
///
/// - ✅ **Asset-based loading** with automatic file discovery
/// - ✅ **Namespace support** for organized translations
/// - ✅ **Pluralization** with ICU MessageFormat syntax
/// - ✅ **Parameter interpolation** with named placeholders
/// - ✅ **Automatic RTL/LTR detection** and switching
/// - ✅ **Reactive updates** throughout the widget tree
/// - ✅ **Type-safe API** with full null-safety
/// - ✅ **Performance optimized** with caching and preloading
/// - ✅ **Easy MaterialApp integration** with delegate support
/// - ✅ **Context extensions** for convenient access
/// - ✅ **String extensions** for direct translation calls
/// - ✅ **Custom widgets** for automatic translation
/// - ✅ **Comprehensive testing** coverage
///
/// ## Performance
///
/// - **Preloading**: All translations are loaded at startup
/// - **Caching**: Efficient in-memory caching with namespace support
/// - **Lazy initialization**: Singleton pattern prevents unnecessary work
/// - **Concurrent loading**: Multiple files loaded simultaneously
/// - **Minimal rebuilds**: Only affected widgets update on locale change
///
/// ## Error Handling
///
/// The package gracefully handles common issues:
/// - Missing translation files fall back to keys
/// - Invalid locales use fallback locale
/// - Missing parameters are preserved in output
/// - Asset loading failures don't crash the app
///
/// ## Testing
///
/// ```dart
/// void main() {
///   test('Translation loading', () async {
///     final localeMaster = await FlutterLocaleMaster.initialize(
///       basePath: 'lang/',
///     );
///
///     expect(localeMaster.tr('hello'), 'Hello');
///     expect(localeMaster.plural('item', 2), '2 items');
///   });
/// }
/// ```
///
class FlutterLocaleMaster {
  static FlutterLocaleMaster? _instance;

  /// Get the singleton instance of FlutterLocaleMaster.
  ///
  /// Provides access to the initialized localization system. Must be called
  /// after [initialize()]. Useful for accessing translations from anywhere
  /// in the app without BuildContext.
  ///
  /// ```dart
  /// // In a service or utility class
  /// String greeting = FlutterLocaleMaster.instance.tr('hello');
  /// ```
  ///
  /// Throws [StateError] if not initialized.
  static FlutterLocaleMaster get instance {
    if (_instance == null) {
      throw StateError(
        'FlutterLocaleMaster not initialized. Call initialize() first.',
      );
    }
    return _instance!;
  }

  late final AssetLangProvider _provider;
  late final LocaleController _controller;
  late final FlutterLocaleMasterDelegate _delegate;
  late final Locale? _initialLocale;

  /// The translation provider (read-only)
  LangProvider get provider => _provider;

  /// The locale controller (read-only)
  LocaleController get controller => _controller;

  /// The localizations delegate for MaterialApp
  FlutterLocaleMasterDelegate get delegate => _delegate;

  /// Private constructor - use [initialize] factory instead
  FlutterLocaleMaster._();

  /// Initialize the localization system with asset-based translations.
  ///
  /// This is the main entry point for setting up Flutter Locale Master.
  /// It performs the following operations:
  /// 1. Scans asset manifest for available translation files
  /// 2. Preloads all translations into memory
  /// 3. Sets up locale controller with system detection
  /// 4. Creates localization delegate for MaterialApp
  ///
  /// **Must be called before accessing [instance]** and should be done
  /// early in app lifecycle, typically in `main()` after `WidgetsFlutterBinding.ensureInitialized()`.
  ///
  /// Parameters:
  /// - [basePath]: Root directory for translation files (e.g., 'lang/', 'assets/lang/')
  /// - [initialLocale]: Starting locale. If null, uses system locale
  /// - [fallbackLocale]: Fallback when translations not found. Defaults to 'en'
  /// - [supportedLocales]: List of allowed locales. If null, auto-detects from asset files
  ///
  /// Returns the initialized [FlutterLocaleMaster] instance.
  ///
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///
  ///   final localeMaster = await FlutterLocaleMaster.initialize(
  ///     basePath: 'lang/',
  ///     initialLocale: const Locale('en'),
  ///     fallbackLocale: const Locale('en'),
  ///     supportedLocales: [Locale('en'), Locale('ar'), Locale('fr')],
  ///   );
  ///
  ///   runApp(MyApp(localeMaster: localeMaster));
  /// }
  /// ```
  ///
  /// Throws [Exception] if asset loading fails or initialization encounters errors.
  static Future<FlutterLocaleMaster> initialize({
    required String basePath,
    Locale? initialLocale,
    Locale? fallbackLocale,
    List<Locale>? supportedLocales,
  }) async {
    if (_instance != null) {
      return _instance!;
    }

    final localeMaster = FlutterLocaleMaster._();

    // Store initial locale
    localeMaster._initialLocale = initialLocale;

    // Create and initialize provider
    localeMaster._provider = AssetLangProvider(basePath: basePath);
    await localeMaster._provider.initialize();

    // Create and initialize controller
    localeMaster._controller = LocaleController(
      provider: localeMaster._provider,
      fallbackLocale: fallbackLocale,
      supportedLocales: supportedLocales,
    );
    await localeMaster._controller.initialize();

    // Set initial locale if provided
    if (initialLocale != null) {
      localeMaster._controller.setLocale(initialLocale);
    }

    // Create delegate
    localeMaster._delegate = FlutterLocaleMasterDelegate(
      provider: localeMaster._provider,
      controller: localeMaster._controller,
    );

    _instance = localeMaster;
    return localeMaster;
  }

  /// Wrap your MaterialApp with the localization provider and automatic text direction.
  ///
  /// This method provides a complete MaterialApp setup with localization support.
  /// It automatically:
  /// - Wraps your app with [LocalizationProvider] for state management
  /// - Sets up [LocaleConsumer] for reactive locale updates
  /// - Provides current locale and text direction to your MaterialApp builder
  /// - Ensures proper rebuilds when locale changes
  ///
  /// The [appBuilder] function receives:
  /// - [locale]: Current active locale (or null during initialization)
  /// - [textDirection]: Current text direction (LTR/RTL) based on locale
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return localeMaster.wrapApp(
  ///     (locale, textDirection) => MaterialApp(
  ///       title: 'My App',
  ///       localizationsDelegates: [
  ///         localeMaster.delegate,
  ///         GlobalMaterialLocalizations.delegate,
  ///         GlobalWidgetsLocalizations.delegate,
  ///       ],
  ///       supportedLocales: localeMaster.supportedLocales,
  ///       locale: locale,
  ///       builder: (context, child) => Directionality(
  ///         textDirection: textDirection,
  ///         child: child!,
  ///       ),
  ///       home: const HomePage(),
  ///     ),
  ///   );
  /// }
  /// ```
  ///
  /// **Note**: The text direction is automatically handled, but you can also
  /// manually wrap with [Directionality] if needed for custom scenarios.
  Widget wrapApp(Widget Function(Locale? locale) appBuilder) {
    return LocalizationProvider(
      controller: _controller,
      provider: _provider,
      child: LocaleConsumer(
        builder: (context, provider, child) {
          return appBuilder(_controller.locale);
        },
      ),
    );
  }

  /// Get a translation for the given key.
  ///
  /// Translates a key to the current locale's text. Supports parameter
  /// replacement and namespace scoping.
  ///
  /// Parameters:
  /// - [key]: The translation key (e.g., 'hello', 'welcome.message')
  /// - [parameters]: Optional map of parameters to replace in the translation
  /// - [namespace]: Optional namespace to scope the search (e.g., 'validation')
  ///
  /// Returns the translated string, or the key if not found.
  ///
  /// ```dart
  /// // Simple translation
  /// String greeting = localeMaster.tr('hello');
  ///
  /// // With parameters
  /// String welcome = localeMaster.tr('welcome', parameters: {'name': 'John'});
  ///
  /// // With namespace
  /// String error = localeMaster.tr('required', namespace: 'validation');
  /// ```
  ///
  /// See also: [BuildContext.tr] for context-based translation.
  String tr(String key, {Map<String, dynamic>? parameters, String? namespace}) {
    return _provider.t(key, parameters: parameters, namespace: namespace);
  }

  /// Get a pluralized translation.
  ///
  /// Handles plural forms based on [count] using ICU MessageFormat syntax.
  /// The translation should contain plural forms separated by `|`.
  ///
  /// Parameters:
  /// - [key]: The translation key
  /// - [count]: The count to determine singular/plural form
  /// - [parameters]: Optional parameters (count is automatically added)
  /// - [namespace]: Optional namespace
  ///
  /// Returns the appropriate plural form.
  ///
  /// ```dart
  /// // Translation: "no items | {count} item | {count} items"
  /// String result = localeMaster.plural('item', 0);    // "no items"
  /// String result = localeMaster.plural('item', 1);    // "1 item"
  /// String result = localeMaster.plural('item', 5);    // "5 items"
  /// ```
  ///
  /// See also: [BuildContext.plural] for context-based pluralization.
  String plural(
    String key,
    int count, {
    Map<String, dynamic>? parameters,
    String? namespace,
  }) {
    return _provider.choice(
      key,
      count,
      parameters: parameters,
      namespace: namespace,
    );
  }

  /// Get a field translation with automatic "fields" namespace.
  ///
  /// Convenience method for translating form field labels and hints.
  /// Automatically uses the "fields" namespace.
  ///
  /// Parameters:
  /// - [key]: The field key (e.g., 'email', 'password')
  ///
  /// Returns the translated field name.
  ///
  /// ```dart
  /// // Looks in fields namespace
  /// String label = localeMaster.field('email'); // "Email Address"
  /// ```
  ///
  /// See also: [BuildContext.field] for context-based field translation.
  String field(String key) {
    return _provider.field(key);
  }

  /// Set the current locale.
  ///
  /// Changes the active locale and triggers UI updates throughout the app.
  /// The locale must be supported (see [supportedLocales]).
  ///
  /// Parameters:
  /// - [locale]: The new locale to activate
  ///
  /// ```dart
  /// // Switch to Arabic
  /// localeMaster.setLocale(const Locale('ar'));
  ///
  /// // Switch to French
  /// localeMaster.setLocale(const Locale('fr'));
  /// ```
  ///
  /// See also: [reset], [resetToSystemLocale], [toggleLocale]
  void setLocale(Locale locale) {
    _controller.setLocale(locale);
  }

  /// Get the current locale.
  ///
  /// Returns the currently active locale, or null during initialization.
  ///
  /// ```dart
  /// Locale? current = localeMaster.currentLocale;
  /// if (current?.languageCode == 'ar') {
  ///   // RTL layout
  /// }
  /// ```
  Locale? get currentLocale => _controller.locale;

  /// Get the list of supported locales.
  ///
  /// Returns all locales that have translation files available.
  /// Automatically discovered from asset manifest during initialization.
  ///
  /// ```dart
  /// List<Locale> locales = localeMaster.supportedLocales;
  /// // [Locale('en'), Locale('ar'), Locale('fr')]
  /// ```
  List<Locale> get supportedLocales =>
      _controller.getSupportedLocales().map((s) => Locale(s)).toList();

  /// Check if a locale is supported.
  ///
  /// Returns true if the locale has translation files available.
  ///
  /// Parameters:
  /// - [locale]: The locale to check
  ///
  /// ```dart
  /// if (localeMaster.isLocaleSupported(const Locale('ar'))) {
  ///   localeMaster.setLocale(const Locale('ar'));
  /// }
  /// ```
  bool isLocaleSupported(Locale locale) => supportedLocales.contains(locale);

  /// Reset to the initial locale.
  ///
  /// Reverts to the locale specified during [initialize()], or the
  /// system locale if none was specified.
  ///
  /// ```dart
  /// // Reset to initial locale (e.g., 'en')
  /// localeMaster.reset();
  /// ```
  ///
  /// See also: [resetToSystemLocale]
  void reset() {
    if (_initialLocale != null) {
      setLocale(_initialLocale);
    }
  }

  /// Reset to the system locale.
  ///
  /// Changes to the device's current system locale.
  /// Asynchronous operation that may take time to detect the locale.
  ///
  /// ```dart
  /// // Reset to system locale
  /// await localeMaster.resetToSystemLocale();
  /// ```
  ///
  /// See also: [reset]
  Future<void> resetToSystemLocale() => _controller.resetToSystemLocale();

  /// Check if the given locale is currently active.
  ///
  /// Useful for UI state management (e.g., highlighting active language button).
  ///
  /// Parameters:
  /// - [locale]: The locale to check against current
  ///
  /// Returns true if the locale matches the current locale.
  ///
  /// ```dart
  /// bool isActive = localeMaster.isCurrentLocale(const Locale('en'));
  /// ```
  bool isCurrentLocale(Locale locale) => _controller.isCurrentLocale(locale);

  /// Toggle between two locales.
  ///
  /// Convenience method to switch between two locales. If current locale
  /// matches [locale1], switches to [locale2], and vice versa.
  ///
  /// Parameters:
  /// - [locale1]: First locale in the toggle pair
  /// - [locale2]: Second locale in the toggle pair
  ///
  /// ```dart
  /// // Toggle between English and Arabic
  /// localeMaster.toggleLocale(
  ///   const Locale('en'),
  ///   const Locale('ar')
  /// );
  /// ```
  void toggleLocale(Locale locale1, Locale locale2) =>
      _controller.toggleLocale(locale1, locale2);
}
