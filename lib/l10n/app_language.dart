enum AppLanguage {
  si('si', 'Sinhala', 'සිංහල', '🇱🇰'),
  en('en', 'English', 'English', '🇬🇧'),
  ta('ta', 'Tamil', 'தமிழ்', '🇮🇳');

  final String code;
  final String englishName;
  final String nativeName;
  final String flag;

  const AppLanguage(this.code, this.englishName, this.nativeName, this.flag);

  String displayName(AppLanguage current) {
    switch (current) {
      case AppLanguage.si:
        switch (this) {
          case AppLanguage.si:
            return 'සිංහල';
          case AppLanguage.en:
            return 'ඉංග්‍රීසි';
          case AppLanguage.ta:
            return 'දෙමළ';
        }
      case AppLanguage.ta:
        switch (this) {
          case AppLanguage.si:
            return 'சிங்களம்';
          case AppLanguage.en:
            return 'ஆங்கிலம்';
          case AppLanguage.ta:
            return 'தமிழ்';
        }
      case AppLanguage.en:
        return englishName;
    }
  }
}
