import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'l10n/app_language.dart';
import 'providers/language_provider.dart';
import 'providers/staff_duty_provider.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('[StaffApp] Firebase init warning: $e');
  }
  await NotificationService().initialize();
  runApp(const PrimeLifeCareApp());
}

class PrimeLifeCareApp extends StatelessWidget {
  final AppLanguage initialLanguage;

  const PrimeLifeCareApp({
    super.key,
    this.initialLanguage = AppLanguage.en,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          final lp = LanguageProvider();
          if (initialLanguage != AppLanguage.en) {
            lp.setLanguage(initialLanguage);
          }
          return lp;
        }),
        ChangeNotifierProvider(create: (_) => StaffDutyProvider()),
      ],
      child: MaterialApp(
        title: 'Prime Life Care',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
