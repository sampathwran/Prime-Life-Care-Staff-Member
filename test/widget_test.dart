import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prime_life_care_staff/main.dart';
import 'package:prime_life_care_staff/views/login_page.dart';
import 'package:prime_life_care_staff/views/register_page.dart';
import 'package:prime_life_care_staff/views/forgot_password_page.dart';
import 'package:prime_life_care_staff/views/splash_screen.dart';

void main() {
  testWidgets('App starts at SplashScreen and transitions to compact LoginPage', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PrimeLifeCareApp());
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('Prime Life Care'), findsOneWidget);

    // Tap Continue button on splash
    await tester.tap(find.text('පිවිසෙන්න'));
    await tester.pumpAndSettle();

    // Verify on LoginPage
    expect(find.byType(LoginPage), findsOneWidget);

    // Verify Brand Logo is present
    expect(find.text('PRIME LIFE CARE'), findsOneWidget);

    // Verify "සාමාජික පිවිසුම" banner was REMOVED as requested
    expect(find.text('සාමාජික පිවිසුම (Member Login)'), findsNothing);
    expect(find.text('සාමාජික පිවිසුම'), findsNothing);

    // Verify Single-Language Form Elements in Sinhala (default)
    expect(find.text('සාමාජික අංකය'), findsOneWidget);
    expect(find.text('මුරපදය'), findsOneWidget);
    expect(find.text('ඇතුල් වන්න'), findsOneWidget);
    expect(find.text('මුරපදය අමතකද?'), findsOneWidget);
    expect(find.text('අලුතින් ලියාපදිංචි වන්න'), findsOneWidget);
    expect(find.text('භාෂාව තෝරන්න'), findsOneWidget);

    // Test Language Switcher: Switch to English
    final englishBtn = find.text('English');
    await tester.ensureVisible(englishBtn);
    await tester.pumpAndSettle();
    await tester.tap(englishBtn);
    await tester.pumpAndSettle();

    // Verify form elements switched to English
    expect(find.text('Membership Number'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Register Now'), findsOneWidget);
    expect(find.text('Select Language'), findsOneWidget);

    // Test Language Switcher: Switch to Tamil
    final tamilBtn = find.text('தமிழ்');
    await tester.ensureVisible(tamilBtn);
    await tester.pumpAndSettle();
    await tester.tap(tamilBtn);
    await tester.pumpAndSettle();

    // Verify form elements switched to Tamil
    expect(find.text('உறுப்பினர் எண்'), findsOneWidget);
    expect(find.text('கடவுச்சொல்'), findsOneWidget);
    expect(find.text('உள்நுழைக'), findsOneWidget);
    expect(find.text('கடவுச்சொல் மறந்துவிட்டதா?'), findsOneWidget);
    expect(find.text('புதிதாக பதிவுசெய்க'), findsOneWidget);
  });

  testWidgets('LoginPage navigation to ForgotPassword and RegisterPage works cleanly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(412 * 2.0, 915 * 2.0);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PrimeLifeCareApp());
    await tester.tap(find.text('පිවිසෙන්න'));
    await tester.pumpAndSettle();

    // 1. Navigate to ForgotPasswordPage
    final forgotBtn = find.text('මුරපදය අමතකද?');
    await tester.ensureVisible(forgotBtn);
    await tester.pumpAndSettle();
    await tester.tap(forgotBtn);
    await tester.pumpAndSettle();

    expect(find.byType(ForgotPasswordPage), findsOneWidget);
    expect(find.text('මුරපදය නැවත සකසන්න'), findsOneWidget);
    expect(find.text('PRIME LIFE CARE'), findsOneWidget);

    // Go back
    await tester.tap(find.byTooltip('ආපසු'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);

    // 2. Navigate to RegisterPage
    final registerBtn = find.text('අලුතින් ලියාපදිංචි වන්න');
    await tester.ensureVisible(registerBtn);
    await tester.pumpAndSettle();
    await tester.tap(registerBtn);
    await tester.pumpAndSettle();

    expect(find.byType(RegisterPage), findsOneWidget);
    expect(find.text('නව සාමාජික ලියාපදිංචිය'), findsOneWidget);
    expect(find.text('PRIME LIFE CARE'), findsOneWidget);
    expect(find.text('සම්පූර්ණ නම'), findsOneWidget);
    expect(find.text('ලියාපදිංචි වන්න'), findsOneWidget);
  });
}
