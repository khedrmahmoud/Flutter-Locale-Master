import 'package:flutter/material.dart';

import '../../providers/lang_provider.dart';
import '../../controllers/locale_controller.dart';

/// Provides localization services throughout the widget tree.
///
/// LocalizationProvider is an [InheritedNotifier] that makes the [LangProvider]
/// and [LocaleController] available to all descendant widgets. It combines
/// the translation capabilities of the provider with the reactive locale
/// management of the controller.
///
/// ## Usage
///
/// ```dart
/// void main() async {
///   final provider = AssetLangProvider();
///   await provider.initialize();
///
///   final controller = LocaleController(provider: provider);
///   await controller.initialize();
///
///   runApp(
///     LocalizationProvider(
///       controller: controller,
///       provider: provider,
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
///
/// ## Accessing in Widgets
///
/// Use [LocalizationProvider.of] to access the provider and controller:
///
/// ```dart
/// class MyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     final localization = LocalizationProvider.of(context);
///     final greeting = localization.provider.t('greeting');
///
///     return Text(greeting);
///   }
/// }
/// ```
///
/// Or use the [LocaleConsumer] for automatic rebuilds:
///
/// ```dart
/// LocaleConsumer(
///   builder: (context, localization, child) {
///     return Text(localization.provider.t('hello'));
///   },
/// )
/// ```
class LocalizationProvider extends InheritedNotifier<LocaleController> {
  /// The language provider for translations.
  final LangProvider provider;

  /// Creates a LocalizationProvider.
  ///
  /// [controller] The locale controller (must extend ChangeNotifier).
  /// [provider] The language provider for translations.
  /// [child] The child widget tree.
  const LocalizationProvider({
    super.key,
    required LocaleController controller,
    required this.provider,
    required super.child,
  }) : super(notifier: controller);

  /// Gets the LocalizationProvider from the given context.
  ///
  /// Returns the nearest LocalizationProvider in the widget tree.
  /// Throws an error if no LocalizationProvider is found.
  static LocalizationProvider of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<LocalizationProvider>();
    assert(result != null, 'No LocalizationProvider found in context');
    return result!;
  }

  /// Gets the LocalizationProvider from the given context without depending on it.
  ///
  /// This method does not establish a dependency, so the widget won't rebuild
  /// when the locale changes. Use this for one-time access or in initState.
  static LocalizationProvider? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<LocalizationProvider>();
  }

  @override
  bool updateShouldNotify(LocalizationProvider oldWidget) {
    return oldWidget.provider != provider || oldWidget.notifier != notifier;
  }
}
