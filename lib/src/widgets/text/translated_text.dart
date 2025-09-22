import 'package:flutter/widgets.dart';
import 'package:flutter_locale_master/flutter_locale_master.dart';

/// A widget that displays translated text and automatically updates on locale changes.
///
/// [TranslatedText] combines the functionality of [Text] widget with automatic
/// translation and reactive updates when the locale changes. It's a convenient
/// way to display localized text without manually handling locale changes.
///
/// ## Basic Usage
///
/// ```dart
/// class WelcomeScreen extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(
///         title: TranslatedText('app_title'),
///       ),
///       body: Center(
///         child: Column(
///           mainAxisAlignment: MainAxisAlignment.center,
///           children: [
///             TranslatedText(
///               'welcome',
///               style: Theme.of(context).textTheme.headlineMedium,
///               textAlign: TextAlign.center,
///             ),
///             const SizedBox(height: 20),
///             TranslatedText(
///               'subtitle',
///               style: Theme.of(context).textTheme.bodyLarge,
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
/// ### With Parameters
///
/// ```dart
/// TranslatedText(
///   'welcome_user',
///   parameters: {'name': user.name, 'app': 'MyApp'},
///   style: TextStyle(fontWeight: FontWeight.bold),
/// )
/// ```
///
/// ### With Namespaces
///
/// ```dart
/// // Translation file: validation.json
/// // {"required": "This field is required"}
/// TranslatedText(
///   'required',
///   namespace: 'validation',
///   style: TextStyle(color: Colors.red),
/// )
/// ```
///
/// ### In Lists and Collections
///
/// ```dart
/// ListView.builder(
///   itemCount: menuItems.length,
///   itemBuilder: (context, index) {
///     final item = menuItems[index];
///     return ListTile(
///       title: TranslatedText(item.titleKey),
///       subtitle: TranslatedText(item.subtitleKey),
///       onTap: () => navigateTo(item.route),
///     );
///   },
/// )
/// ```
///
/// ### Form Field Labels
///
/// ```dart
/// TextFormField(
///   decoration: InputDecoration(
///     label: TranslatedText('email'),
///     hintText: TranslatedText('email_hint').data, // Get text directly
///   ),
///   validator: (value) {
///     if (value?.isEmpty ?? true) {
///       return TranslatedText('email_required').data;
///     }
///     return null;
///   },
/// )
/// ```
///
/// ## Parameters
///
/// - [translationKey]: The translation key to look up
/// - [parameters]: Optional map of parameters to substitute in the translation
/// - [namespace]: Optional namespace for scoped translations
/// - [style]: Text style (same as [Text.style])
/// - [textAlign]: Text alignment (same as [Text.textAlign])
/// - [textDirection]: Text direction override (same as [Text.textDirection])
/// - [softWrap]: Soft wrapping behavior (same as [Text.softWrap])
/// - [overflow]: Overflow handling (same as [Text.overflow])
/// - [textScaler]: Text scaling (same as [Text.textScaler])
/// - [maxLines]: Maximum lines (same as [Text.maxLines])
///
/// ## Performance
///
/// - Automatically rebuilds only when locale changes
/// - No additional overhead compared to [Text] widget
/// - Uses efficient string extension methods for translation
/// - Supports all [Text] widget styling and layout options
///
/// ## Error Handling
///
/// If the translation key is not found, displays the key itself.
/// Make sure [FlutterLocaleMaster] is initialized and the key exists
/// in your translation files.
///
/// ## Alternatives
///
/// - Use [TranslatedRichText] for rich text with multiple styles
/// - Use [Text] with context extensions for more control
/// - Use [LocaleConsumer] for complex locale-dependent UI
///
/// See also: [TranslatedRichText], [Text], [BuildContext.tr]
class TranslatedText extends StatelessWidget {
  /// The translation key.
  final String translationKey;

  /// Optional parameters for the translation.
  final Map<String, dynamic>? parameters;

  /// Optional namespace for the translation.
  final String? namespace;

  /// Text style for the translated text.
  final TextStyle? style;

  /// Text alignment.
  final TextAlign? textAlign;

  /// Text direction.
  final TextDirection? textDirection;

  /// Whether the text should break at soft line breaks.
  final bool? softWrap;

  /// How visual overflow should be handled.
  final TextOverflow? overflow;

  /// The number of font pixels for each logical pixel.
  final TextScaler? textScaler;

  /// An optional maximum number of lines for the text.
  final int? maxLines;

  /// Creates a TranslatedText widget.
  const TranslatedText(
    this.translationKey, {
    super.key,
    this.parameters,
    this.namespace,
    this.style,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      translationKey.tr(parameters: parameters, namespace: namespace),
      style: style,
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
    );
  }
}
