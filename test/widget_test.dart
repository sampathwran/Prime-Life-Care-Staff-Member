import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prime_life_care_staff/main.dart';
import 'package:prime_life_care_staff/views/login_page.dart';
import 'package:prime_life_care_staff/views/register_page.dart';
import 'package:prime_life_care_staff/views/forgot_password_page.dart';
import 'package:prime_life_care_staff/views/splash_screen.dart';

void main() {
  testWidgets('App starts at SplashScreen and transitions to LoginPage', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PrimeLifeCareApp());
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('Prime Life Care'), findsOneWidget);

    // Tap Continue button on splash
    await tester.tap(find.text('පිවිසෙන්න (Continue to Login)'));
    await tester.pumpAndSettle();

    // Verify on LoginPage
    expect(find.byType(LoginPage), findsOneWidget);

    // Verify Logo and Page Name
    expect(find.text('සාමාජික පිවිසුම (Member Login)'), findsOneWidget);
    expect(find.text('PRIME LIFE CARE'), findsOneWidget);

    // Verify Required Form Elements
    expect(find.text('සාමාජික අංකය (Membership Number)'), findsOneWidget);
    expect(find.text('මුරපදය (Password)'), findsOneWidget);
    expect(find.text('ඇතුල් වන්න (Login)'), findsOneWidget);
    expect(find.text('මුරපදය අමතකද? (Forgot Password?)'), findsOneWidget);
    expect(find.text('අලුතින් ලියාපදිංචි වන්න (Register Now)'), findsOneWidget);
  });

  testWidgets('LoginPage navigation to ForgotPassword and RegisterPage works cleanly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(412 * 2.0, 915 * 2.0);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PrimeLifeCareApp());
    await tester.tap(find.text('පිවිසෙන්න (Continue to Login)'));
    await tester.pumpAndSettle();

    // 1. Navigate to ForgotPasswordPage
    final forgotBtn = find.text('මුරපදය අමතකද? (Forgot Password?)');
    await tester.ensureVisible(forgotBtn);
    await tester.pumpAndSettle();
    await tester.tap(forgotBtn);
    await tester.pumpAndSettle();

    expect(find.byType(ForgotPasswordPage), findsOneWidget);
    expect(find.text('මුරපදය නැවත සකසන්න (Reset Password)'), findsOneWidget);
    expect(find.text('PRIME LIFE CARE'), findsOneWidget);

    // Go back
    await tester.tap(find.byTooltip('ආපසු (Back)'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);

    // 2. Navigate to RegisterPage
    final registerBtn = find.text('අලුතින් ලියාපදිංචි වන්න (Register Now)');
    await tester.ensureVisible(registerBtn);
    await tester.pumpAndSettle();
    await tester.tap(registerBtn);
    await tester.pumpAndSettle();

    expect(find.byType(RegisterPage), findsOneWidget);
    expect(find.text('නව සාමාජික ලියාපදිංචිය (Member Registration)'), findsOneWidget);
    expect(find.text('PRIME LIFE CARE'), findsOneWidget);
    expect(find.text('සම්පූර්ණ නම (Full Name)'), findsOneWidget);
    expect(find.text('ලියාපදිංචි වන්න (Complete Registration)'), findsOneWidget);
  });
}
