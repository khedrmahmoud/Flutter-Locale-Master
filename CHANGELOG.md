# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.3] - 2025-09-22

### Changed
- **Code Formatting**: Applied consistent Dart code formatting across all source files
- **Documentation**: Updated inline documentation and comments for better readability

### Technical Details
- Ran `dart format` on entire codebase for consistent styling
- Improved code documentation and formatting
- Maintained all existing functionality while improving code quality

### Fixed
- **Package Description**: Shortened description to meet pub.dev requirements (60-180 characters)
- **Deprecated API Usage**: Replaced deprecated `ui.window.locales` with `WidgetsBinding.instance.platformDispatcher.locales`
- **Static Analysis**: Fixed lint warnings for deprecated member usage
- **Pub Points**: Improved package score from 140 to target 160 points

### Technical Details
- Updated locale detection to use modern Flutter APIs
- Improved package metadata for better pub.dev presentation
- Maintained backward compatibility while fixing deprecation warnings

### Fixed
- **Supported Locales Parameter**: Fixed `supportedLocales` parameter in `initialize()` method to properly configure allowed locales
- **Localization Delegate**: Fixed `FlutterLocaleMasterDelegate.isSupported()` to use configured supported locales instead of auto-detected ones
- **Locale Validation**: Resolved warnings about unsupported locales in MaterialApp integration
- **Example App**: Updated example app to properly use supported locales configuration

### Technical Details
- Delegate now respects the `supportedLocales` parameter passed to `initialize()`
- Fixed locale validation warnings when using Arabic and other RTL locales
- Improved integration with Flutter's localization system

### Added
- **Multi-file Translation Support**: Organize translations with multiple JSON files per locale
- **Namespace-based Organization**: Automatic namespace detection from file names
- **Locale-specific General Files**: Use locale code as filename for default namespace (e.g., `en.json`, `ar.json`)
- **Field Translation Support**: Dedicated `fields.json` files with `.field()` extension method
- **Validation Message Support**: Dedicated `validation.json` files for form validation
- **Automatic Text Direction Switching**: Framework-level RTL/LTR handling based on locale
- **Asset-based Translation Loading**: Load translations from Flutter assets with preloading
- **Reactive Locale Management**: LocaleController with ChangeNotifier for automatic UI updates
- **Custom Widgets**: TranslatedText, TranslatedRichText, LocaleConsumer, LocalizationProvider
- **BuildContext Extensions**: Convenient translation methods (tr, plural, field, isRTL, locale)
- **String Extensions**: Context-free translation access using FlutterLocaleMaster.instance
- **Pluralization Support**: Built-in plural forms with count parameter and ICU MessageFormat
- **Parameter Replacement**: Dynamic text substitution with named placeholders
- **Flutter Integration**: Custom LocalizationsDelegate for MaterialApp integration
- **Service Layer Architecture**: Modular design with interfaces for all core services
- **Translation Caching**: In-memory caching with concurrent loading for optimal performance
- **Comprehensive Testing**: Unit and widget tests for all major components (28 tests)
- **Example Application**: Complete demo with English, French, and Arabic support

### Technical Details
- **Dependencies**: `flutter_localizations` (Flutter SDK)
- **Flutter SDK**: >=1.17.0
- **Dart SDK**: >=3.8.1
- **Platform Support**: iOS, Android, Web, Desktop
- **Architecture**: Clean architecture with services, providers, controllers, widgets, and extensions
- **File Structure**: `lang/{locale}/{namespace}.json` (e.g., `lang/en/en.json`, `lang/en/fields.json`)
- **Namespace Support**: Automatic namespace resolution from filename
- **RTL Languages**: Full support for Arabic, Hebrew, Persian, Urdu, and other RTL scripts

## [0.0.1] - 2025-01-21

* Initial release with basic localization functionality.
