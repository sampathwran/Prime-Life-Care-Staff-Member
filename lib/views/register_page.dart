import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_brand_header.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _showAlreadyRegisteredModal({
    required BuildContext context,
    required String title,
    required String message,
    required String memId,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 26),
            SizedBox(width: 8),
            Expanded(
              child: Text('Already Registered', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message, style: const TextStyle(fontSize: 13, height: 1.4)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.blueLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.badge_outlined, size: 16, color: AppTheme.primaryBlue),
                  const SizedBox(width: 8),
                  Text(
                    'Membership ID: $memId',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlue, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, memId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Proceed to Login'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitRegistration() async {
    final lang = Provider.of<LanguageProvider>(context, listen: false);
    final s = lang.strings;

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final colRef = FirebaseFirestore.instance.collection('caregivers');
      final snap = await colRef.get();
      if (!mounted) return;

      final enteredPhone = _phoneCtrl.text.replaceAll(RegExp(r'[\s\-\+]'), '').trim();
      final enteredEmail = _emailCtrl.text.trim().toLowerCase();

      // AUTO-CHECK IF MEMBER ALREADY REGISTERED (PHONE OR EMAIL)
      for (final doc in snap.docs) {
        final data = doc.data();
        final docPhone = (data['phone'] ?? '').toString().replaceAll(RegExp(r'[\s\-\+]'), '').trim();
        final docEmail = (data['email'] ?? '').toString().trim().toLowerCase();
        final memId = (data['membershipNumber'] ?? data['staffRegNo'] ?? doc.id).toString();
        final memberName = (data['name'] ?? data['fullName'] ?? 'Caregiver').toString();

        if (enteredPhone.isNotEmpty && docPhone.isNotEmpty && (docPhone.endsWith(enteredPhone) || enteredPhone.endsWith(docPhone))) {
          setState(() => _isSubmitting = false);
          _showAlreadyRegisteredModal(
            context: context,
            title: 'Already Registered',
            message: 'මෙම දුරකථන අංකය (${_phoneCtrl.text.trim()}) දැනටමත් ලියාපදිංචි සාමාජිකයෙකු සතුය.\n\nසාමාජික අංකය: $memId\nනම: $memberName',
            memId: memId,
          );
          return;
        }

        if (enteredEmail.isNotEmpty && docEmail.isNotEmpty && docEmail == enteredEmail) {
          setState(() => _isSubmitting = false);
          _showAlreadyRegisteredModal(
            context: context,
            title: 'Already Registered',
            message: 'මෙම විද්‍යුත් තැපැල් ලිපිනය ($enteredEmail) දැනටමත් ලියාපදිංචි සාමාජිකයෙකු සතුය.\n\nසාමාජික අංකය: $memId\nනම: $memberName',
            memId: memId,
          );
          return;
        }
      }

      int maxNum = 1000;
      for (final doc in snap.docs) {
        final data = doc.data();
        final idStr = (data['membershipNumber'] ?? data['staffRegNo'] ?? doc.id).toString();
        final match = RegExp(r'PLC-(\d+)').firstMatch(idStr.toUpperCase());
        if (match != null) {
          final n = int.tryParse(match.group(1)!) ?? 0;
          if (n > maxNum) maxNum = n;
        }
      }

      final nextNum = maxNum + 1;
      final generatedMemId = 'PLC-$nextNum';
      final firstName = _firstNameCtrl.text.trim();
      final lastName = _lastNameCtrl.text.trim();
      final fullName = '$firstName $lastName'.trim();

      final caregiverData = {
        'id': generatedMemId,
        'membershipNumber': generatedMemId,
        'staffRegNo': generatedMemId,
        'firstName': firstName,
        'lastName': lastName,
        'name': fullName,
        'fullName': fullName,
        'phone': _phoneCtrl.text.trim(),
        'email': enteredEmail,
        'password': _passwordCtrl.text.trim(),
        'nic': '',
        'address': '',
        'district': 'Colombo',
        'city': 'Colombo',
        'assignedZone': 'Colombo District',
        'tier': 'basic_aide',
        'tierLabel': 'Companion Aide',
        'qualification': 'Basic Care Aide',
        'status': 'available',
        'approvalStatus': 'pending_approval',
        'isApproved': false,
        'isVerifiedMember': false,
        'isPoliceVerified': false,
        'isMedicalCleared': true,
        'isCprCertified': false,
        'documents': [],
        'profileImageStatus': 'missing',
        'nicFrontStatus': 'missing',
        'nicBackStatus': 'missing',
        'policeReportStatus': 'missing',
        'qualificationCertStatus': 'missing',
        'faceVerificationStatus': 'missing',
        'verificationItems': {
          'profile_image': {'status': 'missing'},
          'nic_front': {'status': 'missing'},
          'nic_back': {'status': 'missing'},
          'police_report': {'status': 'missing'},
          'qualification_cert': {'status': 'missing'},
          'face_verification': {'status': 'missing'},
        },
        'rating': 5.0,
        'completedShifts': 0,
        'totalEarnings': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await colRef.doc(generatedMemId).set(caregiverData, SetOptions(merge: true));

      if (!mounted) return;
      setState(() => _isSubmitting = false);

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
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.blueLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
                ),
                child: Text(
                  generatedMemId,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primaryBlue,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Please remember your Membership Number: $generatedMemId.\nYou can sign in using your Membership ID, Mobile Phone, or Email with your password.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11.5, color: AppTheme.slate600),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(s.proceedToLogin, style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
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
                      // 1 & 2. First Name & Last Name
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.firstNameLabel,
                                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: _firstNameCtrl,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    hintText: s.firstNameHint,
                                    prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                  validator: (v) => v == null || v.trim().isEmpty ? s.firstNameLabel : null,
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
                                  s.lastNameLabel,
                                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: _lastNameCtrl,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    hintText: s.lastNameHint,
                                    prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                  validator: (v) => v == null || v.trim().isEmpty ? s.lastNameLabel : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // 3. Mobile Number
                      Text(
                        s.phoneLabel,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: '0771234567',
                          prefixIcon: Icon(Icons.phone_android_rounded, size: 20),
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return s.phoneLabel;
                          final clean = v.replaceAll(RegExp(r'[\s\-\+]'), '');
                          if (clean.length < 9) return 'Please enter a valid phone number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // 4. Email Address
                      Text(
                        s.emailLabel,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppTheme.slate900),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: s.emailHint,
                          prefixIcon: const Icon(Icons.email_outlined, size: 20),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return s.emailError;
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(v.trim())) {
                            return s.emailError;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // 5. Password
                      Text(
                        s.passwordLabel,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppTheme.slate900),
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
                      const SizedBox(height: 14),

                      // 6. Confirm Password
                      Text(
                        s.confirmPasswordLabel,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppTheme.slate900),
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
                            return s.passwordsMismatchError;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Submit Registration Button
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitRegistration,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
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
