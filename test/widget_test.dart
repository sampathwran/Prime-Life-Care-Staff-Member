import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prime_life_care_staff/main.dart';
import 'package:prime_life_care_staff/views/home_duty_view.dart';
import 'package:prime_life_care_staff/views/login_view.dart';

void main() {
  testWidgets('Staff App launches to LoginView and allows demo sign-in', (WidgetTester tester) async {
    // Configure standard mobile portrait viewport (390 x 844)
    tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PrimeLifeCareStaffApp());
    await tester.pumpAndSettle();

    // Check login view elements
    expect(find.byType(LoginView), findsOneWidget);
    expect(find.text('Prime Life Care'), findsOneWidget);
    expect(find.text('Staff Sign In'), findsOneWidget);

    // Tap on the first demo profile (Sister Chamila Perera)
    final demoProfile = find.text('Sister Chamila Perera');
    expect(demoProfile, findsOneWidget);

    await tester.tap(demoProfile);
    await tester.pumpAndSettle();

    // Verify navigation into HomeDutyView
    expect(find.byType(HomeDutyView), findsOneWidget);
    expect(find.text('EMERGENCY SOS DISPATCH'), findsOneWidget);
    expect(find.text('2-Hour Bedsore Prevention'), findsOneWidget);
    expect(find.text('Bedside Vitals Monitor'), findsOneWidget);
  });

  testWidgets('Staff App renders cleanly on 412x915 viewport without overflows', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(412 * 2.0, 915 * 2.0);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PrimeLifeCareStaffApp());
    await tester.pumpAndSettle();

    // Sign in
    await tester.tap(find.text('Sister Chamila Perera'));
    await tester.pumpAndSettle();

    // Switch tabs to Vitals
    await tester.tap(find.text('Vitals'));
    await tester.pumpAndSettle();
    expect(find.text('Bedside Vitals & Health'), findsOneWidget);

    // Switch tabs to Routine
    await tester.tap(find.text('Routine'));
    await tester.pumpAndSettle();
    expect(find.text('Routine & Bedside Care'), findsOneWidget);

    // Switch tabs to Shifts
    await tester.tap(find.text('Shifts'));
    await tester.pumpAndSettle();
    expect(find.text('My Duty Roster'), findsOneWidget);

    // Switch tabs to Profile
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Staff Profile & Credentials'), findsOneWidget);
  });
}
