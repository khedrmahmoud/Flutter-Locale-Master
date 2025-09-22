import 'package:flutter/widgets.dart';
import 'package:flutter_locale_master/flutter_locale_master.dart';

/// A widget that displays translated rich text with automatic locale updates.
///
/// [TranslatedRichText] extends [RichText] with translation capabilities,
/// allowing you to display formatted, localized text that automatically
/// updates when the locale changes. Supports both simple text and complex
/// rich text with custom spans.
///
/// ## Basic Usage
///
/// ```dart
/// class InfoScreen extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: Padding(
///         padding: const EdgeInsets.all(16),
///         child: TranslatedRichText(
///           'app_description',
///           style: Theme.of(context).textTheme.bodyLarge,
///           textAlign: TextAlign.center,
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
/// TranslatedRichText(
///   'user_greeting',
///   parameters: {'name': user.name, 'level': user.level},
///   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
/// )
/// ```
///
/// ### Custom Rich Text Spans
///
/// ```dart
/// TranslatedRichText.rich(
///   'terms_agreement',
///   parameters: {'app': 'MyApp'},
///   spanBuilder: (translatedText) {
///     // Parse and create rich spans
///     final parts = translatedText.split('{app}');
///     return TextSpan(
///       children: [
///         TextSpan(text: parts[0]),
///         TextSpan(
///           text: 'MyApp',
///           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
///           recognizer: TapGestureRecognizer()
///             ..onTap = () => launchUrl(Uri.parse('https://myapp.com')),
///         ),
///         if (parts.length > 1) TextSpan(text: parts[1]),
///       ],
///     );
///   },
/// )
/// ```
///
/// ### Highlighted Keywords
///
/// ```dart
/// TranslatedRichText.rich(
///   'search_results',
///   parameters: {'query': searchQuery, 'count': results.length},
///   spanBuilder: (translatedText) {
///     final spans = <TextSpan>[];
///     final words = translatedText.split(' ');
///
///     for (final word in words) {
///       if (word.contains(searchQuery)) {
///         spans.add(TextSpan(
///           text: '$word ',
///           style: TextStyle(
///             backgroundColor: Colors.yellow,
///             fontWeight: FontWeight.bold,
///           ),
///         ));
///       } else {
///         spans.add(TextSpan(text: '$word '));
///       }
///     }
///
///     return TextSpan(children: spans);
///   },
/// )
/// ```
///
/// ### Multi-language Support with Icons
///
/// ```dart
/// TranslatedRichText.rich(
///   'language_selector',
///   spanBuilder: (translatedText) {
///     return TextSpan(
///       children: [
///         WidgetSpan(
///           child: Icon(Icons.language, size: 16),
///         ),
///         TextSpan(text: ' $translatedText'),
///       ],
///     );
///   },
/// )
/// ```
///
/// ## Constructor Options
///
/// ### Simple Text ([TranslatedRichText])
/// - Use for basic translated text with consistent styling
/// - All [RichText] properties available
/// - Automatic translation with parameters and namespaces
///
/// ### Rich Text ([TranslatedRichText.rich])
/// - Use for complex formatting with custom spans
/// - Provide [spanBuilder] to create [TextSpan] from translated text
/// - Full control over text styling and interactions
///
/// ## Parameters
///
/// - [translationKey]: The translation key to look up
/// - [parameters]: Optional parameters for interpolation
/// - [namespace]: Optional namespace for scoped translations
/// - [spanBuilder]: Builder for custom [TextSpan] creation (rich constructor only)
/// - [style]: Base text style (simple constructor only)
/// - [textAlign]: Text alignment (default: [TextAlign.start])
/// - [textDirection]: Text direction override
/// - [softWrap]: Soft wrapping behavior (default: true)
/// - [overflow]: Overflow handling (default: [TextOverflow.clip])
/// - [textScaleFactor]: Text scaling factor (default: 1.0)
/// - [maxLines]: Maximum number of lines
/// - [strutStyle]: Strut style for consistent line heights
///
/// ## Performance
///
/// - Automatically rebuilds only when locale changes
/// - Uses [LocaleConsumer] for efficient updates
/// - [spanBuilder] called only when translation changes
/// - Supports all [RichText] performance optimizations
///
/// ## Error Handling
///
/// If translation fails, displays the key itself.
/// Ensure [FlutterLocaleMaster] is initialized and keys exist.
///
/// ## Alternatives
///
/// - [TranslatedText]: For simple text without rich formatting
/// - [RichText] with context extensions: For more control
/// - [LocaleConsumer]: For complex locale-dependent widgets
///
/// See also: [TranslatedText], [RichText], [TextSpan], [BuildContext.tr]
class TranslatedRichText extends StatelessWidget {
  /// The translation key.
  final String translationKey;

  /// Optional parameters for the translation.
  final Map<String, dynamic>? parameters;

  /// Optional namespace for the translation.
  final String? namespace;

  /// The text style for the rich text.
  final TextStyle? style;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// The directionality of the text.
  final TextDirection? textDirection;

  /// Whether the text should break at soft line breaks.
  final bool? softWrap;

  /// How visual overflow should be handled.
  final TextOverflow? overflow;

  /// The number of font pixels for each logical pixel.
  final double? textScaleFactor;

  /// An optional maximum number of lines for the text.
  final int? maxLines;

  /// Whether to paint the text with a strikethrough.
  final bool? strutStyle;

  /// Builder for creating custom TextSpan from translated text.
  final TextSpan Function(String translatedText)? spanBuilder;

  /// Creates a TranslatedRichText with simple text display.
  const TranslatedRichText(
    this.translationKey, {
    super.key,
    this.parameters,
    this.namespace,
    this.style,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.strutStyle,
  }) : spanBuilder = null;

  /// Creates a TranslatedRichText with custom span builder.
  const TranslatedRichText.rich(
    this.translationKey, {
    super.key,
    this.parameters,
    this.namespace,
    required this.spanBuilder,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.strutStyle,
  }) : style = null;

  @override
  Widget build(BuildContext context) {
   final textSpan =
            spanBuilder?.call(translationKey) ??
            TextSpan(
              text: translationKey.tr(
                parameters: parameters,
                namespace: namespace,
              ),
              style: style,
            );

        return RichText(
          text: textSpan,
          textAlign: textAlign ?? TextAlign.start,
          textDirection: textDirection,
          softWrap: softWrap ?? true,
          overflow: overflow ?? TextOverflow.clip,
          maxLines: maxLines,
          textScaler: TextScaler.linear(textScaleFactor ?? 1.0),
          strutStyle: strutStyle == true ? StrutStyle() : null,
        );
  }
}
