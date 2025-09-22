# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-01-21

### Added
- **Automatic Text Direction Switching**: Framework-level RTL/LTR handling based on locale
- **Asset-based Translation Loading**: Load translations from Flutter assets with preloading
- **Reactive Locale Management**: LocaleController with ChangeNotifier for automatic UI updates
- **Custom Widgets**: TranslatedText, LocaleConsumer, LocalizationProvider
- **BuildContext Extensions**: Convenient translation methods (tr, plural, isRTL, locale)
- **Pluralization Support**: Built-in plural forms with count parameter
- **Parameter Replacement**: Dynamic text substitution with {param} placeholders
- **Flutter Integration**: LocalizationsDelegate for MaterialApp integration
- **Comprehensive Testing**: Unit and widget tests for all major components
- **Example Application**: Complete demo with English, French, and Arabic support

### Technical Details
- **Dependencies**: `flutter_localizations` (Flutter SDK)
- **Flutter SDK**: >=1.17.0
- **Dart SDK**: >=3.8.1
- **Platform Support**: iOS, Android, Web, Desktop

## [0.0.1] - 2025-01-21

* Initial release with basic localization functionality.
