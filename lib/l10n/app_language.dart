enum AppLanguage {
  si('si', 'Sinhala', 'සිංහල', '🇱🇰'),
  en('en', 'English', 'English', '🇬🇧'),
  ta('ta', 'Tamil', 'தமிழ்', '🇮🇳');

  final String code;
  final String englishName;
  final String nativeName;
  final String flag;

  const AppLanguage(this.code, this.englishName, this.nativeName, this.flag);
}
