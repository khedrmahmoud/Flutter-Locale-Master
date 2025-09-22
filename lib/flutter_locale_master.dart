/// Flutter Locale Master - A comprehensive Flutter localization package
/// with automatic text direction switching, custom widgets, and easy-to-use APIs.
///
/// ## Features
///
/// - 🚀 **Automatic Text Direction**: Automatically switches between LTR and RTL based on locale
/// - 🔄 **Reactive Updates**: Automatic UI updates when locale changes
/// - 🌍 **Asset-based Translations**: Load translations from Flutter assets
/// - 📱 **Pluralization**: Built-in support for plural forms
/// - 🔧 **Parameter Replacement**: Dynamic text with parameter substitution
/// - 🎨 **BuildContext Extensions**: Convenient extension methods for translations
/// - 🏗️ **Flutter Integration**: LocalizationsDelegate for MaterialApp
/// - ⚡ **Simplified API**: One-line setup with FlutterLocaleMaster class
/// - 🎯 **Type-safe**: Full type safety with Dart
/// - 📦 **Lightweight**: Minimal dependencies, optimized for performance
///
/// ## Quick Start (Simplified API)
///
/// ### 1. Set up translation files
///
/// Create JSON files in your assets:
/// ```
/// assets/lang/
/// ├── en/
/// │   └── messages.json
/// ├── fr/
/// │   └── messages.json
/// └── ar/
///     └── messages.json
/// ```
///
/// ### 2. Initialize and wrap your app
///
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   // One-line initialization with initial locale
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
///         supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
///         locale: locale,
///         home: MyHomePage(),
///       ),
///     );
///   }
/// }
/// ```
///
/// ### 3. Use translations in your widgets
///
/// ```dart
/// class MyHomePage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(
///         title: TranslatedText('welcome'),
///       ),
///       body: Center(
///         child: Column(
///           children: [
///             // Simple translation
///             Text(context.tr('greeting')),
///
///             // With parameters
///             Text(context.tr('welcome_user', args: {'name': 'John'})),
///
///             // Pluralization
///             Text(context.plural('apples', 3)),
///
///             // Language switching
///             ElevatedButton(
///               onPressed: () => context.setLocale('ar'),
///               child: Text('العربية'),
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
/// ### Custom Providers
///
/// Implement your own `LangProvider` for custom translation loading:
///
/// ```dart
/// class CustomLangProvider extends LangProvider {
///   @override
///   Future<void> initialize() async {
///     // Your custom loading logic
///   }
///
///   @override
///   String t(String key, {Map<String, dynamic>? parameters, String? locale, String? namespace}) {
///     // Your translation logic
///   }
/// }
/// ```
///
/// ### Locale Controller Customization
///
/// ```dart
/// final controller = LocaleController(
///   provider: provider,
///   fallbackLocale: const Locale('en'),
/// );
/// ```
///
/// ## Migration from easy_localization
///
/// If you're migrating from easy_localization:
///
/// 1. Replace `EasyLocalization` wrapper with `FlutterLocaleMaster.initialize()` + `wrapApp()`
/// 2. Update translation access from `.tr()` to `.tr()` (same method name)
/// 3. Use `context.setLocale()` instead of context methods
/// 4. Automatic RTL/LTR switching is built-in
///
/// ## License
///
/// MIT License - see LICENSE file for details
///
library;

// Core interfaces
export 'src/providers/lang_provider.dart';

// Provider implementations
export 'src/providers/asset_lang_provider.dart';

// Controllers and state management
export 'src/controllers/locale_controller.dart';

// Widgets
export 'src/widgets/providers/localization_provider.dart';
export 'src/widgets/consumers/locale_consumer.dart';
export 'src/widgets/text/translated_text.dart';
export 'src/widgets/text/translated_rich_text.dart';

// Extensions
export 'src/extensions/extensions.dart';
export 'src/extensions/string_extensions.dart';

// Flutter integration
export 'src/delegates/flutter_locale_master_delegate.dart';

// Simplified API
export 'src/flutter_locale_master.dart';
