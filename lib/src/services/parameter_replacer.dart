import 'interfaces.dart';

/// Implementation of ParameterReplacer for replacing parameters in translation strings.
class DefaultParameterReplacer implements ParameterReplacer {
  /// Custom parameter replacers.
  final List<String Function(String key, dynamic value, Map<String, dynamic> parameters)> _replacers = [];

  @override
  String replaceParameters(String message, Map<String, dynamic> parameters) {
    String result = message;

    // First apply custom replacers to get replacement values
    final customReplacements = <String, String>{};
    for (final replacer in _replacers) {
      for (final entry in parameters.entries) {
        final replacement = replacer(entry.key, entry.value, parameters);
        if (replacement != ':${entry.key}') {
          // Only use if replacer actually did something
          customReplacements[entry.key] = replacement;
        }
      }
    }

    // Standard :param replacement
    for (final entry in parameters.entries) {
      final placeholder = ':${entry.key}';
      final replacement = customReplacements[entry.key] ?? entry.value.toString();
      result = result.replaceAll(placeholder, replacement);
    }

    return result;
  }

  @override
  void addReplacer(String Function(String key, dynamic value, Map<String, dynamic> parameters) replacer) {
    _replacers.add(replacer);
  }
}