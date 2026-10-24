import 'package:flutter/material.dart';
import '../l10n/app_language.dart';
import '../l10n/app_strings.dart';

class LanguageProvider extends ChangeNotifier {
  AppLanguage _currentLanguage = AppLanguage.en; // Default to English

  AppLanguage get currentLanguage => _currentLanguage;

  AppStrings get strings => AppStrings.of(_currentLanguage);

  String get currentLocale => _currentLanguage.code;

  void setLanguage(AppLanguage language) {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      notifyListeners();
    }
  }

  void switchLanguageByCode(String code) {
    final match = AppLanguage.values.firstWhere(
      (l) => l.code == code,
      orElse: () => AppLanguage.en,
    );
    setLanguage(match);
  }

  void setLanguageByCode(String code) => switchLanguageByCode(code);
}
