import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prime_life_care_staff/l10n/app_language.dart';
import 'package:prime_life_care_staff/main.dart';
import 'package:prime_life_care_staff/views/login_page.dart';
import 'package:prime_life_care_staff/views/register_page.dart';
import 'package:prime_life_care_staff/views/forgot_password_page.dart';
import 'package:prime_life_care_staff/views/splash_screen.dart';

void main() {
  testWidgets('App starts at SplashScreen in English by default and transitions to LoginPage', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PrimeLifeCareApp());
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('Prime Life Care'), findsOneWidget);
    expect(find.text('WELCOME'), findsOneWidget);
    expect(find.text('Continue to Login'), findsNothing);
    expect(find.text('පිවිසෙන්න'), findsNothing);

    // Tap splash screen or wait for auto-transition to LoginPage
    await tester.tap(find.byType(SplashScreen));
    await tester.pumpAndSettle();

    // Verify on LoginPage
    expect(find.byType(LoginPage), findsOneWidget);

    // Verify Brand Logo is present
    expect(find.text('PRIME LIFE CARE'), findsOneWidget);

    // Verify "සාමාජික පිවිසුම" banner was REMOVED as requested
    expect(find.text('සාමාජික පිවිසුම (Member Login)'), findsNothing);
    expect(find.text('සාමාජික පිවිසුම'), findsNothing);

    // Verify Single-Language Form Elements in English (default)
    expect(find.text('Membership Number'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Register Now'), findsOneWidget);
    expect(find.text('Select Language'), findsOneWidget);

    // Test Language Switcher: Switch to Sinhala (button is labeled 'Sinhala' while in English mode)
    final sinhalaBtn = find.text('Sinhala');
    await tester.ensureVisible(sinhalaBtn);
    await tester.pumpAndSettle();
    await tester.tap(sinhalaBtn);
    await tester.pumpAndSettle();

    // Verify form elements switched to Sinhala
    expect(find.text('සාමාජික අංකය'), findsOneWidget);
    expect(find.text('මුරපදය'), findsOneWidget);
    expect(find.text('ඇතුල් වන්න'), findsOneWidget);
    expect(find.text('මුරපදය අමතකද?'), findsOneWidget);
    expect(find.text('අලුතින් ලියාපදිංචි වන්න'), findsOneWidget);
    expect(find.text('භාෂාව තෝරන්න'), findsOneWidget);

    // Test Language Switcher: Switch to Tamil (button is labeled 'දෙමළ' while in Sinhala mode)
    final tamilBtn = find.text('දෙමළ');
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

    await tester.pumpWidget(const PrimeLifeCareApp(initialLanguage: AppLanguage.si));
    await tester.tap(find.byType(SplashScreen));
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

  testWidgets('Caregiver can view published duty bookings and accept a duty shift', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(412 * 2.0, 915 * 2.0);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PrimeLifeCareApp(initialLanguage: AppLanguage.si));
    await tester.tap(find.byType(SplashScreen));
    await tester.pumpAndSettle();

    // Login with default prefilled credentials
    final signInBtn = find.text('ඇතුල් වන්න');
    await tester.ensureVisible(signInBtn);
    await tester.pumpAndSettle();
    await tester.tap(signInBtn);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Verify arrived at HomeDutyView with Active Duty section at top
    expect(find.text('වත්මන් සක්‍රීය සාත්තු රාජකාරිය'), findsOneWidget);
    expect(find.text('Mr. Dharmadasa Silva'), findsOneWidget);

    // Expand accordion to view full details
    final expandBtn = find.text('සම්පූර්ණ තොරතුරු බලන්න');
    await tester.ensureVisible(expandBtn);
    await tester.tap(expandBtn);
    await tester.pumpAndSettle();

    // Verify expanded patient details (Address, Map, Guardian, Supervisor)
    expect(find.text('Google සිතියම'), findsOneWidget);
    expect(find.textContaining('Sister N. Jayawardena'), findsOneWidget);

    // Verify Privacy Shield Banner on available bookings
    final privacyShield = find.byIcon(Icons.shield_outlined);
    await tester.ensureVisible(privacyShield);
    await tester.pumpAndSettle();
    expect(privacyShield, findsOneWidget);

    // Verify booking cards exist and test accepting upcoming duty (PLC-BK-1043)
    final acceptDutyBtn = find.text('ඉදිරි රාජකාරිය ලෙස භාරගන්න').first;
    await tester.ensureVisible(acceptDutyBtn);
    await tester.pumpAndSettle();
    await tester.tap(acceptDutyBtn);
    await tester.pumpAndSettle();

    // Confirm acceptance in dialog
    final confirmBtn = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.widgetWithText(ElevatedButton, 'ඉදිරි රාජකාරිය ලෙස භාරගන්න'),
    );
    expect(confirmBtn, findsOneWidget);
    await tester.tap(confirmBtn);
    await tester.pumpAndSettle();

    // Verify upcoming duty card is now rendered
    expect(find.text('ඉදිරියට භාරගත් සාත්තු රාජකාරිය'), findsOneWidget);
  });

  testWidgets('Caregiver can view Profile, edit details, view documents, and see financials', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(412 * 2.0, 915 * 2.0);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PrimeLifeCareApp(initialLanguage: AppLanguage.si));
    await tester.tap(find.byType(SplashScreen));
    await tester.pumpAndSettle();

    // Login
    final signInBtn = find.text('ඇතුල් වන්න');
    await tester.ensureVisible(signInBtn);
    await tester.pumpAndSettle();
    await tester.tap(signInBtn);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Tap Profile Avatar on top-right corner of AppBar (moved from footer)
    final profileAvatar = find.byWidgetPredicate((w) => w is InkWell && w.child is Stack);
    await tester.tap(profileAvatar);
    await tester.pumpAndSettle();

    // Verify profile header elements
    expect(find.text('සාමාජික පැතිකඩ'), findsOneWidget);
    expect(find.text('Sister Chamila Perera'), findsOneWidget);
    expect(find.text('NVQ Level 4 Elderly Care Aide'), findsWidgets);
    expect(find.textContaining('4.9 / 5.0'), findsOneWidget);

    // Verify Language Proficiency section
    expect(find.text('භාෂා ප්‍රවීණතාවය'), findsOneWidget);

    // Verify Documents section
    expect(find.text('පාඨමාලා සහ වෘත්තීය සහතික'), findsOneWidget);

    // Verify Financial Overview
    expect(find.text('මූල්‍ය හා සාත්තු දීමනා සාරාංශය'), findsOneWidget);
    expect(find.text('සම්පූර්ණ කළ වැඩ'), findsOneWidget);

    // Test Edit Profile sheet
    final editBtn = find.text('තොරතුරු සංස්කරණය');
    await tester.ensureVisible(editBtn);
    await tester.pumpAndSettle();
    await tester.tap(editBtn);
    await tester.pumpAndSettle();

    // Verify non-editable warning and locked fields
    expect(find.textContaining('ආරක්ෂිත හේතූන් මත'), findsOneWidget);
    expect(find.text('සම්පූර්ණ නම'), findsOneWidget);
    expect(find.text('199268301452'), findsOneWidget); // NIC locked

    // Close bottom sheet
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    // Test Notifications sheet
    await tester.tap(find.byIcon(Icons.notifications_outlined));
    await tester.pumpAndSettle();
    expect(find.text('දැනුම්දීම්'), findsWidgets);
    await tester.tap(find.text('සියල්ල කියවූ බව සලකුණු කරන්න'));
    await tester.pumpAndSettle();
  });

  testWidgets('MyShiftsView has 4 tabs, hides contacts on completed/canceled, shows cancel reasons and allows member to rate customer', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(412 * 2.0, 915 * 2.0);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PrimeLifeCareApp(initialLanguage: AppLanguage.si));
    await tester.tap(find.byType(SplashScreen));
    await tester.pumpAndSettle();

    // Login
    final signInBtn = find.text('ඇතුල් වන්න');
    await tester.ensureVisible(signInBtn);
    await tester.pumpAndSettle();
    await tester.tap(signInBtn);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Navigate to Shift Rosters Tab (index 3 in bottom nav)
    final shiftsTab = find.byIcon(Icons.calendar_month_outlined);
    await tester.tap(shiftsTab);
    await tester.pumpAndSettle();

    // Verify 4 tabs exist
    expect(find.text('ක්‍රියාකාරී'), findsOneWidget);
    expect(find.text('ඉදිරි'), findsOneWidget);
    expect(find.text('අවලංගු කළ'), findsOneWidget);
    expect(find.text('සම්පූර්ණ කළ'), findsOneWidget);

    // 1. Active Tab: Contact & Call actions exist
    expect(find.text('ඇමතුමක්'), findsOneWidget);
    expect(find.text('සිතියම'), findsOneWidget);

    // 2. Switch to Upcoming Tab: Single upcoming rule banner is present
    await tester.tap(find.text('ඉදිරි'));
    await tester.pumpAndSettle();
    expect(find.text('සාමාජිකයෙකුට එකවර රඳවා ගත හැක්කේ ඉදිරි රාජකාරි 1ක් පමණි.'), findsOneWidget);

    // 3. Switch to Canceled Tab: Phone numbers are hidden and reason is displayed
    await tester.tap(find.text('අවලංගු කළ'));
    await tester.pumpAndSettle();
    expect(find.text('අවලංගු වීමට හේතුව'), findsWidgets);
    expect(find.text('පෞද්ගලිකත්ව ආරක්ෂාව වෙනුවෙන් සේවාලාභියාගේ දුරකථන අංක සඟවා ඇත.'), findsWidgets);

    // 4. Switch to Completed Tab: Privacy note and rating capability
    await tester.tap(find.text('සම්පූර්ණ කළ'));
    await tester.pumpAndSettle();
    expect(find.text('පෞද්ගලිකත්ව ආරක්ෂාව වෙනුවෙන් සේවාලාභියාගේ දුරකථන අංක සඟවා ඇත.'), findsWidgets);

    // Already rated shift shows rating score
    expect(find.textContaining('5.0 / 5.0'), findsOneWidget);

    // Unrated shift has "සේවාලාභියා ශ්‍රේණිගත කරන්න" button
    final rateBtn = find.text('සේවාලාභියා ශ්‍රේණිගත කරන්න');
    expect(rateBtn, findsOneWidget);
    await tester.ensureVisible(rateBtn);
    await tester.pumpAndSettle();
    await tester.tap(rateBtn);
    await tester.pumpAndSettle();

    // Verify rating modal opened
    expect(find.text('සේවාලාභියා හා සේවා පරිසරය ඇගයීම'), findsOneWidget);
    expect(find.text('ශ්‍රේණිගත කිරීම සුරකින්න'), findsOneWidget);

    // Submit rating
    await tester.tap(find.text('ශ්‍රේණිගත කිරීම සුරකින්න'));
    await tester.pumpAndSettle();

    // Verify snackbar feedback
    expect(find.text('ඔබේ ශ්‍රේණිගත කිරීම සාර්ථකව සටහන් විය!'), findsOneWidget);
  });

  testWidgets('Daily Care Plan: Verify renaming, executive progress hero, confirm & lock workflow, and non-editable lock enforcement', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(412 * 2.0, 915 * 2.0);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PrimeLifeCareApp(initialLanguage: AppLanguage.si));
    await tester.tap(find.byType(SplashScreen));
    await tester.pumpAndSettle();

    // Login
    final signInBtn = find.text('ඇතුල් වන්න');
    await tester.ensureVisible(signInBtn);
    await tester.pumpAndSettle();
    await tester.tap(signInBtn);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Navigate to Daily Care Plan Tab (index 2 in bottom nav, labeled 'සාත්තු සැලැස්ම')
    final carePlanTab = find.byIcon(Icons.checklist_rounded);
    await tester.tap(carePlanTab);
    await tester.pumpAndSettle();

    // 1. Verify New Screen Title & Subtitle
    expect(find.text('දෛනික සාත්තු සැලැස්ම'), findsOneWidget);
    expect(find.text('අද දින සාත්තු හා ඖෂධ කාලසටහන'), findsOneWidget);

    // 2. Verify Executive Progress Card and Filter Chips
    expect(find.text('සාත්තු සැලැස්මේ ප්‍රගතිය'), findsOneWidget);
    expect(find.textContaining('Locked'), findsOneWidget);
    expect(find.textContaining('සියල්ල'), findsWidgets);
    expect(find.textContaining('ඉතිරිව ඇති'), findsWidgets);
    expect(find.textContaining('තහවුරු කළ'), findsWidgets);

    // 3. Verify Confirmed & Locked Tasks show locked badges
    expect(find.text('තහවුරු කර අගුළු ලන ලදී'), findsWidgets);

    // 4. Test Confirmation & Locking of a Pending Task
    final confirmTaskBtn = find.text('තහවුරු කර අගුළු ලන්න').first;
    await tester.ensureVisible(confirmTaskBtn);
    await tester.pumpAndSettle();
    await tester.tap(confirmTaskBtn);
    await tester.pumpAndSettle();

    // Verify Confirm Modal Sheet Opened
    expect(find.text('සාත්තු රාජකාරිය තහවුරු කිරීම'), findsOneWidget);
    expect(find.textContaining('මෙම සාත්තු කාර්යය සාර්ථකව අවසන් කළ බව තහවුරු කරන්න'), findsOneWidget);
    expect(find.textContaining('Sister Chamila Perera'), findsWidgets);

    // Enter Bedside Observation Notes
    final notesField = find.byType(TextFormField).last;
    await tester.enterText(notesField, 'Patient fed without coughing or reflux.');
    await tester.pumpAndSettle();

    // Tap "තහවුරු කර අගුළු ලන්න" action button inside the sheet
    final confirmActionBtn = find.widgetWithText(ElevatedButton, 'තහවුරු කර අගුළු ලන්න').last;
    await tester.ensureVisible(confirmActionBtn);
    await tester.tap(confirmActionBtn);
    await tester.pumpAndSettle();

    // Verify confirmation snackbar
    expect(find.text('සාත්තු කාර්යය සාර්ථකව තහවුරු කර අගුළු ලන ලදී!'), findsOneWidget);

    // Verify task is now locked and locked count increased
    expect(find.text('තහවුරු කර අගුළු ලන ලදී'), findsWidgets);

    // 5. Test Lock Enforcement: Tapping a locked task shows non-editable notice
    final lockedTaskCard = find.text('තහවුරු කර අගුළු ලන ලදී').first;
    await tester.ensureVisible(lockedTaskCard);
    await tester.pumpAndSettle();
    await tester.tap(lockedTaskCard);
    await tester.pumpAndSettle();

    expect(find.text('මෙම සාත්තු කාර්යය තහවුරු කර අගුළු ලා ඇත. තවදුරටත් සංශෝධනය කළ නොහැක.'), findsOneWidget);

    // 6. Test Add Care Task Modal Sheet
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    expect(find.text('කාලසටහනට එක් කරන්න'), findsOneWidget);

    // Enter task title
    final titleField = find.widgetWithText(TextFormField, 'Task Title');
    await tester.enterText(titleField, 'Check Blood Sugar');
    await tester.pumpAndSettle();

    // Tap submit button
    final submitBtn = find.widgetWithText(ElevatedButton, 'කාලසටහනට එක් කරන්න');
    await tester.ensureVisible(submitBtn);
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    // Verify modal dismissed and new task appears in schedule
    expect(find.text('Check Blood Sugar'), findsOneWidget);
  });
}
