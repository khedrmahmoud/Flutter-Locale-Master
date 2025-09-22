import 'interfaces.dart';

/// Implementation of PluralizationHandler for handling plural forms in translations.
class DefaultPluralizationHandler implements PluralizationHandler {
  @override
  String applyPluralization(String message, int count) {
    if (!message.contains('|')) {
      return message;
    }

    final parts = message.split('|').map((part) => part.trim()).toList();

    if (parts.length == 1) {
      return parts[0];
    } else if (parts.length == 2) {
      // Simple singular/plural: "item|items"
      return count == 1 ? parts[0] : parts[1];
    } else if (parts.length >= 3) {
      // ICU MessageFormat style: "zero|singular|plural"
      if (count == 0 && parts.length > 0) {
        return parts[0]; // zero case
      } else if (count == 1 && parts.length > 1) {
        return parts[1]; // singular case
      } else if (parts.length > 2) {
        return parts[2]; // plural case
      }
    }

    // Fallback to last part
    return parts.last;
  }

  @override
  String getPluralForm(String singular, String plural, int count) {
    return count == 1 ? singular : plural;
  }
}
