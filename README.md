# Flutter Locale Master

A comprehensive, production-ready Flutter localization package with automatic text direction switching, custom widgets, and developer-friendly APIs. Built for modern Flutter apps with performance and ease of use in mind.

## ✨ Features

- 🚀 **One-line initialization** with asset-based translations
- 🔄 **Automatic text direction** switching (LTR/RTL) based on locale
- ⚡ **Reactive UI updates** when locale changes
- 🌍 **Namespace support** for organized translation files
- 📱 **Built-in pluralization** with ICU MessageFormat syntax
- 🔧 **Parameter interpolation** with named placeholders
- 🎨 **Context extensions** for convenient access
- 🧵 **String extensions** for BuildContext-free usage
- 🏗️ **Custom widgets** for automatic translation
- 📦 **Type-safe API** with full null-safety
- 🎯 **Performance optimized** with caching and preloading
- 🧪 **Comprehensive testing** coverage
- 📚 **Rich documentation** and examples

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_locale_master: ^1.0.0
```

## 🚀 Quick Start

### 1. Setup Translation Files

Create translation files in your `assets/` directory:

```
assets/
  lang/
    en/
      messages.json
      fields.json
      validation.json
    ar/
      messages.json
      fields.json
      validation.json
    fr/
      messages.json
      fields.json
      validation.json
```

**Example `messages.json`:**
```json
{
  "hello": "Hello",
  "welcome": "Welcome {name}!",
  "item_count": "no items | {count} item | {count} items",
  "current_time": "Current time: {time}",
  "user_greeting": "Hello {name}, welcome back!"
}
```

**Example `fields.json`:**
```json
{
  "email": "Email Address",
  "password": "Password",
  "name": "Full Name"
}
```

### 2. Initialize the Package

```dart
import 'package:flutter/material.dart';
import 'package:flutter_locale_master/flutter_locale_master.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize with asset translations
  final localeMaster = await FlutterLocaleMaster.initialize(
    basePath: 'lang/',
    initialLocale: const Locale('en'),
    fallbackLocale: const Locale('en'),
  );

  runApp(MyApp(localeMaster: localeMaster));
}
```

### 3. Wrap Your App

```dart
class MyApp extends StatelessWidget {
  final FlutterLocaleMaster localeMaster;

  const MyApp({super.key, required this.localeMaster});

  @override
  Widget build(BuildContext context) {
    return localeMaster.wrapApp(
      (locale, textDirection) => MaterialApp(
        title: 'My App',
        localizationsDelegates: [
          localeMaster.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: localeMaster.supportedLocales,
        locale: locale,
        home: const HomePage(),
      ),
    );
  }
}
```

**That's it!** Your app now supports multiple languages with automatic RTL/LTR switching.

## 🎯 Usage Examples

### Basic Translation

#### Using Widgets (Recommended)
```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TranslatedText('app_title'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TranslatedText(
              'welcome',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            TranslatedText(
              'current_time',
              parameters: {'time': DateTime.now().toString()},
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Using Context Extensions
```dart
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(context.tr('profile_title')),
        Text(context.tr('welcome', parameters: {'name': user.name})),
        Text(context.plural('item_count', itemCount)),
        Text(context.field('email')),
      ],
    );
  }
}
```

#### Using String Extensions
```dart
class Utils {
  static String getGreeting(String userName) {
    return 'welcome'.tr(parameters: {'name': userName});
  }

  static String formatItemCount(int count) {
    return 'item_count'.plural(count);
  }

  static bool hasTranslation(String key) {
    return key.exists();
  }
}

class FormLabels {
  static String get email => 'email'.field();
  static String get password => 'password'.field();
}
```

### Advanced Features

#### Locale Management
```dart
class LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: context.currentLocaleObj,
      items: context.supportedLocales.map((localeString) {
        final locale = Locale(localeString);
        return DropdownMenuItem(
          value: locale,
          child: Text(locale.languageCode.toUpperCase()),
        );
      }).toList(),
      onChanged: (newLocale) {
        if (newLocale != null) {
          context.setLocaleObj(newLocale);
        }
      },
    );
  }
}
```

#### Rich Text Translation
```dart
TranslatedRichText.rich(
  'terms_agreement',
  parameters: {'app': 'MyApp'},
  spanBuilder: (translatedText) {
    final parts = translatedText.split('{app}');
    return TextSpan(
      children: [
        TextSpan(text: parts[0]),
        TextSpan(
          text: 'MyApp',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        if (parts.length > 1) TextSpan(text: parts[1]),
      ],
    );
  },
)
```

#### Locale Consumer for Complex UI
```dart
class AdaptiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocaleConsumer(
      builder: (context, localization, child) {
        final isRTL = localization.notifier.isRTL;
        return Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: Row(
            children: [
              if (!isRTL) child!,
              Expanded(
                child: Text(localization.provider.t('content')),
              ),
              if (isRTL) child!,
            ],
          ),
        );
      },
      child: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    );
  }
}
```

## 🔧 API Reference

### FlutterLocaleMaster (Singleton)

| Method | Description |
|--------|-------------|
| `initialize()` | Initialize the localization system |
| `wrapApp()` | Wrap MaterialApp with localization support |
| `tr()` | Translate a key with optional parameters |
| `plural()` | Translate with pluralization |
| `field()` | Translate a field key |
| `setLocale()` | Change the current locale |
| `reset()` | Reset to initial locale |
| `resetToSystemLocale()` | Reset to system locale |
| `isCurrentLocale()` | Check if locale is current |
| `toggleLocale()` | Toggle between two locales |
| `supportedLocales` | Get supported locales |
| `isLocaleSupported()` | Check if locale is supported |
| `currentLocale` | Get current locale |
| `textDirection` | Get current text direction |

### BuildContext Extensions

| Method | Description |
|--------|-------------|
| `tr()` | Translate with parameters and namespace |
| `plural()` | Pluralize with count |
| `field()` | Translate field keys |
| `hasTranslation()` | Check if key exists |
| `setLocale()` | Set locale by string |
| `setLocaleObj()` | Set locale by Locale object |
| `currentLocale` | Get current locale string |
| `currentLocaleObj` | Get current locale object |
| `supportedLocales` | Get supported locales |
| `fallbackLocale` | Get fallback locale |
| `textDirection` | Get text direction |
| `isRTL` | Check if current locale is RTL |

### String Extensions

| Method | Description |
|--------|-------------|
| `tr()` | Translate string key |
| `plural()` | Pluralize string key |
| `field()` | Translate as field key |
| `exists()` | Check if translation exists |

### Widgets

| Widget | Description |
|--------|-------------|
| `TranslatedText` | Simple translated text widget |
| `TranslatedRichText` | Rich translated text widget |
| `LocaleConsumer` | Consumer that rebuilds on locale change |

## 🏗️ Architecture

Flutter Locale Master follows a clean, layered architecture:

```
┌─────────────────┐
│   Extensions    │  String & Context APIs
├─────────────────┤
│    Widgets      │  TranslatedText, LocaleConsumer
├─────────────────┤
│   Controllers   │  Locale state management
├─────────────────┤
│   Providers     │  Translation data access
├─────────────────┤
│   Services      │  Core functionality
└─────────────────┘
```

### Key Components

- **Services Layer**: Asset loading, caching, validation, pluralization
- **Providers Layer**: Translation data management and access
- **Controllers Layer**: Locale state and change notifications
- **Widgets Layer**: Reactive UI components
- **Extensions Layer**: Developer-friendly APIs

## 🔄 Automatic Text Direction

The package automatically handles RTL/LTR switching:

- **LTR Languages**: English, French, German, Spanish, etc.
- **RTL Languages**: Arabic, Hebrew, Persian, Urdu, etc.

```dart
// Automatic RTL support - no extra code needed!
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TranslatedText('app_title'), // Automatically RTL in Arabic
      ),
      body: TranslatedText('content'), // Text direction adapts automatically
    );
  }
}
```

## 📁 Translation File Organization

### Basic Structure
```
assets/
  lang/
    en/
      messages.json    # General messages
      fields.json      # Form field labels
      validation.json  # Validation messages
    ar/
      messages.json
      fields.json
      validation.json
```

### Namespace Usage
```dart
// Access messages namespace (default)
context.tr('welcome')

// Access fields namespace
context.field('email')  // Same as: context.tr('email', namespace: 'fields')

// Access validation namespace
context.tr('required', namespace: 'validation')
```

### Pluralization Syntax
```json
{
  "item": "no items | {count} item | {count} items",
  "day": "today | yesterday | {count} days ago"
}
```

## 🧪 Testing

The package includes comprehensive tests. Run tests with:

```bash
flutter test
```

Example test:
```dart
void main() {
  test('Translation loading', () async {
    final localeMaster = await FlutterLocaleMaster.initialize(
      basePath: 'lang/',
    );

    expect(localeMaster.tr('hello'), 'Hello');
    expect(localeMaster.plural('item', 2), '2 items');
  });
}
```

## 🔄 Migration Guide

### From easy_localization

1. **Replace initialization:**
   ```dart
   // Before
   EasyLocalization(
     supportedLocales: [Locale('en'), Locale('ar')],
     path: 'lang',
   )

   // After
   final localeMaster = await FlutterLocaleMaster.initialize(
     basePath: 'lang/',
     initialLocale: const Locale('en'),
   );
   ```

2. **Update MaterialApp wrapping:**
   ```dart
   // Before
   EasyLocalization(
     child: MyApp(),
   )

   // After
   localeMaster.wrapApp((locale, textDirection) => MaterialApp(...))
   ```

3. **Translation access remains the same:**
   ```dart
   // Both work the same
   context.tr('hello')
   'hello'.tr()
   ```

### From flutter_localizations

1. **Add Flutter Locale Master initialization**
2. **Replace LocalizationsDelegate usage**
3. **Use TranslatedText widgets or context extensions**

## 📈 Performance

- **Preloading**: All translations loaded at startup
- **Caching**: In-memory caching prevents disk I/O
- **Lazy initialization**: Singleton pattern prevents waste
- **Concurrent loading**: Multiple files loaded simultaneously
- **Minimal rebuilds**: Only affected widgets update on locale change

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Add tests for new features
4. Ensure all tests pass
5. Update documentation
6. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 📞 Support

- 📖 [Documentation](https://pub.dev/packages/flutter_locale_master)
- 🐛 [Issues](https://github.com/your-repo/issues)
- 💬 [Discussions](https://github.com/your-repo/discussions)

---

Made with ❤️ for the Flutter community