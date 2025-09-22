import 'package:flutter/widgets.dart';
import 'package:flutter_locale_master/flutter_locale_master.dart';

 
/// A widget that rebuilds when the locale changes.
///
/// LocaleConsumer automatically rebuilds its child when the locale changes,
/// providing access to the current localization state. It's similar to
/// [Consumer] from provider package but specifically for localization.
///
/// ## Usage
///
/// ```dart
/// LocaleConsumer(
///   builder: (context, localization, child) {
///     final greeting = localization.provider.t('greeting');
///     return Text(greeting);
///   },
///   child: SomeExpensiveWidget(), // Won't rebuild
/// )
/// ```
///
/// ## Performance
///
/// The [child] parameter is static and won't rebuild when locale changes.
/// Only the result of [builder] rebuilds.
///
/// ```dart
/// LocaleConsumer(
///   builder: (context, localization, child) {
///     return Column(
///       children: [
///         Text(localization.provider.t('title')), // Rebuilds
///         child!, // Doesn't rebuild
///       ],
///     );
///   },
///   child: HeavyWidget(),
/// )
/// ```
class LocaleConsumer extends StatelessWidget {
  /// Builds the widget tree based on localization state.
  ///
  /// [context] The build context.
  /// [localization] The localization provider data.
  /// [child] The static child widget that doesn't rebuild.
  final Widget Function(
    BuildContext context,
    LocalizationProvider localization,
    Widget? child,
  ) builder;

  /// A static child widget that doesn't rebuild with locale changes.
  final Widget? child;

  /// Creates a LocaleConsumer.
  ///
  /// [builder] Function that builds the widget tree.
  /// [child] Optional static child that doesn't rebuild.
  const LocaleConsumer({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return builder(
      context,
      LocalizationProvider.of(context),
      child,
    );
  }
}