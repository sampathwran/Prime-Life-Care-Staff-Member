import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_brand_header.dart';
import 'privacy_policy_sheet.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameCtrl = TextEditingController();
  final _nicCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  String _membershipType = 'Elderly / Patient Care Beneficiary (සාත්තු සේවාලාභී)';
  bool _agreedToPrivacyPolicy = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _nicCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _submitRegistration() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (!_agreedToPrivacyPolicy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('කරුණාකර රහස්‍යතා ප්‍රතිපත්තිය සහ කොන්දේසි වලට එකඟ වන්න (Please tick Privacy Policy).'),
          backgroundColor: AppTheme.rose500,
        ),
      );
      return;
    }

    // Generate a sample Membership ID for the user
    final generatedMemId = 'PLC-MEM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: AppTheme.emerald50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppTheme.emeraldGreen, size: 48),
            ),
            const SizedBox(height: 14),
            const Text(
              'ලියාපදිංචිය සාර්ථකයි!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.slate900,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'ඔබගේ නව සමූපකාර සාමාජික අංකය:',
              style: TextStyle(fontSize: 12, color: AppTheme.slate600),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.blueLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
              ),
              child: Text(
                generatedMemId,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primaryBlue,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'මෙම සාමාජික අංකය සහ මුරපදය භාවිතා කර ඔබට Login විය හැක.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: AppTheme.slate600),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx); // Close dialog
                Navigator.pop(context, generatedMemId); // Return to login with generated ID
              },
              child: const Text('දැන්ම පිවිසෙන්න (Go to Login)', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.slate50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo & Page Title Header
              AppBrandHeader(
                pageTitle: 'නව සාමාජික ලියාපදිංචිය (Member Registration)',
                subtitle: 'Prime Life Care Co-operative සමූපකාර සුව සාත්තු සේවාව සඳහා ලියාපදිංචි වන්න',
                showBack: true,
                onBack: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),

              // Registration Form Card
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
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Full Name
                      const Text(
                        'සම්පූර්ණ නම (Full Name)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _fullNameCtrl,
                        decoration: const InputDecoration(
                          hintText: 'උදා: කේ. ඒ. නිමල් පෙරේරා',
                          prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'සම්පූර්ණ නම ඇතුළත් කරන්න' : null,
                      ),
                      const SizedBox(height: 14),

                      // NIC & Mobile Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'NIC අංකය',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _nicCtrl,
                                  decoration: const InputDecoration(
                                    hintText: '922000158V',
                                    prefixIcon: Icon(Icons.badge_outlined, size: 18),
                                  ),
                                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'දුරකථන අංකය',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _phoneCtrl,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    hintText: '0771234567',
                                    prefixIcon: Icon(Icons.phone_android_rounded, size: 18),
                                  ),
                                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Residential Address
                      const Text(
                        'පදිංචි ලිපිනය (Address)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _addressCtrl,
                        decoration: const InputDecoration(
                          hintText: 'නො. 25, කුරුණෑගල පාර',
                          prefixIcon: Icon(Icons.home_outlined, size: 20),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'ලිපිනය ඇතුළත් කරන්න' : null,
                      ),
                      const SizedBox(height: 14),

                      // City / District & Membership Type
                      const Text(
                        'නගරය / දිස්ත්‍රික්කය (City / District)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _cityCtrl,
                        decoration: const InputDecoration(
                          hintText: 'හලාවත / පුත්තලම දිස්ත්‍රික්කය',
                          prefixIcon: Icon(Icons.location_city_rounded, size: 20),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'නගරය ඇතුළත් කරන්න' : null,
                      ),
                      const SizedBox(height: 14),

                      // Membership Type Dropdown
                      const Text(
                        'සාමාජිකත්ව කාණ්ඩය (Membership Category)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: _membershipType,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.card_membership_rounded, size: 20),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Elderly / Patient Care Beneficiary (සාත්තු සේවාලාභී)',
                            child: Text('සාත්තු සේවාලාභී පවුලක් (Patient Family)', style: TextStyle(fontSize: 12)),
                          ),
                          DropdownMenuItem(
                            value: 'General Co-operative Member (ප්‍රජා සාමාජික)',
                            child: Text('සාමාන්‍ය සමූපකාර සාමාජික (General Member)', style: TextStyle(fontSize: 12)),
                          ),
                          DropdownMenuItem(
                            value: 'Caregiver / Home Nurse (සාත්තු සේවක/හෙද)',
                            child: Text('වෘත්තීය සාත්තු සේවක (Caregiver / Nurse)', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _membershipType = val);
                        },
                      ),
                      const SizedBox(height: 14),

                      // Password Fields
                      const Text(
                        'නව මුරපදය (Create Password)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'අවම වශයෙන් අකුරු 4ක්',
                          prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.length < 4) {
                            return 'මුරපදය අවම වශයෙන් අකුරු 4ක් විය යුතුය';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      const Text(
                        'මුරපදය තහවුරු කරන්න (Confirm Password)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _confirmPasswordCtrl,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          hintText: 'මුරපදය නැවත ටයිප් කරන්න',
                          prefixIcon: const Icon(Icons.lock_reset_rounded, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
                            onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          ),
                        ),
                        validator: (v) {
                          if (v != _passwordCtrl.text) {
                            return 'මුරපද දෙක නොගැලපේ (Passwords do not match)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Privacy Policy Agreement Checkbox
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.slate50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _agreedToPrivacyPolicy ? AppTheme.primaryBlue : AppTheme.slate200,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _agreedToPrivacyPolicy,
                              activeColor: AppTheme.primaryBlue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              onChanged: (val) {
                                setState(() => _agreedToPrivacyPolicy = val ?? false);
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    const Text(
                                      'මම සමූපකාර සමිතියේ ',
                                      style: TextStyle(fontSize: 12, color: AppTheme.slate800),
                                    ),
                                    InkWell(
                                      onTap: () => PrivacyPolicySheet.show(context),
                                      child: const Text(
                                        'රහස්‍යතා ප්‍රතිපත්තිය සහ නීති රීති (Privacy Policy & Rules)',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: AppTheme.primaryBlue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      ' කියවා එකඟ වෙමි.',
                                      style: TextStyle(fontSize: 12, color: AppTheme.slate800),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Submit Registration Button
                      ElevatedButton.icon(
                        onPressed: _submitRegistration,
                        icon: const Icon(Icons.how_to_reg_rounded, size: 20),
                        label: const Text(
                          'ලියාපදිංචි වන්න (Complete Registration)',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Back to Login Prompt
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    'දැනටමත් සාමාජික ගිණුමක් තිබේද? ',
                    style: TextStyle(fontSize: 13, color: AppTheme.slate600),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'ඇතුල් වන්න (Login)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryBlue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
