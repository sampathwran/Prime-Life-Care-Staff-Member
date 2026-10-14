import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/staff_duty_provider.dart';
import 'theme/app_theme.dart';
import 'views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PrimeLifeCareStaffApp());
}

class PrimeLifeCareStaffApp extends StatelessWidget {
  const PrimeLifeCareStaffApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StaffDutyProvider()),
      ],
      child: MaterialApp(
        title: 'Prime Life Care Staff',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const LoginView(),
      ),
    );
  }
}
