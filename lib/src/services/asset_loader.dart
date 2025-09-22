import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'translation_cache.dart';

/// Implementation of TranslationLoader that loads translations from Flutter assets.
class AssetTranslationLoader extends DefaultTranslationCache {
  /// Base asset path for translations.
  final String _basePath;

  /// Map of locale to list of available filenames.
  final Map<String, List<String>> _localeFiles = {};

  /// Creates an AssetTranslationLoader with optional base path.
  AssetTranslationLoader({String basePath = 'lang/'}) : _basePath = basePath;

  @override
  Future<void> initialize() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifest = json.decode(manifestContent);

      final translationAssets = manifest.keys
          .where((String key) => key.startsWith(_basePath))
          .toList();

      for (final asset in translationAssets) {
        // Extract locale and filename from path like 'lang/en/messages.json'
        final parts = asset.split('/');
        if (parts.length >= 3) {
          final locale = parts[1];
          final filenameWithExt = parts[2];
          final filename = filenameWithExt.replaceAll('.json', '');

          if (locale.isNotEmpty && filename.isNotEmpty) {
            _localeFiles.putIfAbsent(locale, () => []).add(filename);
          }
        }
      }

      // Preload all translations for all available locales
      final loadTasks = <Future>[];
      for (final locale in _localeFiles.keys) {
        loadTasks.add(loadLocale(locale));
      }

      await Future.wait(loadTasks);
    } catch (e) {
      // If manifest loading fails, fall back to common locales
      // This is handled gracefully
    }
  }

  @override
  Future<void> loadLocale(String locale) async {
    if (isLocaleCached(locale)) return;

    final files = _localeFiles[locale] ?? ['messages']; // fallback to messages if no manifest

    final loadTasks = <Future>[];
    for (final file in files) {
      loadTasks.add(_loadAssetFileAsync(locale, file));
    }

    await Future.wait(loadTasks);
  }

  /// Loads a specific asset file for a locale asynchronously.
  Future<void> _loadAssetFileAsync(String locale, String filename) async {
    final assetPath = '$_basePath$locale/$filename.json';
    try {
      final content = await rootBundle.loadString(assetPath);
      final data = jsonDecode(content) as Map<String, dynamic>;
      final translations = Map<String, String>.from(
        data.map((k, v) => MapEntry(k, v.toString())),
      );

      String namespace = filename;
      if (namespace == locale) namespace = ''; // Default namespace

      storeNamespace(locale, namespace, translations);
    } catch (_) {
      // Asset doesn't exist, skip silently
    }
  }
}