import 'package:flutter/material.dart';
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
  bool _agreedToPrivacyPolicy = true; // default true for smooth demo, user can toggle
  bool _isLoading = false;

  @override
  void dispose() {
    _membershipNumberCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (!_agreedToPrivacyPolicy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('කරුණාකර රහස්‍යතා ප්‍රතිපත්තිය (Privacy Policy) ටික් කර එකඟ වන්න.'),
          backgroundColor: AppTheme.rose500,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigationWrapper()),
    );
  }

  void _navigateToRegister() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );

    if (result != null && mounted) {
      setState(() {
        _membershipNumberCtrl.text = result;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('සාමාජික අංකය $result ඇතුළත් විය. කරුණාකර මුරපදය යොදා Login වන්න.'),
          backgroundColor: AppTheme.emeraldGreen,
        ),
      );
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
              // Logo and Page Title Header
              const AppBrandHeader(
                pageTitle: 'සාමාජික පිවිසුම (Member Login)',
                subtitle: 'Prime Life Care Co-operative සමූපකාර සුව සාත්තු ද්වාරය',
              ),
              const SizedBox(height: 20),

              // Login Form Card
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Membership Number Field
                      const Text(
                        'සාමාජික අංකය (Membership Number)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.slate900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _membershipNumberCtrl,
                        decoration: const InputDecoration(
                          hintText: 'උදා: PLC-MEM-1001',
                          prefixIcon: Icon(Icons.badge_outlined, size: 20),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'කරුණාකර සාමාජික අංකය ඇතුළත් කරන්න';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // 2. Password Field
                      const Text(
                        'මුරපදය (Password)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.slate900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'මුරපදය ඇතුළත් කරන්න',
                          prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              size: 20,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'කරුණාකර මුරපදය ඇතුළත් කරන්න';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // 3. Privacy Policy Tick Checkbox
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                                      'මම ',
                                      style: TextStyle(fontSize: 12, color: AppTheme.slate800),
                                    ),
                                    InkWell(
                                      onTap: () => PrivacyPolicySheet.show(context),
                                      child: const Text(
                                        'රහස්‍යතා ප්‍රතිපත්තිය සහ කොන්දේසි (Privacy Policy)',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: AppTheme.primaryBlue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      ' වලට එකඟ වෙමි.',
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

                      // 4. Login Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text(
                                'ඇතුල් වන්න (Login)',
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                              ),
                      ),
                      const SizedBox(height: 14),

                      // 5. Forgot Password Option (Pahalin Forgot Password)
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                            );
                          },
                          child: const Text(
                            'මුරපදය අමතකද? (Forgot Password?)',
                            style: TextStyle(
                              fontSize: 13,
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
              const SizedBox(height: 24),

              // 6. Register / Create Account Section (Etath Pahalin Register Form Option)
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.blue50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: const [
                        Icon(Icons.person_add_alt_1_rounded, color: AppTheme.primaryBlue, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'තවමත් ගිණුමක් නැද්ද?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.slate900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Prime Life Care සමූපකාර සාත්තු සේවාවේ නව සාමාජිකයෙකු ලෙස පහසුවෙන්ම ලියාපදිංචි වන්න.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: AppTheme.slate600),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _navigateToRegister,
                        icon: const Icon(Icons.app_registration_rounded, size: 18),
                        label: const Text(
                          'අලුතින් ලියාපදිංචි වන්න (Register Now)',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryBlue,
                          side: const BorderSide(color: AppTheme.primaryBlue, width: 1.5),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Co-operative Society Footer
              const Center(
                child: Text(
                  'Prime Life Care Co-operative Society Ltd.\nDepartment of Co-operative Development • Helpline: 0705001122',
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
