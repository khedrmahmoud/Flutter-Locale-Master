import 'interfaces.dart';

/// Implementation of PluralizationHandler for handling plural forms in translations.
class DefaultPluralizationHandler implements PluralizationHandler {
  @override
  String applyPluralization(String message, int count) {
    if (!message.contains('|')) {
      return message;
    }

    final parts = message.split('|');
    return count == 1 ? parts[0] : (parts.length > 1 ? parts[1] : parts[0]);
  }

  @override
  String getPluralForm(String singular, String plural, int count) {
    return count == 1 ? singular : plural;
  }
}
