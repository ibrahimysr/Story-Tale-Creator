import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  static const String _prefKey = 'app_locale_v2';

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_prefKey);

      if (languageCode != null && languageCode.isNotEmpty) {
        final loadedLocale = Locale(languageCode);

        if (_locale != loadedLocale) {
          _locale = loadedLocale;
          notifyListeners();
        } else {
          log('LOCALE PROVIDER: Loaded locale is same as default. No notification needed.');
        }
      } else {
        log('LOCALE PROVIDER: No saved language code found. Using default: "${_locale.languageCode}"');
      }
    } catch (e) {
      log('LOCALE PROVIDER: Error loading locale: $e');
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    if (_locale == newLocale) {
      log('LOCALE PROVIDER: Attempted to set same locale (${newLocale.languageCode}). Skipping.');
      return;
    }

    log('LOCALE PROVIDER: Setting locale from ${_locale.languageCode} to ${newLocale.languageCode}');
    _locale = newLocale;

    notifyListeners();
    log('LOCALE PROVIDER: Notified listeners.');

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, newLocale.languageCode);
      log('LOCALE PROVIDER: Saved locale "${newLocale.languageCode}" to SharedPreferences.');
    } catch (e) {
      log('LOCALE PROVIDER: Error saving locale: $e');
    }
  }
}
