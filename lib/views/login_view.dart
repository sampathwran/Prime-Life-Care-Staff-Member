import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/caregiver_user_model.dart';
import '../providers/staff_duty_provider.dart';
import '../theme/app_theme.dart';
import 'main_navigation_wrapper.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _phoneCtrl = TextEditingController(text: '0778123456');
  final _pinCtrl = TextEditingController(text: '1234');
  bool _obscurePin = true;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  void _navigateToMain(CaregiverUserModel? staff) {
    if (staff != null) {
      context.read<StaffDutyProvider>().switchStaff(staff);
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigationWrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StaffDutyProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Brand Logo & Header
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppTheme.blueLight,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3), width: 2),
                  ),
                  child: const Icon(
                    Icons.volunteer_activism_rounded,
                    color: AppTheme.primaryBlue,
                    size: 38,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Prime Life Care',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.slate900,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'CAREGIVER & STAFF MOBILE PORTAL',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryBlue,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  'Co-operative Elderly & Bedside Care Society',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.slate500,
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Sign In Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.slate200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Staff Sign In',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.slate900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Enter your registered caregiver mobile & 4-digit PIN',
                      style: TextStyle(fontSize: 12, color: AppTheme.slate500),
                    ),
                    const SizedBox(height: 20),

                    // Phone input
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Registered Mobile Number',
                        prefixIcon: Icon(Icons.phone_android_rounded),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // PIN input
                    TextFormField(
                      controller: _pinCtrl,
                      obscureText: _obscurePin,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Staff PIN',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePin ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscurePin = !_obscurePin),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sign In Button
                    ElevatedButton(
                      onPressed: () => _navigateToMain(null),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Access Bedside Duty Portal',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Demo Instant Sign-In Profiles
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.blue50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.touch_app_rounded, color: AppTheme.primaryBlue, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Instant Demo Sign-In',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tap any caregiver profile below to test immediately:',
                      style: TextStyle(fontSize: 12, color: AppTheme.slate600),
                    ),
                    const SizedBox(height: 12),

                    ...provider.availableStaff.map((staff) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: () => _navigateToMain(staff),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.slate200),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AppTheme.primaryBlue,
                                  child: Text(
                                    staff.avatarInitials,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        staff.fullName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 13,
                                          color: AppTheme.slate900,
                                        ),
                                      ),
                                      Text(
                                        '${staff.qualification} • ${staff.assignedZone.split('-').first.trim()}',
                                        style: const TextStyle(fontSize: 11, color: AppTheme.slate500),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.primaryBlue),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Emergency Dispatch Helpline Footer
              const Center(
                child: Text(
                  'Prime Life Care Co-operative Society • Clinical Hotline: 0705001122\nEmergency Medical Ambulance: 1990',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: AppTheme.slate400, height: 1.4),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
