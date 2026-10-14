import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: AppTheme.slate50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo & Page Name Header
              AppBrandHeader(
                pageTitle: 'මුරපදය නැවත සකසන්න (Reset Password)',
                subtitle: 'ගිණුමේ මුරපදය අමතක නම් ඔබගේ සාමාජික හෝ දුරකථන අංකය ඇතුළත් කරන්න',
                showBack: true,
                onBack: () => Navigator.pop(context),
              ),
              const SizedBox(height: 24),

              if (!_submitted) ...[
                // Reset Form Card
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
                        const Text(
                          'සාමාජික අංකය හෝ ජංගම දුරකථනය',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.slate900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _inputCtrl,
                          decoration: const InputDecoration(
                            hintText: 'උදා: PLC-MEM-1042 හෝ 0705001122',
                            prefixIcon: Icon(Icons.badge_outlined, size: 20),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'කරුණාකර සාමාජික අංකය හෝ දුරකථන අංකය ඇතුළත් කරන්න';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.blue50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline_rounded, size: 18, color: AppTheme.primaryBlue),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'ඔබගේ ලියාපදිංචි දුරකථන අංකයට මුරපදය නැවත සැකසීමේ OTP කේතයක් SMS මඟින් ලැබෙනු ඇත.',
                                  style: TextStyle(fontSize: 11, color: AppTheme.slate700, height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.send_rounded, size: 18),
                          label: const Text(
                            'OTP කේතය ලබා ගන්න (Send OTP)',
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
              ] else ...[
                // Success Message Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.emeraldGreen.withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: const BoxDecoration(
                          color: AppTheme.emerald50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_circle_rounded, color: AppTheme.emeraldGreen, size: 42),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'OTP කේතය යවන ලදී!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.slate900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_inputCtrl.text.trim()} වෙත මුරපදය නැවත සකසන සත්‍යාපන කේතය (OTP) යවන ලදී. කරුණාකර ඔබගේ SMS පණිවිඩ පරීක්ෂා කරන්න.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: AppTheme.slate600, height: 1.4),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('නැවත පිවිසුම් පිටුවට (Back to Login)', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Helpline Contact
              Center(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.headset_mic_rounded, size: 16, color: AppTheme.slate600),
                  label: const Text(
                    'කාර්යාල සහාය: 0705001122 (Prime Life Care Support)',
                    style: TextStyle(fontSize: 12, color: AppTheme.slate600, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
