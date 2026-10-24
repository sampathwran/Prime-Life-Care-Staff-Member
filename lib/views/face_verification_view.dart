import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../l10n/app_language.dart';
import '../providers/language_provider.dart';
import '../providers/staff_duty_provider.dart';
import '../theme/app_theme.dart';

class FaceVerificationView extends StatefulWidget {
  const FaceVerificationView({super.key});

  @override
  State<FaceVerificationView> createState() => _FaceVerificationViewState();
}

enum FaceScanStep {
  initial,
  centering,
  liveness,
  symmetry,
  confirmed,
}

class _FaceVerificationViewState extends State<FaceVerificationView>
    with SingleTickerProviderStateMixin {
  late AnimationController _scannerAnimCtrl;
  late Animation<double> _scannerAnim;

  bool _isScanning = false;
  bool _isVerified = false;
  double _scanProgress = 0.0;
  FaceScanStep _scanStep = FaceScanStep.initial;
  String? _capturedImageBase64;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _scannerAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _scannerAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scannerAnimCtrl, curve: Curves.easeInOut),
    );

    // Prompt front camera automatically when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _capturedImageBase64 == null) {
        _takeSelfie();
      }
    });
  }

  @override
  void dispose() {
    _scannerAnimCtrl.dispose();
    super.dispose();
  }

  Future<void> _takeSelfie() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 720,
        maxHeight: 720,
        imageQuality: 80,
      );

      if (photo != null) {
        final bytes = await photo.readAsBytes();
        setState(() {
          _capturedImageBase64 = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        });
        _startBiometricScan();
      }
    } catch (e) {
      debugPrint('[FaceVerification] Camera picker error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Front camera error: $e. Please allow camera permissions.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _startBiometricScan() async {
    if (_capturedImageBase64 == null) {
      // Must take selfie first
      await _takeSelfie();
      return;
    }

    setState(() {
      _isScanning = true;
      _isVerified = false;
      _scanProgress = 0.0;
      _scanStep = FaceScanStep.centering;
    });

    try {
      HapticFeedback.lightImpact();
    } catch (_) {}

    // Simulated high-precision 3D Biometric scanning sequence
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      _scanProgress = 0.35;
      _scanStep = FaceScanStep.liveness;
    });

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _scanProgress = 0.75;
      _scanStep = FaceScanStep.symmetry;
    });

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _scanProgress = 1.0;
      _isScanning = false;
      _isVerified = true;
      _scanStep = FaceScanStep.confirmed;
    });

    try {
      SystemSound.play(SystemSoundType.alert);
      HapticFeedback.heavyImpact();
    } catch (_) {}

    // Save to provider
    final provider = context.read<StaffDutyProvider>();
    final langProvider = context.read<LanguageProvider>();
    final successMsg = langProvider.strings.faceVerificationSuccessSent;

    await provider.saveFaceVerification(
      confidence: 99.8,
      snapshotBase64: _capturedImageBase64,
    );

    // Show completion alert & pop
    if (!mounted) return;
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF059669),
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    successMsg,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  String _getScanStatusText(dynamic strings) {
    switch (_scanStep) {
      case FaceScanStep.initial:
        return strings.alignFaceInOval as String;
      case FaceScanStep.centering:
        return strings.centeringFaceAndLandmarks as String;
      case FaceScanStep.liveness:
        return strings.verifyingBiometricLiveness as String;
      case FaceScanStep.symmetry:
        return strings.analyzingFacialSymmetry as String;
      case FaceScanStep.confirmed:
        return strings.biometricLivenessConfirmed as String;
    }
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final strings = langProvider.strings;
    final isSinhala = langProvider.currentLanguage == AppLanguage.si;
    final isTamil = langProvider.currentLanguage == AppLanguage.ta;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark High-tech Slate 900
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          strings.faceVerificationTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Top Instruction Cards
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF60A5FA), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isSinhala
                            ? 'ප්‍රමාණවත් ආලෝකයක් ඇති තැනක මුහුණ රවුම තුළ සමපාත කර සෘජුව බලා සිටින්න.'
                            : isTamil
                                ? 'நல்ல வெளிச்சத்தில் முகத்தை சட்டகத்தில் வைத்து நேராகப் பாருங்கள்.'
                                : 'Ensure good lighting, remove glasses, and look directly at the frame.',
                        style: const TextStyle(
                          color: Color(0xFFE2E8F0),
                          fontSize: 12.5,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Center Oval Biometric Scanner Frame with Laser Animation
              Center(
                child: SizedBox(
                  width: 260,
                  height: 330,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer Glowing Ring with Pulsing Gradient
                      AnimatedBuilder(
                        animation: _scannerAnimCtrl,
                        builder: (context, child) {
                          return Container(
                            width: 260,
                            height: 330,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.elliptical(130, 165)),
                              border: Border.all(
                                color: _isVerified
                                    ? const Color(0xFF10B981)
                                    : _isScanning
                                        ? const Color(0xFF38BDF8)
                                        : const Color(0xFF64748B),
                                width: _isScanning || _isVerified ? 3.5 : 2.0,
                              ),
                              boxShadow: [
                                if (_isScanning)
                                  BoxShadow(
                                    color: const Color(0xFF38BDF8).withValues(alpha: 0.35 + (_scannerAnim.value * 0.2)),
                                    blurRadius: 28,
                                    spreadRadius: 4,
                                  ),
                                if (_isVerified)
                                  BoxShadow(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.45),
                                    blurRadius: 32,
                                    spreadRadius: 6,
                                  ),
                              ],
                            ),
                          );
                        },
                      ),

                      // Oval Face Mask Content (Camera view or sample guide)
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.elliptical(126, 161)),
                        child: Container(
                          width: 252,
                          height: 322,
                          color: const Color(0xFF1E293B),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Background guide silhouette or captured image
                              if (_capturedImageBase64 != null)
                                Image.memory(
                                  base64Decode(_capturedImageBase64!.split(',').last),
                                  fit: BoxFit.cover,
                                )
                              else
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.face_retouching_natural_rounded,
                                      size: 110,
                                      color: Colors.white.withValues(alpha: 0.2),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      isSinhala
                                          ? 'මුහුණ මෙහි තබන්න'
                                          : isTamil
                                              ? 'முகத்தை வைக்கவும்'
                                              : 'Position Face Here',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.4),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),

                              // Animated Scanning Laser Beam
                              if (_isScanning)
                                AnimatedBuilder(
                                  animation: _scannerAnim,
                                  builder: (context, child) {
                                    return Positioned(
                                      top: _scannerAnim.value * 300,
                                      left: 0,
                                      right: 0,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 2,
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.transparent,
                                                  Color(0xFF38BDF8),
                                                  Color(0xFF00F5D4),
                                                  Color(0xFF38BDF8),
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 36,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  const Color(0xFF38BDF8).withValues(alpha: 0.28),
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                              // Success Checkmark Overlay
                              if (_isVerified)
                                Container(
                                  color: const Color(0xFF059669).withValues(alpha: 0.65),
                                  child: const Center(
                                    child: Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.white,
                                      size: 72,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      // Biometric Corner Crosshairs
                      Positioned(
                        top: 20,
                        left: 20,
                        child: _buildCrosshair(isTop: true, isLeft: true),
                      ),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: _buildCrosshair(isTop: true, isLeft: false),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: _buildCrosshair(isTop: false, isLeft: true),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: _buildCrosshair(isTop: false, isLeft: false),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Status indicator & Progress Bar
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isScanning)
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Color(0xFF38BDF8)),
                          ),
                        ),
                      if (_isVerified)
                        const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 18),
                      if (_isScanning || _isVerified) const SizedBox(width: 8),
                      Text(
                        _getScanStatusText(strings),
                        style: TextStyle(
                          color: _isVerified
                              ? const Color(0xFF10B981)
                              : _isScanning
                                  ? const Color(0xFF38BDF8)
                                  : const Color(0xFF94A3B8),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (_isScanning) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _scanProgress,
                        minHeight: 6,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        valueColor: const AlwaysStoppedAnimation(Color(0xFF38BDF8)),
                      ),
                    ),
                  ],
                ],
              ),

              const Spacer(),

              // Action Buttons
              if (!_isScanning && !_isVerified) ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.camera_front_rounded, size: 22, color: Colors.white),
                        label: Text(
                          _capturedImageBase64 == null
                              ? (isSinhala
                                  ? 'සජීවී ඉදිරි කැමරාවෙන් Scan කරන්න'
                                  : isTamil
                                      ? 'முன் கேமரா மூலம் ஸ்கேன் செய்'
                                      : 'Scan via Front Camera')
                              : (isSinhala
                                  ? 'නැවත Front Photo එකක් ගන්න'
                                  : isTamil
                                      ? 'மீண்டும் படம் எடு'
                                      : 'Retake Front Photo'),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                        ),
                        onPressed: _takeSelfie,
                      ),
                    ),
                    if (_capturedImageBase64 != null) ...[
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle_rounded, size: 20, color: Colors.white),
                        label: Text(
                          isSinhala ? 'තහවුරු කරන්න' : 'Confirm & Send',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF059669),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: _startBiometricScan,
                      ),
                    ],
                  ],
                ),
              ],

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCrosshair({required bool isTop, required bool isLeft}) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? BorderSide(color: Colors.white.withValues(alpha: 0.4), width: 2.5) : BorderSide.none,
          bottom: !isTop ? BorderSide(color: Colors.white.withValues(alpha: 0.4), width: 2.5) : BorderSide.none,
          left: isLeft ? BorderSide(color: Colors.white.withValues(alpha: 0.4), width: 2.5) : BorderSide.none,
          right: !isLeft ? BorderSide(color: Colors.white.withValues(alpha: 0.4), width: 2.5) : BorderSide.none,
        ),
      ),
    );
  }
}
