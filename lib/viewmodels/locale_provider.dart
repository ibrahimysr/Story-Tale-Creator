import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;
  static const String _prefKey = 'app_locale_v1'; // Kayıt anahtarı

  Locale? get locale => _locale;

  LocaleProvider() {
    _loadLocale(); // Uygulama başlarken kayıtlı dili yükle
  }

  // Kayıtlı dili SharedPreferences'tan yükle
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_prefKey);
    if (languageCode != null && languageCode.isNotEmpty) {
      _locale = Locale(languageCode);
    } else {
      _locale = null; // Kayıtlı dil yoksa null bırak (sistem dilini kullanır)
      // VEYA varsayılan bir dil ayarlayabilirsin: _locale = const Locale('tr');
    }
    // Dinleyicileri hemen bilgilendirme, MaterialApp'in ilk build'inde zaten kullanılacak
    // notifyListeners(); // Genellikle burada çağırmaya gerek yok
  }

  // Yeni dili ayarla ve kaydet
  Future<void> setLocale(Locale newLocale) async {
    // Desteklenen diller arasında mı kontrolü (isteğe bağlı ama önerilir)
    // if (!AppLocalizations.supportedLocales.contains(newLocale)) return;

    if (_locale == newLocale) return; // Zaten aynıysa işlem yapma

    _locale = newLocale;
    notifyListeners(); // UI'ı güncellemek için dinleyicileri bilgilendir

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, newLocale.languageCode);
  }

  // Kayıtlı dili temizle (isteğe bağlı)
  // Future<void> clearLocale() async {
  //   _locale = null;
  //   notifyListeners();
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove(_prefKey);
  // }
}