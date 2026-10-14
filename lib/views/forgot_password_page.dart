import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_language.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_brand_header.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _inputCtrl = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _inputCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _submitted = true;
      });
    }
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
                pageTitle: s.forgotPasswordPageTitle,
                subtitle: s.forgotPasswordInstructions,
                showBack: true,
                onBack: () => Navigator.pop(context),
              ),
              const SizedBox(height: 18),

              if (!_submitted) ...[
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
                        Text(
                          s.memberIdOrPhone,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.slate900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _inputCtrl,
                          decoration: InputDecoration(
                            hintText: 'PLC-MEM-1001 / 0705001122',
                            prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return s.memberIdOrPhone;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.blue50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.info_outline_rounded, size: 18, color: AppTheme.primaryBlue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  lang.currentLanguage == AppLanguage.si
                                      ? 'ඔබගේ ලියාපදිංචි දුරකථන අංකයට මුරපදය නැවත සැකසීමේ OTP කේතයක් SMS මඟින් ලැබෙනු ඇත.'
                                      : lang.currentLanguage == AppLanguage.ta
                                          ? 'உங்கள் பதிவுசெய்த தொலைபேசி எண்ணிற்கு SMS மூலம் OTP அனுப்பப்படும்.'
                                          : 'A password reset OTP code will be sent to your registered mobile phone via SMS.',
                                  style: const TextStyle(fontSize: 11, color: AppTheme.slate700, height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.send_rounded, size: 18),
                          label: Text(
                            s.sendOtpBtn,
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // Success Message Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.emeraldGreen.withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppTheme.emerald50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_circle_rounded, color: AppTheme.emeraldGreen, size: 40),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        lang.currentLanguage == AppLanguage.si
                            ? 'OTP කේතය යවන ලදී!'
                            : lang.currentLanguage == AppLanguage.ta
                                ? 'OTP அனுப்பப்பட்டது!'
                                : 'OTP Sent Successfully!',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.slate900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${_inputCtrl.text.trim()} ${lang.currentLanguage == AppLanguage.si ? 'වෙත මුරපදය නැවත සකසන OTP කේතය යවන ලදී. කරුණාකර SMS පරීක්ෂා කරන්න.' : lang.currentLanguage == AppLanguage.ta ? 'எண்ணிற்கு கடவுச்சொல் மீட்டமைப்பு OTP அனுப்பப்பட்டுள்ளது.' : 'has been sent a password reset OTP. Please check your SMS messages.'}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11, color: AppTheme.slate600, height: 1.4),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(s.proceedToLogin, style: const TextStyle(fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
