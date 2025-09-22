import '../flutter_locale_master.dart';

/// Extension methods on [String] for convenient localization access.
///
/// These extensions allow any string to be used as a translation key directly,
/// providing a fluent API for translations without BuildContext dependency.
/// They use the [FlutterLocaleMaster.instance] singleton for access.
///
/// ## Core Features
///
/// - **Translation**: `'hello'.tr()` - Simple translation
/// - **Parameters**: `'welcome'.tr(parameters: {'name': 'John'})` - With interpolation
/// - **Pluralization**: `'item'.plural(5)` - Count-based plural forms
/// - **Fields**: `'email'.field()` - Form field labels
/// - **Existence check**: `'key'.exists()` - Check if translation exists
///
/// ## Basic Usage
///
/// ```dart
/// class UserService {
///   String getWelcomeMessage(String userName) {
///     return 'welcome_user'.tr(parameters: {'name': userName});
///   }
///
///   String getItemCount(int count) {
///     return 'item_count'.plural(count);
///   }
///
///   bool hasErrorMessage(String errorKey) {
///     return errorKey.exists(namespace: 'errors');
///   }
/// }
///
/// class FormLabels {
///   static String get email => 'email'.field();
///   static String get password => 'password'.field();
///   static String get confirmPassword => 'confirm_password'.field();
/// }
///
/// class MyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Column(
///       children: [
///         Text('app_title'.tr()),
///         Text('welcome'.tr(parameters: {'name': 'John'})),
///         Text('item'.plural(itemCount)),
///         TextFormField(
///           decoration: InputDecoration(
///             labelText: 'email'.field(),
///             hintText: 'email_hint'.field(),
///           ),
///         ),
///       ],
///     );
///   }
/// }
/// ```
///
/// ## Advanced Usage
///
/// ### Dynamic Keys
///
/// ```dart
/// String getStatusMessage(String status) {
///   final key = 'status_$status'; // e.g., 'status_active', 'status_inactive'
///   return key.exists() ? key.tr() : 'Unknown status';
/// }
/// ```
///
/// ### Validation Messages
///
/// ```dart
/// class ValidationMessages {
///   static String required(String fieldName) {
///     return 'validation_required'.tr(parameters: {'field': fieldName.field()});
///   }
///
///   static String minLength(String fieldName, int minLength) {
///     return 'validation_min_length'.tr(parameters: {
///       'field': fieldName.field(),
///       'count': minLength,
///     });
///   }
///
///   static String email() {
///     return 'validation_email'.tr();
///   }
/// }
/// ```
///
/// ### Conditional Translations
///
/// ```dart
/// String getButtonText(bool isLoading, bool isCompleted) {
///   if (isLoading) return 'loading'.tr();
///   if (isCompleted) return 'completed'.tr();
///   return 'submit'.tr();
/// }
/// ```
///
/// ## Error Handling
///
/// If [FlutterLocaleMaster] has not been initialized, all methods will:
/// - Return the original string unchanged ([tr], [plural], [field])
/// - Return `false` for [exists]
///
/// Make sure to call [FlutterLocaleMaster.initialize] before using these extensions.
///
/// ## Performance Notes
///
/// - Extensions use the singleton instance for fast access
/// - No BuildContext dependency - works in services, utilities, etc.
/// - Translations are cached in memory after initialization
/// - Minimal overhead - just method dispatch to singleton
///
/// ## Best Practices
///
/// - Use for static strings and utility functions
/// - Prefer [BuildContext] extensions in widgets for better testability
/// - Combine with [exists()] for defensive programming
/// - Use meaningful key names that describe content, not location
extension LocalizationString on String {
  /// Translates this string key with optional parameters and namespace.
  ///
  /// [parameters] Optional parameters to replace in the translation.
  /// [namespace] Optional namespace for the translation.
  ///
  /// Returns the translated string, or the original key if not initialized.
  String tr({
    Map<String, dynamic>? parameters,
    String? namespace,
  }) {
    try {
      return FlutterLocaleMaster.instance.tr(
        this,
        parameters: parameters,
        namespace: namespace,
      );
    } catch (e) {
      // Return original key if not initialized
      return this;
    }
  }

  /// Translates this string key with pluralization based on count.
  ///
  /// [count] The count to determine singular/plural form.
  /// [parameters] Optional parameters to replace in the translation.
  /// [namespace] Optional namespace for the translation.
  ///
  /// Returns the translated string with pluralization applied.
  String plural(
    int count, {
    Map<String, dynamic>? parameters,
    String? namespace,
  }) {
    try {
      return FlutterLocaleMaster.instance.plural(
        this,
        count,
        parameters: parameters,
        namespace: namespace,
      );
    } catch (e) {
      // Return original key if not initialized
      return this;
    }
  }

  /// Translates this string as a field key with automatic "fields" namespace.
  ///
  /// [namespace] Optional namespace override (defaults to "fields").
  ///
  /// Returns the translated field name.
  String field({String? namespace}) {
    try {
      return FlutterLocaleMaster.instance.provider.field(this, namespace: namespace);
    } catch (e) {
      // Return original key if not initialized
      return this;
    }
  }

  /// Checks if this translation key exists.
  ///
  /// [namespace] Optional namespace for the translation.
  ///
  /// Returns true if the key exists, false otherwise.
  bool exists({String? namespace}) {
    try {
      return FlutterLocaleMaster.instance.provider.has(this, namespace: namespace);
    } catch (e) {
      // Return false if not initialized
      return false;
    }
  }
}