import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_language.dart';
import '../providers/language_provider.dart';
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

  String _membershipType = 'beneficiary';
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
    final lang = Provider.of<LanguageProvider>(context, listen: false);
    final s = lang.strings;

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (!_agreedToPrivacyPolicy) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            lang.currentLanguage == AppLanguage.si
                ? 'කරුණාකර රහස්‍යතා ප්‍රතිපත්තියට එකඟ වන්න'
                : lang.currentLanguage == AppLanguage.ta
                    ? 'தயவுசெய்து தனியுரிமைக் கொள்கையை ஏற்றுக்கொள்ளுங்கள்'
                    : 'Please agree to the Privacy Policy & Rules',
          ),
          backgroundColor: AppTheme.rose500,
        ),
      );
      return;
    }

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
            Text(
              s.registrationSuccessTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.slate900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              s.yourMemberId,
              style: const TextStyle(fontSize: 12, color: AppTheme.slate600),
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
            Text(
              lang.currentLanguage == AppLanguage.si
                  ? 'මෙම සාමාජික අංකය සහ මුරපදය භාවිතා කර ඔබට Login විය හැක.'
                  : lang.currentLanguage == AppLanguage.ta
                      ? 'இந்த உறுப்பினர் எண் மற்றும் கடவுச்சொல்லைப் பயன்படுத்தி உள்நுழையலாம்.'
                      : 'You can now sign in using this membership number and password.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: AppTheme.slate600),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context, generatedMemId);
              },
              child: Text(s.proceedToLogin, style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final s = lang.strings;

    return Scaffold(
      backgroundColor: AppTheme.slate50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBrandHeader(
                pageTitle: s.registerPageTitle,
                subtitle: s.registerSubtitle,
                showBack: true,
                onBack: () => Navigator.pop(context),
              ),
              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.slate200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Full Name
                      Text(
                        s.fullNameLabel,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _fullNameCtrl,
                        decoration: InputDecoration(
                          hintText: s.fullNameHint,
                          prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? s.fullNameLabel : null,
                      ),
                      const SizedBox(height: 12),

                      // NIC & Mobile
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.nicLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: _nicCtrl,
                                  decoration: const InputDecoration(
                                    hintText: '922000158V',
                                    prefixIcon: Icon(Icons.badge_outlined, size: 18),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.phoneLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: _phoneCtrl,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    hintText: '0771234567',
                                    prefixIcon: Icon(Icons.phone_android_rounded, size: 18),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Address
                      Text(
                        s.addressLabel,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _addressCtrl,
                        decoration: InputDecoration(
                          hintText: lang.currentLanguage == AppLanguage.si ? 'නො. 25, කුරුණෑගල පාර' : 'No. 25, Main Road',
                          prefixIcon: const Icon(Icons.home_outlined, size: 20),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? s.addressLabel : null,
                      ),
                      const SizedBox(height: 12),

                      // City / District
                      Text(
                        s.cityDistrictLabel,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _cityCtrl,
                        decoration: InputDecoration(
                          hintText: lang.currentLanguage == AppLanguage.si ? 'හලාවත / පුත්තලම' : 'Chilaw / Puttalam',
                          prefixIcon: const Icon(Icons.location_city_rounded, size: 20),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? s.cityDistrictLabel : null,
                      ),
                      const SizedBox(height: 12),

                      // Membership Category Dropdown
                      Text(
                        s.membershipTypeLabel,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                      ),
                      const SizedBox(height: 5),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: _membershipType,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.card_membership_rounded, size: 20),
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'beneficiary',
                            child: Text(s.catBeneficiary, style: const TextStyle(fontSize: 12)),
                          ),
                          DropdownMenuItem(
                            value: 'general',
                            child: Text(s.catGeneral, style: const TextStyle(fontSize: 12)),
                          ),
                          DropdownMenuItem(
                            value: 'caregiver',
                            child: Text(s.catCaregiver, style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _membershipType = val);
                        },
                      ),
                      const SizedBox(height: 12),

                      // Password
                      Text(
                        s.passwordLabel,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: s.passwordHint,
                          prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 19),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) => v == null || v.length < 4 ? s.passwordError : null,
                      ),
                      const SizedBox(height: 12),

                      // Confirm Password
                      Text(
                        s.confirmPasswordLabel,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _confirmPasswordCtrl,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          hintText: s.passwordHint,
                          prefixIcon: const Icon(Icons.lock_reset_rounded, size: 20),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 19),
                            onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          ),
                        ),
                        validator: (v) {
                          if (v != _passwordCtrl.text) {
                            return lang.currentLanguage == AppLanguage.si
                                ? 'මුරපද දෙක නොගැලපේ'
                                : lang.currentLanguage == AppLanguage.ta
                                    ? 'கடவுச்சொற்கள் பொருந்தவில்லை'
                                    : 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Privacy Policy Agreement
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.slate50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _agreedToPrivacyPolicy ? AppTheme.primaryBlue.withValues(alpha: 0.3) : AppTheme.slate200,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: Checkbox(
                                value: _agreedToPrivacyPolicy,
                                activeColor: AppTheme.primaryBlue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                onChanged: (val) {
                                  setState(() => _agreedToPrivacyPolicy = val ?? false);
                                },
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    s.privacyPolicyAgreementPrefix,
                                    style: const TextStyle(fontSize: 11, color: AppTheme.slate700),
                                  ),
                                  InkWell(
                                    onTap: () => PrivacyPolicySheet.show(context),
                                    child: Text(
                                      s.privacyPolicyTitle,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.primaryBlue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    s.privacyPolicyAgreementSuffix,
                                    style: const TextStyle(fontSize: 11, color: AppTheme.slate700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Submit Registration Button
                      ElevatedButton(
                        onPressed: _submitRegistration,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          s.submitRegisterBtn,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Back to Login Prompt
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    '${s.alreadyHaveAccount} ',
                    style: const TextStyle(fontSize: 12, color: AppTheme.slate600),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      s.loginBtn,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryBlue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
