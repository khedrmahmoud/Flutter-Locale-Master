import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_locale_master/flutter_locale_master.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Simplified initialization with initial locale!
  final localeMaster = await FlutterLocaleMaster.initialize(
    basePath: 'lang/',
    initialLocale: const Locale('ar'),
    fallbackLocale: const Locale('en'),
  );

  runApp(MyApp(localeMaster: localeMaster));
}

class MyApp extends StatelessWidget {
  final FlutterLocaleMaster localeMaster;

  const MyApp({super.key, required this.localeMaster});

  @override
  Widget build(BuildContext context) {
    return localeMaster.wrapApp(
      (locale) => MaterialApp(
        title: 'Flutter Locale Master Example',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        localizationsDelegates: [
          localeMaster.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
        locale: locale,
        home: HomePage(localeMaster: localeMaster),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final FlutterLocaleMaster localeMaster;

  const HomePage({super.key, required this.localeMaster});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _appleCount = 1;
  String _userName = 'Alice';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TranslatedText('welcome'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (locale) =>
                widget.localeMaster.setLocale(Locale(locale)),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'en', child: Text('English')),
              const PopupMenuItem(value: 'fr', child: Text('Français')),
              const PopupMenuItem(value: 'ar', child: Text('العربية')),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.localeMaster.currentLocale?.languageCode.toUpperCase() ??
                    'EN',
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TranslationSection(
              title: 'Basic Translations',
              children: [
                TranslationExample(
                  label: 'Simple greeting',
                  content: TranslatedText(
                    'greeting',
                    parameters: {'name': _userName},
                  ),
                ),
                TranslationExample(
                  label: 'Welcome message',
                  content: TranslatedText('welcome'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            TranslationSection(
              title: 'Pluralization',
              children: [
                TranslationExample(
                  label: 'Items (singular/plural)',
                  content: Text(context.plural('items', _appleCount)),
                ),
                TranslationExample(
                  label: 'Apples with count',
                  content: Text(context.plural('apples', _appleCount)),
                ),
                AppleCountSlider(
                  count: _appleCount,
                  onChanged: (value) {
                    setState(() {
                      _appleCount = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            TranslationSection(
              title: 'Parameter Replacement',
              children: [
                NameInputField(
                  userName: _userName,
                  onChanged: (value) {
                    setState(() {
                      _userName = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            TranslationSection(
              title: 'Using LocaleConsumer',
              children: [
                TranslationExample(
                  label: 'Consumer example',
                  content: Text(
                    FlutterLocaleMaster.instance.tr(
                      'greeting',
                      parameters: {'name': 'Bob'},
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            TranslationSection(
              title: 'Context Extensions',
              children: [
                TranslationExample(
                  label: 'Current locale',
                  content: Text(
                    'Current: ${widget.localeMaster.currentLocale?.languageCode}',
                  ),
                ),
                TranslationExample(
                  label: 'Supported locales',
                  content: Text(
                    'Supported: ${context.supportedLocales.join(', ')}',
                  ),
                ),
                TranslationExample(
                  label: 'Has translation',
                  content: Text(
                    'Has "greeting": ${context.hasTranslation('greeting')}',
                  ),
                ),
                TranslationExample(
                  label: 'Text direction',
                  content: Text('Direction: ${context.isRTL ? 'RTL' : 'LTR'}'),
                ),
                TranslationExample(
                  label: 'Is RTL',
                  content: Text('Is RTL: ${context.isRTL}'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            TranslationSection(
              title: 'String Extensions',
              children: [
                TranslationExample(
                  label: 'Simple translation',
                  content: Text('greeting'.tr(parameters: {'name': _userName})),
                ),
                TranslationExample(
                  label: 'Plural with extension',
                  content: Text('apples'.plural(_appleCount)),
                ),
                TranslationExample(
                  label: 'Field translation',
                  content: Text('email'.field()),
                ),
                TranslationExample(
                  label: 'Translation exists',
                  content: Text('greeting'.exists() ? 'Yes' : 'No'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            TranslationSection(
              title: 'Field Translations',
              children: [
                TranslationExample(
                  label: 'Email field',
                  content: Text('email'.field()),
                ),
                TranslationExample(
                  label: 'Name field',
                  content: Text('name'.field()),
                ),
                TranslationExample(
                  label: 'Password field',
                  content: Text('password'.field()),
                ),
              ],
            ),

            const SizedBox(height: 24),

            TranslationSection(
              title: 'Validation Messages',
              children: [
                TranslationExample(
                  label: 'Required validation',
                  content: Text('required'.tr(namespace: 'validation')),
                ),
                TranslationExample(
                  label: 'Email invalid',
                  content: Text('email_invalid'.tr(namespace: 'validation')),
                ),
                TranslationExample(
                  label: 'Password too short',
                  content: Text('password_too_short'.tr(namespace: 'validation')),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class TranslationSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const TranslationSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }
}

class TranslationExample extends StatelessWidget {
  final String label;
  final Widget content;

  const TranslationExample({
    super.key,
    required this.label,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: content),
        ],
      ),
    );
  }
}

class AppleCountSlider extends StatelessWidget {
  final int count;
  final ValueChanged<int> onChanged;

  const AppleCountSlider({
    super.key,
    required this.count,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TranslationExample(
      label: 'Apple count slider',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Count: $count'),
          Slider(
            value: count.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            onChanged: (value) => onChanged(value.toInt()),
          ),
          Text(context.plural('apples', count)),
        ],
      ),
    );
  }
}

class NameInputField extends StatefulWidget {
  final String userName;
  final ValueChanged<String> onChanged;

  const NameInputField({
    super.key,
    required this.userName,
    required this.onChanged,
  });

  @override
  State<NameInputField> createState() => _NameInputFieldState();
}

class _NameInputFieldState extends State<NameInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.userName);
  }

  @override
  void didUpdateWidget(NameInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userName != widget.userName) {
      _controller.text = widget.userName;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TranslationExample(
      label: 'Name input',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter your name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              widget.onChanged(value.isEmpty ? 'Alice' : value);
            },
          ),
          const SizedBox(height: 8),
          TranslatedText('greeting', parameters: {'name': widget.userName}),
        ],
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TranslatedText('second_page_title'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TranslatedText(
              'welcome',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            TranslatedText(
              'greeting',
              parameters: {'name': 'User'},
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: TranslatedText('back_to_home'),
            ),
            const SizedBox(height: 24),
            // Show current text direction on this page too
            Text(
              'Text Direction: ${context.textDirection == TextDirection.rtl ? 'RTL' : 'LTR'}',
            ),
            Text('Is RTL: ${context.isRTL}'),
          ],
        ),
      ),
    );
  }
}
