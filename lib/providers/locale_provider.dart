import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _localeKey = 'app_locale';
const List<String> _supportedLanguages = ['en', 'zh'];

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_localeKey);

    if (savedLanguage != null && _supportedLanguages.contains(savedLanguage)) {
      // Use explicitly saved locale
      state = Locale(savedLanguage);
    } else {
      // Fallback to system locale
      final systemLocale = PlatformDispatcher.instance.locale;
      if (_supportedLanguages.contains(systemLocale.languageCode)) {
        state = Locale(systemLocale.languageCode);
      } else {
        // Fallback to English if system locale not supported
        state = const Locale('en');
      }
    }
  }

  Future<void> setLocale(String languageCode) async {
    if (!_supportedLanguages.contains(languageCode)) {
      throw ArgumentError('Unsupported language: $languageCode');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, languageCode);
    state = Locale(languageCode);
  }

  Future<void> clearLocale() async {
    // Clear saved locale to fallback to system locale
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeKey);
    await _loadLocale();
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});
