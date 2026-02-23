import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
const String _localeKey = 'app_locale';

/// Supported locales with exact matching (language + country code)
const List<Locale> _supportedLocales = [
  Locale('en'),      // English
  Locale('zh', 'CN'), // Simplified Chinese
  Locale('zh', 'TW'), // Traditional Chinese
];
class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _loadLocale();
  }
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_localeKey);
    if (savedLanguage != null) {
      // User explicitly set a locale
      final parts = savedLanguage.split('_');
      if (parts.length == 2) {
        state = Locale(parts[0], parts[1]);
      } else {
        state = Locale(parts[0]);
      }
    } else {
      // null means "follow system" - let Flutter handle locale resolution
      state = null;
    }
  }

  Future<void> setLocale(String languageCode, [String? countryCode]) async {
    final locale = countryCode != null
        ? Locale(languageCode, countryCode)
        : Locale(languageCode);

    // Verify the locale is supported
    final isSupported = _supportedLocales.any((supported) =>
        supported.languageCode == locale.languageCode &&
        (supported.countryCode == locale.countryCode ||
            (supported.countryCode == null && locale.countryCode == null)));

    if (!isSupported) {
      throw ArgumentError('Unsupported locale: $locale');
    }

    final prefs = await SharedPreferences.getInstance();
    final localeString = countryCode != null
        ? '${languageCode}_$countryCode'
        : languageCode;
    await prefs.setString(_localeKey, localeString);
    state = locale;
  }
  Future<void> clearLocale() async {
    // Clear saveo follow system locale
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeKey);
    state = null; // null means "follow system"
  }
}
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});
