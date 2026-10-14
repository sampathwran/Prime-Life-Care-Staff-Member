import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_language.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_brand_header.dart';
import 'forgot_password_page.dart';
import 'main_navigation_wrapper.dart';
import 'privacy_policy_sheet.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _membershipNumberCtrl = TextEditingController(text: 'PLC-MEM-1001');
  final _passwordCtrl = TextEditingController(text: '1234');

  bool _obscurePassword = true;
  bool _agreedToPrivacyPolicy = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _membershipNumberCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final lang = Provider.of<LanguageProvider>(context, listen: false);

    if (!_formKey.currentState!.validate()) {
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
                    : 'Please agree to the Privacy Policy to proceed',
          ),
          backgroundColor: AppTheme.amber500,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationWrapper()),
      );
    }
  }

  void _navigateToRegister() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );

    if (result != null && mounted) {
      final lang = Provider.of<LanguageProvider>(context, listen: false);
      setState(() {
        _membershipNumberCtrl.text = result;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            lang.currentLanguage == AppLanguage.si
                ? 'සාමාජික අංකය $result ඇතුළත් විය. මුරපදය යොදා Login වන්න.'
                : lang.currentLanguage == AppLanguage.ta
                    ? 'உறுப்பினர் எண் $result நிரப்பப்பட்டது. கடவுச்சொல்லைப் பயன்படுத்தி உள்நுழையவும்.'
                    : 'Member ID $result filled. Please sign in with your password.',
          ),
          backgroundColor: AppTheme.emeraldGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    final s = langProvider.strings;
    final currentLang = langProvider.currentLanguage;

    return Scaffold(
      backgroundColor: AppTheme.slate50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Compact Brand Header without the "සාමාජික පිවිසුම" banner
              const AppBrandHeader(
                showPageTitle: false,
                compact: true,
              ),
              const SizedBox(height: 14),

              // 2. Compact Form Card
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
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Subtitle
                      Text(
                        s.loginSubtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.slate600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Membership Number Field
                      Text(
                        s.membershipNumberLabel,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.slate900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _membershipNumberCtrl,
                        decoration: InputDecoration(
                          hintText: s.membershipNumberHint,
                          prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return s.membershipNumberError;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Password Field
                      Text(
                        s.passwordLabel,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.slate900,
                        ),
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
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              size: 19,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return s.passwordError;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Privacy Policy Agreement Row
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
                      const SizedBox(height: 14),

                      // Sign In Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 1,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text(
                                s.loginBtn,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                              ),
                      ),
                      const SizedBox(height: 8),

                      // Forgot Password Link
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            s.forgotPasswordBtn,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.slate600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // 3. Single-Row Register Section (Reduced Height)
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.blue50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.15)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                child: Row(
                  children: [
                    const Icon(Icons.person_add_alt_1_rounded, color: AppTheme.primaryBlue, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s.noAccountPrompt,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.slate800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _navigateToRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: Text(
                        s.registerNowBtn,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 4. Language Switcher Bar at the Bottom (සිංහල 🇱🇰 | English 🇬🇧 | தமிழ் 🇮🇳)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.slate200),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.language_rounded, size: 14, color: AppTheme.primaryBlue),
                        const SizedBox(width: 6),
                        Text(
                          s.selectLanguage,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.slate700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: AppLanguage.values.map((lang) {
                        final isSelected = lang == currentLang;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: InkWell(
                              onTap: () => langProvider.setLanguage(lang),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppTheme.primaryBlue : AppTheme.slate100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(lang.flag, style: const TextStyle(fontSize: 12)),
                                    const SizedBox(width: 3),
                                    Flexible(
                                      child: Text(
                                        lang.nativeName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                          color: isSelected ? Colors.white : AppTheme.slate700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 5. Co-operative Society Footer
              Center(
                child: Text(
                  s.societyFooter,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10, color: AppTheme.slate400, height: 1.4),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
