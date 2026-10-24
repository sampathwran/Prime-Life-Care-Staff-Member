import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/caregiver_user_model.dart';
import '../providers/language_provider.dart';
import '../providers/staff_duty_provider.dart';
import '../theme/app_theme.dart';
import 'login_page.dart';
import 'main_navigation_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  Timer? _navTimer;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );

    // Auto transition or restore session after 2 seconds
    _navTimer = Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _checkSessionAndNavigate();
      }
    });
  }

  Future<void> _checkSessionAndNavigate() async {
    if (_isNavigating) return;
    _isNavigating = true;
    _navTimer?.cancel();

    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      final membershipNo = prefs.getString('logged_membership_no');

      if (isLoggedIn && membershipNo != null && membershipNo.isNotEmpty) {
        final col = FirebaseFirestore.instance.collection('caregivers');
        DocumentSnapshot<Map<String, dynamic>>? targetDoc;
        Map<String, dynamic>? data;

        final directDoc = await col.doc(membershipNo).get();
        if (directDoc.exists && directDoc.data() != null) {
          targetDoc = directDoc;
          data = directDoc.data();
        } else {
          final qMem = await col.where('membershipNumber', isEqualTo: membershipNo).limit(1).get();
          if (qMem.docs.isNotEmpty) {
            targetDoc = qMem.docs.first;
            data = targetDoc.data();
          } else {
            final qReg = await col.where('staffRegNo', isEqualTo: membershipNo).limit(1).get();
            if (qReg.docs.isNotEmpty) {
              targetDoc = qReg.docs.first;
              data = targetDoc.data();
            }
          }
        }

        if (data != null && mounted) {
          final caregiverUser = CaregiverUserModel.fromMap(data, targetDoc?.id ?? membershipNo);
          Provider.of<StaffDutyProvider>(context, listen: false).setCurrentStaff(caregiverUser);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainNavigationWrapper()),
          );
          return;
        }
      }
    } catch (e) {
      debugPrint('[SplashScreen] Auto-login check error: $e');
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  void _goToLogin() {
    _checkSessionAndNavigate();
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final strings = lang.strings;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _goToLogin,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // 1. Welcome Message Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppTheme.blue50,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.18)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppTheme.emeraldGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        strings.splashWelcome,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryBlue,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

              // Animated Brand Logo (Official Logo)
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 124,
                  height: 124,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.22),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/app_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryBlue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.local_hospital_rounded, size: 56, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title & Subtitle
              const Text(
                'Prime Life Care',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: AppTheme.slate900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                strings.splashCoopSociety,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryBlue,
                  letterSpacing: 0.3,
                ),
              ),
              const Spacer(),

              // Circular loading indicator
              const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                strings.splashFooter,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: AppTheme.slate400),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
