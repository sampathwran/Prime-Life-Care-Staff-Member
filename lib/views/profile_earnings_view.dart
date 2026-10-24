import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/caregiver_user_model.dart';
import '../models/shift_roster_model.dart';
import '../providers/staff_duty_provider.dart';
import '../providers/language_provider.dart';
import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';
import 'login_page.dart';
import 'face_verification_view.dart';

class ProfileEarningsView extends StatefulWidget {
  const ProfileEarningsView({super.key});

  @override
  State<ProfileEarningsView> createState() => _ProfileEarningsViewState();
}

class _ProfileEarningsViewState extends State<ProfileEarningsView> {
  int _selectedShiftTab = 0;
  bool _isVerificationPipelineExpanded = false;
  static final Map<String, Uint8List> _b64Cache = {};

  Uint8List? _getCachedBytes(String? dataUri) {
    if (dataUri == null || dataUri.isEmpty) return null;
    return _b64Cache.putIfAbsent(dataUri, () {
      final clean = dataUri.contains(',') ? dataUri.split(',').last : dataUri;
      return base64Decode(clean);
    });
  }

  // 1. PERSONAL DETAILS & EDIT PROFILE SHEET (With NIC Front & Back Upload)
  void _showEditProfileSheet(
    BuildContext context,
    CaregiverUserModel staff,
    StaffDutyProvider provider,
    AppStrings strings,
  ) {
    final bool isLocked = staff.isPersonalDetailsApproved || staff.isVerifiedMember;
    final nameCtrl = TextEditingController(text: staff.fullName);
    final nicCtrl = TextEditingController(text: staff.nic);
    final phoneCtrl = TextEditingController(text: staff.phone);
    final addressCtrl = TextEditingController(text: staff.address);
    final zoneCtrl = TextEditingController(text: staff.assignedZone);
    final bioCtrl = TextEditingController(text: staff.bio);

    String? tempNicFront = staff.nicFrontUrl;
    String? tempNicBack = staff.nicBackUrl;
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.92),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 6),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.slate300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                strings.editProfileAndVerifyDocs,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.slate900),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () => Navigator.pop(sheetCtx),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppTheme.slate200),

                      Flexible(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Security Lock Notice if Personal Details Approved
                              if (isLocked) ...[
                                Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0FDF4),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFBBF7D0)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.verified_user_rounded, color: Color(0xFF16A34A), size: 20),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              strings.personalDetailsLockedNotice,
                                              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF166534)),
                                            ),
                                            const SizedBox(height: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFDCFCE7),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                strings.onlyPhoneEditableBadge,
                                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              // Personal Details Section
                              Text(
                                strings.personalDetailsHeader,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.slate900),
                              ),
                              const SizedBox(height: 12),

                              // Full Name
                              Text(strings.fullNameFieldLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.slate700)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: nameCtrl,
                                enabled: !isLocked,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person_outline, size: 18),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  filled: isLocked,
                                  fillColor: isLocked ? const Color(0xFFF8FAFC) : null,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // NIC Number
                              Text(strings.nicNumberFieldLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.slate700)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: nicCtrl,
                                enabled: !isLocked,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.badge_outlined, size: 18),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  filled: isLocked,
                                  fillColor: isLocked ? const Color(0xFFF8FAFC) : null,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Phone (Always editable)
                              Text(strings.phoneFieldLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.slate700)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: phoneCtrl,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.phone_rounded, size: 18),
                                  suffixIcon: isLocked ? const Icon(Icons.edit_rounded, size: 16, color: AppTheme.primaryBlue) : null,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Address
                              Text(strings.permanentAddressFieldLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.slate700)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: addressCtrl,
                                enabled: !isLocked,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.home_outlined, size: 18),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  filled: isLocked,
                                  fillColor: isLocked ? const Color(0xFFF8FAFC) : null,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // District / City
                              Text(strings.districtZoneFieldLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.slate700)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: zoneCtrl,
                                enabled: !isLocked,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.location_city_outlined, size: 18),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  filled: isLocked,
                                  fillColor: isLocked ? const Color(0xFFF8FAFC) : null,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Bio
                              Text(strings.bioFieldLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.slate700)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: bioCtrl,
                                enabled: !isLocked,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  hintText: strings.bioEmptyHint,
                                  hintStyle: const TextStyle(fontSize: 12, color: AppTheme.slate400),
                                  contentPadding: const EdgeInsets.all(12),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  filled: isLocked,
                                  fillColor: isLocked ? const Color(0xFFF8FAFC) : null,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // NIC Card Images Upload Section
                              const Divider(),
                              const SizedBox(height: 10),
                              Text(
                                strings.nicCopiesHeader,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.slate900),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                strings.nicCopiesDesc,
                                style: const TextStyle(fontSize: 11.5, color: AppTheme.slate600),
                              ),
                              const SizedBox(height: 14),

                              // NIC Front Card
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.badge_outlined, size: 18, color: AppTheme.primaryBlue),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            strings.nicFrontTitle,
                                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          staff.nicFrontStatus == 'approved' ? strings.statusApproved : (tempNicFront != null ? strings.readyStatus : strings.statusMissing),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: staff.nicFrontStatus == 'approved' ? Colors.green : (tempNicFront != null ? Colors.blue : Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (tempNicFront != null) ...[
                                      const SizedBox(height: 8),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: tempNicFront!.startsWith('data:image')
                                            ? Image.memory(
                                                base64Decode(tempNicFront!.split(',').last),
                                                height: 90,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'assets/images/profile_sample_image.png',
                                                height: 90,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => Container(
                                                  height: 40,
                                                  color: Colors.blue.shade50,
                                                  alignment: Alignment.center,
                                                  child: Text(tempNicFront!, style: const TextStyle(fontSize: 11)),
                                                ),
                                              ),
                                      ),
                                    ],
                                    if (isLocked) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF0FDF4),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: const Color(0xFFBBF7D0)),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.verified_rounded, size: 14, color: Color(0xFF16A34A)),
                                            const SizedBox(width: 6),
                                            Text(
                                              strings.lockedApprovedNotice(strings.nicFrontTitle),
                                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ] else ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              icon: const Icon(Icons.camera_alt_rounded, size: 16),
                                              label: Text(strings.cameraBtn, style: const TextStyle(fontSize: 11.5)),
                                              onPressed: () async {
                                                try {
                                                  final img = await picker.pickImage(source: ImageSource.camera, maxWidth: 700, maxHeight: 700, imageQuality: 50);
                                                  if (img != null) {
                                                    final bytes = await img.readAsBytes();
                                                    setSheetState(() {
                                                      tempNicFront = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                                                    });
                                                  }
                                                } catch (e) {
                                                  debugPrint('Camera fallback: $e');
                                                  setSheetState(() {
                                                    tempNicFront = 'assets/images/profile_sample_image.png';
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              icon: const Icon(Icons.photo_library_rounded, size: 16),
                                              label: Text(strings.galleryBtn, style: const TextStyle(fontSize: 11.5)),
                                              onPressed: () async {
                                                try {
                                                  final img = await picker.pickImage(source: ImageSource.gallery, maxWidth: 700, maxHeight: 700, imageQuality: 50);
                                                  if (img != null) {
                                                    final bytes = await img.readAsBytes();
                                                    setSheetState(() {
                                                      tempNicFront = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                                                    });
                                                  }
                                                } catch (e) {
                                                  debugPrint('Gallery fallback: $e');
                                                  setSheetState(() {
                                                    tempNicFront = 'assets/images/profile_sample_image.png';
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        width: double.infinity,
                                        child: TextButton.icon(
                                          icon: const Icon(Icons.attach_file_rounded, size: 15),
                                          label: Text(strings.useSampleNicFrontBtn, style: const TextStyle(fontSize: 11)),
                                          onPressed: () {
                                            setSheetState(() {
                                              tempNicFront = 'assets/images/profile_sample_image.png';
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              const SizedBox(height: 12),

                              // NIC Back Card
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.badge_rounded, size: 18, color: AppTheme.primaryBlue),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            strings.nicBackTitle,
                                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          staff.nicBackStatus == 'approved' ? strings.statusApproved : (tempNicBack != null ? strings.readyStatus : strings.statusMissing),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: staff.nicBackStatus == 'approved' ? Colors.green : (tempNicBack != null ? Colors.blue : Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (tempNicBack != null) ...[
                                      const SizedBox(height: 8),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: tempNicBack!.startsWith('data:image')
                                            ? Image.memory(
                                                base64Decode(tempNicBack!.split(',').last),
                                                height: 90,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'assets/images/profile_sample_image.png',
                                                height: 90,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => Container(
                                                  height: 40,
                                                  color: Colors.blue.shade50,
                                                  alignment: Alignment.center,
                                                  child: Text(tempNicBack!, style: const TextStyle(fontSize: 11)),
                                                ),
                                              ),
                                      ),
                                    ],
                                    if (isLocked) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF0FDF4),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: const Color(0xFFBBF7D0)),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.verified_rounded, size: 14, color: Color(0xFF16A34A)),
                                            const SizedBox(width: 6),
                                            Text(
                                              strings.lockedApprovedNotice(strings.nicBackTitle),
                                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ] else ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              icon: const Icon(Icons.camera_alt_rounded, size: 16),
                                              label: Text(strings.cameraBtn, style: const TextStyle(fontSize: 11.5)),
                                              onPressed: () async {
                                                try {
                                                  final img = await picker.pickImage(source: ImageSource.camera, maxWidth: 700, maxHeight: 700, imageQuality: 50);
                                                  if (img != null) {
                                                    final bytes = await img.readAsBytes();
                                                    setSheetState(() {
                                                      tempNicBack = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                                                    });
                                                  }
                                                } catch (e) {
                                                  debugPrint('Camera fallback: $e');
                                                  setSheetState(() {
                                                    tempNicBack = 'assets/images/profile_sample_image.png';
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              icon: const Icon(Icons.photo_library_rounded, size: 16),
                                              label: Text(strings.galleryBtn, style: const TextStyle(fontSize: 11.5)),
                                              onPressed: () async {
                                                try {
                                                  final img = await picker.pickImage(source: ImageSource.gallery, maxWidth: 700, maxHeight: 700, imageQuality: 50);
                                                  if (img != null) {
                                                    final bytes = await img.readAsBytes();
                                                    setSheetState(() {
                                                      tempNicBack = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                                                    });
                                                  }
                                                } catch (e) {
                                                  debugPrint('Gallery fallback: $e');
                                                  setSheetState(() {
                                                    tempNicBack = 'assets/images/profile_sample_image.png';
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        width: double.infinity,
                                        child: TextButton.icon(
                                          icon: const Icon(Icons.attach_file_rounded, size: 15),
                                          label: Text(strings.useSampleNicBackBtn, style: const TextStyle(fontSize: 11)),
                                          onPressed: () {
                                            setSheetState(() {
                                              tempNicBack = 'assets/images/profile_sample_image.png';
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),

                      // Bottom Save Action
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(top: BorderSide(color: AppTheme.slate200)),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (isLocked) {
                                provider.updateCaregiverProfile(
                                  fullName: staff.fullName,
                                  nic: staff.nic,
                                  phone: phoneCtrl.text.trim(),
                                  address: staff.address,
                                  assignedZone: staff.assignedZone,
                                  bio: staff.bio,
                                );
                              } else {
                                provider.updateCaregiverProfile(
                                  fullName: nameCtrl.text.trim(),
                                  nic: nicCtrl.text.trim().toUpperCase(),
                                  phone: phoneCtrl.text.trim(),
                                  address: addressCtrl.text.trim(),
                                  assignedZone: zoneCtrl.text.trim(),
                                  bio: bioCtrl.text.trim(),
                                );

                                if (tempNicFront != null || tempNicBack != null) {
                                  provider.uploadNICDocuments(
                                    frontUrl: tempNicFront,
                                    backUrl: tempNicBack,
                                  );
                                }
                              }

                              Navigator.pop(sheetCtx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(strings.profileAndDocsSavedSuccess),
                                  backgroundColor: const Color(0xFF059669),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              isLocked ? strings.saveChangesBtn : strings.saveAndSubmitDocsBtn,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 1.1 PROFILE PHOTO PICKER & GUIDELINES SHEET
  void _showProfilePhotoPickerSheet(
    BuildContext context,
    CaregiverUserModel staff,
    StaffDutyProvider provider,
    AppStrings strings,
  ) {
    if (staff.isProfileImageApproved) {
      _showLockedApprovedDialog(context, strings.profilePhotoTitle, strings);
      return;
    }

    final picker = ImagePicker();
    String? tempImageBase64 = staff.profileImageUrl;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 6),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.slate300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              strings.profilePhotoTitle,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.slate900),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () => Navigator.pop(sheetCtx),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppTheme.slate200),

                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Rejection or Pending notice if applicable
                              if (staff.profileImageStatus == 'rejected') ...[
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(bottom: 14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF2F2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFFECACA)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626), size: 22),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Photo Rejected by Admin',
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF991B1B)),
                                            ),
                                            Text(
                                              staff.profileImageRejectionReason != null && staff.profileImageRejectionReason!.isNotEmpty
                                                  ? staff.profileImageRejectionReason!
                                                  : 'Please capture or upload a clear, professional front-facing portrait.',
                                              style: const TextStyle(fontSize: 11, color: Color(0xFFB91C1C)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else if (staff.profileImageStatus == 'pending') ...[
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(bottom: 14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFFDE68A)),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.hourglass_top_rounded, color: Color(0xFFD97706), size: 20),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          'Your photo is currently pending Admin verification. You can upload a replacement photo below if needed.',
                                          style: TextStyle(fontSize: 11, color: Color(0xFF92400E), fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              // Guide card explaining sample photo
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFDBEAFE)),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/images/profile_sample_image.png',
                                        width: 58,
                                        height: 58,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.account_box_rounded, size: 48, color: AppTheme.primaryBlue),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            strings.sampleGuideTitle,
                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF1E40AF)),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            strings.sampleGuideDesc,
                                            style: const TextStyle(fontSize: 11, color: Color(0xFF1E3A8A), height: 1.35),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Current or Selected Image Preview
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppTheme.primaryBlue, width: 3),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 4)),
                                  ],
                                ),
                                child: ClipOval(
                                  child: tempImageBase64 != null && tempImageBase64!.isNotEmpty
                                      ? (tempImageBase64!.startsWith('data:image')
                                          ? Image.memory(
                                              _getCachedBytes(tempImageBase64!)!,
                                              fit: BoxFit.cover,
                                              gaplessPlayback: true,
                                            )
                                          : Image.asset(
                                              'assets/images/profile_sample_image.png',
                                              fit: BoxFit.cover,
                                            ))
                                      : Image.asset(
                                          'assets/images/profile_sample_image.png',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              Text(
                                tempImageBase64 != null
                                    ? strings.photoReadyToSubmit
                                    : strings.pleaseAddPhotoPrompt,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.slate700),
                              ),
                              const SizedBox(height: 20),

                              // Buttons: Camera, Gallery
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      icon: const Icon(Icons.camera_alt_rounded, size: 18),
                                      label: Text(strings.cameraBtn, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      onPressed: () async {
                                        try {
                                          final photo = await picker.pickImage(source: ImageSource.camera, maxWidth: 500, maxHeight: 500, imageQuality: 55);
                                          if (photo != null) {
                                            final bytes = await photo.readAsBytes();
                                            setSheetState(() {
                                              tempImageBase64 = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                                            });
                                          }
                                        } catch (e) {
                                          debugPrint('Camera picker error: $e');
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      icon: const Icon(Icons.photo_library_rounded, size: 18),
                                      label: Text(strings.galleryBtn, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      onPressed: () async {
                                        try {
                                          final photo = await picker.pickImage(source: ImageSource.gallery, maxWidth: 500, maxHeight: 500, imageQuality: 55);
                                          if (photo != null) {
                                            final bytes = await photo.readAsBytes();
                                            setSheetState(() {
                                              tempImageBase64 = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                                            });
                                          }
                                        } catch (e) {
                                          debugPrint('Gallery picker error: $e');
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Use Sample Avatar Preset Button
                              SizedBox(
                                width: double.infinity,
                                child: TextButton.icon(
                                  icon: const Icon(Icons.account_circle_outlined, size: 18),
                                  label: Text(strings.useStandardSamplePhoto, style: const TextStyle(fontSize: 11.5)),
                                  onPressed: () {
                                    setSheetState(() {
                                      tempImageBase64 = 'assets/images/profile_sample_image.png';
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Submit Action
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(top: BorderSide(color: AppTheme.slate200)),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: tempImageBase64 == null
                                ? null
                                : () {
                                    provider.uploadProfileImage(tempImageBase64!);
                                    Navigator.pop(sheetCtx);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(strings.profilePhotoSentSuccess),
                                        backgroundColor: const Color(0xFF059669),
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(strings.submitForAdminReview, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 1.3 POLICE REPORT UPLOAD SHEET
  void _showPoliceReportUploadSheet(
    BuildContext context,
    CaregiverUserModel staff,
    StaffDutyProvider provider,
    AppStrings strings,
  ) {
    if (staff.isPoliceReportApproved) {
      _showLockedApprovedDialog(context, strings.policeReportTitle, strings);
      return;
    }

    final policeStationCtrl = TextEditingController(text: 'Colombo Central Division');
    String fileName = 'Police_Clearance_${staff.staffRegNo}.jpg';
    String? policeReportBase64 = staff.policeReportUrl;
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(strings.uploadPoliceClearanceTitle, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(sheetCtx)),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    Text(strings.policeStationLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: policeStationCtrl,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.local_police_rounded, size: 18),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Camera & Gallery Buttons
                    const Text('Capture or Select Clearance Document Photo:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.slate800)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.camera_alt_rounded, size: 16),
                            label: Text(strings.cameraBtn, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              try {
                                final img = await picker.pickImage(source: ImageSource.camera, maxWidth: 700, maxHeight: 700, imageQuality: 50);
                                if (img != null) {
                                  final bytes = await img.readAsBytes();
                                  setSheetState(() {
                                    policeReportBase64 = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                                    fileName = img.name;
                                  });
                                }
                              } catch (e) {
                                debugPrint('Police report camera error: $e');
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.photo_library_rounded, size: 16),
                            label: Text(strings.galleryBtn, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              try {
                                final img = await picker.pickImage(source: ImageSource.gallery, maxWidth: 700, maxHeight: 700, imageQuality: 50);
                                if (img != null) {
                                  final bytes = await img.readAsBytes();
                                  setSheetState(() {
                                    policeReportBase64 = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                                    fileName = img.name;
                                  });
                                }
                              } catch (e) {
                                debugPrint('Police report gallery error: $e');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Preview Container
                    if (policeReportBase64 != null && policeReportBase64!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            if (policeReportBase64!.startsWith('data:image'))
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.memory(
                                  base64Decode(policeReportBase64!.split(',').last),
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(fileName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  const Text('Clearance image ready to submit', style: TextStyle(fontSize: 11, color: Colors.green)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                        child: Row(
                          children: [
                            const Icon(Icons.document_scanner_rounded, color: Colors.grey, size: 28),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text('No clearance photo taken yet. Tap Camera or Gallery above.', style: TextStyle(fontSize: 11.5, color: Colors.grey)),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          provider.uploadPoliceReportDocument(
                            fileName: fileName,
                            fileUrl: policeReportBase64,
                          );
                          Navigator.pop(sheetCtx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(strings.policeReportSentSuccess), backgroundColor: const Color(0xFF059669)),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: Text(strings.submitPoliceReportBtn, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 1.4 LOCKED & VERIFIED ALERT DIALOG
  void _showLockedApprovedDialog(BuildContext context, String itemName, AppStrings strings) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Color(0xFFD1FAE5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_rounded, color: Color(0xFF059669), size: 40),
            ),
            const SizedBox(height: 14),
            Text(
              strings.lockedApprovedNotice(itemName),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.slate900),
            ),
            const SizedBox(height: 8),
            Text(
              strings.lockedApprovedDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppTheme.slate600, height: 1.4),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(strings.okBtn, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. LANGUAGE PROFICIENCY SHEET
  void _showLanguageProficiencySheet(
    BuildContext context,
    CaregiverUserModel staff,
    StaffDutyProvider provider,
    AppStrings strings,
  ) {
    final editedLanguages = staff.languages.map((l) => l.copyWith()).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 6),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(color: AppTheme.slate300, borderRadius: BorderRadius.circular(2)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                strings.languageProficiencyTitle,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.slate900),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () => Navigator.pop(sheetCtx),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppTheme.slate200),

                      Flexible(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                strings.languageSkillsDesc,
                                style: const TextStyle(fontSize: 12, color: AppTheme.slate600, height: 1.35),
                              ),
                              const SizedBox(height: 16),

                              ...editedLanguages.map((lang) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 14),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: AppTheme.slate50,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppTheme.slate200),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              lang.localizedName(strings.language),
                                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppTheme.slate900),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(color: AppTheme.blueLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              '${lang.speakingPercent}% · ${lang.writingPercent}% · ${lang.understandingPercent}%',
                                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.primaryBlue),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),

                                      _buildPercentSlider(
                                        label: strings.speaking,
                                        value: lang.speakingPercent,
                                        onChanged: (v) {
                                          setSheetState(() => lang.speakingPercent = v.toInt());
                                        },
                                      ),
                                      _buildPercentSlider(
                                        label: strings.writing,
                                        value: lang.writingPercent,
                                        onChanged: (v) {
                                          setSheetState(() => lang.writingPercent = v.toInt());
                                        },
                                      ),
                                      _buildPercentSlider(
                                        label: strings.understanding,
                                        value: lang.understandingPercent,
                                        onChanged: (v) {
                                          setSheetState(() => lang.understandingPercent = v.toInt());
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppTheme.slate200))),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              provider.updateCaregiverProfile(languages: editedLanguages);
                              Navigator.pop(sheetCtx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(strings.languagesSavedSuccess),
                                  backgroundColor: const Color(0xFF059669),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(strings.saveChanges, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 3. QUALIFICATIONS & DOCUMENTS SHEET
  void _showDocumentsSheet(
    BuildContext context,
    CaregiverUserModel staff,
    StaffDutyProvider provider,
    AppStrings strings,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 6),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: AppTheme.slate300, borderRadius: BorderRadius.circular(2)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            strings.documentsTitle,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.slate900),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(sheetCtx),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppTheme.slate200),

                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.blueLight,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.verified_user_rounded, color: AppTheme.primaryBlue, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    strings.documentsBannerDesc,
                                    style: const TextStyle(fontSize: 11, color: AppTheme.primaryBlue, height: 1.35, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          ...staff.documents.map((doc) {
                            final isVerified = doc.isVerified;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isVerified ? const Color(0xFFF0FDF4) : const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: isVerified ? const Color(0xFFBBF7D0) : const Color(0xFFFDE68A)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        isVerified ? Icons.verified_rounded : Icons.pending_actions_rounded,
                                        color: isVerified ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                                        size: 22,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              doc.title,
                                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.slate900),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${doc.institute} (${doc.issueYear})',
                                              style: const TextStyle(fontSize: 11, color: AppTheme.slate600),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '📎 ${doc.fileName}',
                                              style: const TextStyle(fontSize: 10, color: AppTheme.slate500),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: isVerified ? const Color(0xFFDCFCE7) : const Color(0xFFFEF9C3),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          isVerified ? '✓ ${strings.verifiedStatusBadge}' : '⏳ ${strings.reviewingStatusBadge}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            color: isVerified ? const Color(0xFF15803D) : const Color(0xFFB45309),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!isVerified) ...[
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton.icon(
                                        onPressed: () {
                                          provider.adminApproveQualification(
                                            documentId: doc.id,
                                            newQualification: 'NVQ Level 5 Home Nursing Specialist',
                                          );
                                          Navigator.pop(sheetCtx);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(strings.demoApprovedSuccess),
                                              backgroundColor: const Color(0xFF059669),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.check_circle_rounded, size: 14),
                                        label: Text(strings.demoApproveBtn, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppTheme.slate200))),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(sheetCtx);
                          _showUploadDocumentSheet(context, provider, strings);
                        },
                        icon: const Icon(Icons.file_upload_outlined, color: Colors.white, size: 18),
                        label: Text(strings.uploadNewDocument, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 4. UPLOAD CERTIFICATE SHEET
  void _showUploadDocumentSheet(
    BuildContext context,
    StaffDutyProvider provider,
    AppStrings strings,
  ) {
    final titleCtrl = TextEditingController();
    final instituteCtrl = TextEditingController();
    final yearCtrl = TextEditingController(text: DateTime.now().year.toString());
    String selectedFileName = 'certificate_${DateTime.now().millisecondsSinceEpoch % 1000}.jpg';
    String? certImageBase64;
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                strings.uploadNewDocument,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.slate900),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () => Navigator.pop(sheetCtx),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        TextField(
                          controller: titleCtrl,
                          decoration: InputDecoration(
                            labelText: strings.certTitleLabel,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 12),

                        TextField(
                          controller: instituteCtrl,
                          decoration: InputDecoration(
                            labelText: strings.certInstituteLabel,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 12),

                        TextField(
                          controller: yearCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: strings.certYearLabel,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 14),

                        const Text('Capture or Upload Certificate Photo:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.slate800)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.camera_alt_rounded, size: 16),
                                label: Text(strings.cameraBtn, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                                onPressed: () async {
                                  try {
                                    final img = await picker.pickImage(source: ImageSource.camera, maxWidth: 700, maxHeight: 700, imageQuality: 50);
                                    if (img != null) {
                                      final bytes = await img.readAsBytes();
                                      setSheetState(() {
                                        certImageBase64 = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                                        selectedFileName = img.name;
                                      });
                                    }
                                  } catch (e) {
                                    debugPrint('Certificate camera error: $e');
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.photo_library_rounded, size: 16),
                                label: Text(strings.galleryBtn, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                                onPressed: () async {
                                  try {
                                    final img = await picker.pickImage(source: ImageSource.gallery, maxWidth: 700, maxHeight: 700, imageQuality: 50);
                                    if (img != null) {
                                      final bytes = await img.readAsBytes();
                                      setSheetState(() {
                                        certImageBase64 = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                                        selectedFileName = img.name;
                                      });
                                    }
                                  } catch (e) {
                                    debugPrint('Certificate gallery error: $e');
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Preview Container
                        if (certImageBase64 != null && certImageBase64!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.memory(
                                    base64Decode(certImageBase64!.split(',').last),
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(selectedFileName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                      const Text('Certificate photo ready to submit', style: TextStyle(fontSize: 11, color: Colors.green)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.slate50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.slate200),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFDC2626)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    selectedFileName,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.slate800),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (titleCtrl.text.trim().isEmpty || instituteCtrl.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(strings.fillAllFieldsAlert)),
                                );
                                return;
                              }
                              provider.uploadQualificationDocument(
                                title: titleCtrl.text.trim(),
                                institute: instituteCtrl.text.trim(),
                                issueYear: yearCtrl.text.trim(),
                                fileName: selectedFileName,
                                fileUrl: certImageBase64,
                              );
                              Navigator.pop(sheetCtx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(strings.uploadDocSuccess),
                                  backgroundColor: const Color(0xFF059669),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(strings.submitForReviewBtn, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 5. FINANCIAL OVERVIEW SHEET
  void _showFinancialOverviewSheet(
    BuildContext context,
    CaregiverUserModel staff,
    StaffDutyProvider provider,
    AppStrings strings,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 6),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: AppTheme.slate300, borderRadius: BorderRadius.circular(2)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            strings.financialOverview,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.slate900),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(sheetCtx),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppTheme.slate200),

                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildMetricTile(
                                  icon: Icons.task_alt_rounded,
                                  color: AppTheme.primaryBlue,
                                  label: strings.completedShifts,
                                  value: '${staff.completedShiftsThisMonth} ${strings.shiftsCountLabel}',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildMetricTile(
                                  icon: Icons.today_rounded,
                                  color: const Color(0xFF059669),
                                  label: strings.dailyEarnings,
                                  value: '${strings.currencySymbol} ${NumberFormat('#,###').format(staff.dailyEarnings)}',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _buildMetricTile(
                                  icon: Icons.date_range_rounded,
                                  color: const Color(0xFF7C3AED),
                                  label: strings.weeklyEarnings,
                                  value: '${strings.currencySymbol} ${NumberFormat('#,###').format(staff.weeklyEarnings)}',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildMetricTile(
                                  icon: Icons.account_balance_wallet_rounded,
                                  color: const Color(0xFFD97706),
                                  label: strings.monthlyEarnings,
                                  value: '${strings.currencySymbol} ${NumberFormat('#,###').format(staff.totalEarningsThisMonth)}',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.slate50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppTheme.slate200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.account_balance_rounded, size: 20, color: AppTheme.primaryBlue),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        strings.bankAccountDetailsTitle,
                                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppTheme.slate900),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(sheetCtx);
                                        _showEditBankSheet(context, staff, provider, strings);
                                      },
                                      child: const Text(
                                        'Edit / Update',
                                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                if (staff.bankDetails != null && staff.bankDetails!.bankName.isNotEmpty) ...[
                                  _buildBankRow(strings.bankNameLabel, staff.bankDetails!.bankName),
                                  _buildBankRow(strings.bankBranchLabel, staff.bankDetails!.branchName.isNotEmpty ? staff.bankDetails!.branchName : 'Main Branch'),
                                  _buildBankRow(strings.bankAccountNumberLabel, staff.bankDetails!.maskedAccountNumber),
                                  _buildBankRow(strings.payoutCycleLabel, staff.bankDetails!.payoutCycle),
                                  _buildBankRow(
                                    strings.accountStatusLabel,
                                    staff.bankDetails!.isVerified ? strings.accountActiveValue : 'Pending Verification',
                                  ),
                                ] else ...[
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.amber.shade200),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.info_outline_rounded, color: Colors.amber.shade800, size: 18),
                                        const SizedBox(width: 8),
                                        const Expanded(
                                          child: Text(
                                            'No Sri Lankan bank account linked yet. Connect your account for weekly shift payouts.',
                                            style: TextStyle(fontSize: 11, color: Color(0xFF92400E)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primaryBlue,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      icon: const Icon(Icons.add_rounded, size: 16),
                                      label: const Text('Add Bank Account Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                      onPressed: () {
                                        Navigator.pop(sheetCtx);
                                        _showEditBankSheet(context, staff, provider, strings);
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFBBF7D0)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF15803D), size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    strings.payoutNotice,
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF166534), height: 1.35),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 5. EDIT BANK ACCOUNT SHEET
  void _showEditBankSheet(
    BuildContext context,
    CaregiverUserModel staff,
    StaffDutyProvider provider,
    AppStrings strings,
  ) {
    final existingBank = staff.bankDetails;
    final slBanks = [
      'Commercial Bank of Ceylon',
      'Bank of Ceylon (BOC)',
      "People's Bank",
      'Sampath Bank',
      'Hatton National Bank (HNB)',
      'Seylan Bank',
      'Nations Trust Bank (NTB)',
      'DFCC Bank',
      'National Development Bank (NDB)',
      'Pan Asia Bank',
      'Union Bank of Colombo',
      'Amana Bank',
      'Other / Cooperative Bank',
    ];

    String selectedBank = (existingBank != null && slBanks.contains(existingBank.bankName))
        ? existingBank.bankName
        : 'Commercial Bank of Ceylon';
    final branchCtrl = TextEditingController(text: existingBank?.branchName ?? '');
    final accNumCtrl = TextEditingController(text: existingBank?.accountNumber ?? '');
    final accHolderCtrl = TextEditingController(text: existingBank?.accountHolderName.isNotEmpty == true ? existingBank!.accountHolderName : staff.fullName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 6),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(color: AppTheme.slate300, borderRadius: BorderRadius.circular(2)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Bank Account Details',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.slate900),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () => Navigator.pop(sheetCtx),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppTheme.slate200),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Bank Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.slate700)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                initialValue: selectedBank,
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: AppTheme.slate50,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.slate200)),
                                ),
                                items: slBanks.map((b) => DropdownMenuItem(value: b, child: Text(b, style: const TextStyle(fontSize: 13)))).toList(),
                                onChanged: (val) {
                                  if (val != null) setSheetState(() => selectedBank = val);
                                },
                              ),
                              const SizedBox(height: 14),

                              const Text('Branch Location', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.slate700)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: branchCtrl,
                                decoration: InputDecoration(
                                  hintText: 'e.g. Marawila, Chilaw, Colombo Fort',
                                  filled: true,
                                  fillColor: AppTheme.slate50,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.slate200)),
                                ),
                              ),
                              const SizedBox(height: 14),

                              const Text('Account Number', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.slate700)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: accNumCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'e.g. 800412345678',
                                  filled: true,
                                  fillColor: AppTheme.slate50,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.slate200)),
                                ),
                              ),
                              const SizedBox(height: 14),

                              const Text('Account Holder Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.slate700)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: accHolderCtrl,
                                decoration: InputDecoration(
                                  hintText: 'Full legal name as in bank passbook',
                                  filled: true,
                                  fillColor: AppTheme.slate50,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.slate200)),
                                ),
                              ),
                              const SizedBox(height: 20),

                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryBlue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                  icon: const Icon(Icons.check_circle_rounded),
                                  label: const Text('Save Bank Account', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    final bank = BankAccountDetails(
                                      bankName: selectedBank,
                                      branchName: branchCtrl.text.trim(),
                                      accountNumber: accNumCtrl.text.trim(),
                                      accountHolderName: accHolderCtrl.text.trim(),
                                      payoutCycle: existingBank?.payoutCycle ?? 'Weekly Every Monday',
                                      isVerified: existingBank?.isVerified ?? false,
                                    );
                                    provider.updateBankDetails(bank);
                                    Navigator.pop(sheetCtx);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Bank account details saved successfully!'),
                                        backgroundColor: Color(0xFF059669),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 6. SHIFTS & ROSTER SHEET
  void _showShiftsRosterSheet(
    BuildContext context,
    StaffDutyProvider provider,
    AppStrings strings,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final upcomingShifts = provider.shiftRoster
                .where((s) => s.status == ShiftStatus.upcoming || s.status == ShiftStatus.active)
                .toList();
            final completedShifts = provider.shiftRoster
                .where((s) => s.status == ShiftStatus.completed)
                .toList();

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 6),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(color: AppTheme.slate300, borderRadius: BorderRadius.circular(2)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                strings.dutiesMenuTitle,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.slate900),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () => Navigator.pop(sheetCtx),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppTheme.slate200),

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: AppTheme.slate100, borderRadius: BorderRadius.circular(14)),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => setSheetState(() => _selectedShiftTab = 0),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 9),
                                  decoration: BoxDecoration(
                                    color: _selectedShiftTab == 0 ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: _selectedShiftTab == 0
                                        ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1))]
                                        : null,
                                  ),
                                  child: Text(
                                    strings.upcomingDuties,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: _selectedShiftTab == 0 ? FontWeight.w800 : FontWeight.w600,
                                      color: _selectedShiftTab == 0 ? AppTheme.primaryBlue : AppTheme.slate600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => setSheetState(() => _selectedShiftTab = 1),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 9),
                                  decoration: BoxDecoration(
                                    color: _selectedShiftTab == 1 ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: _selectedShiftTab == 1
                                        ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1))]
                                        : null,
                                  ),
                                  child: Text(
                                    strings.pastDuties,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: _selectedShiftTab == 1 ? FontWeight.w800 : FontWeight.w600,
                                      color: _selectedShiftTab == 1 ? AppTheme.primaryBlue : AppTheme.slate600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Flexible(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          children: [
                            if (_selectedShiftTab == 0) ...[
                              if (upcomingShifts.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Center(
                                    child: Text(strings.noShiftsAvailable, style: const TextStyle(color: AppTheme.slate400, fontSize: 13)),
                                  ),
                                )
                              else
                                ...upcomingShifts.map((shift) => _buildShiftTile(shift, false, strings)),
                            ] else ...[
                              if (completedShifts.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Center(
                                    child: Text(strings.noShiftsAvailable, style: const TextStyle(color: AppTheme.slate400, fontSize: 13)),
                                  ),
                                )
                              else
                                ...completedShifts.map((shift) => _buildShiftTile(shift, true, strings)),
                            ],
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 7. NOTIFICATIONS SHEET
  void _showNotificationsSheet(BuildContext context, StaffDutyProvider provider, AppStrings strings) {
    final langProvider = context.read<LanguageProvider>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 6),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: AppTheme.slate300, borderRadius: BorderRadius.circular(2)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            strings.notificationsTitle,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.slate900),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            provider.markAllNotificationsAsRead();
                          },
                          child: Text(strings.markAllAsRead, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppTheme.slate200),

                  Flexible(
                    child: provider.notifications.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(40),
                            child: Center(child: Text(strings.noNotifications, style: const TextStyle(color: AppTheme.slate500))),
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            itemCount: provider.notifications.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 10),
                            itemBuilder: (context, idx) {
                              final notif = provider.notifications[idx];
                              return InkWell(
                                onTap: () => provider.markNotificationAsRead(notif.id),
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: notif.isRead ? Colors.white : AppTheme.blueLight.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: notif.isRead ? AppTheme.slate200 : AppTheme.primaryBlue.withValues(alpha: 0.3)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: notif.category == 'qualification'
                                            ? AppTheme.emerald50
                                            : notif.category == 'duty'
                                                ? AppTheme.blueLight
                                                : AppTheme.amber50,
                                        child: Icon(
                                          notif.category == 'qualification'
                                              ? Icons.verified_rounded
                                              : notif.category == 'duty'
                                                  ? Icons.campaign_rounded
                                                  : Icons.payments_rounded,
                                          size: 16,
                                          color: notif.category == 'qualification'
                                              ? AppTheme.emerald800
                                              : notif.category == 'duty'
                                                  ? AppTheme.primaryBlue
                                                  : AppTheme.amber800,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              notif.localizedTitle(langProvider.currentLocale),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: notif.isRead ? FontWeight.w700 : FontWeight.w900,
                                                color: AppTheme.slate900,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              notif.localizedMessage(langProvider.currentLocale),
                                              style: const TextStyle(fontSize: 12, color: AppTheme.slate600, height: 1.3),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 8. HELP & ADMIN CHAT SHEET
  void _showHelpSupportSheet(BuildContext context, StaffDutyProvider provider, AppStrings strings) {
    final messageCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            strings.helpAndSupport,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.slate900),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(sheetCtx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      strings.helpSupportDesc,
                      style: const TextStyle(fontSize: 12, color: AppTheme.slate600, height: 1.35),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => provider.makePhoneCall('0705001122'),
                            icon: const Icon(Icons.phone_rounded, size: 16),
                            label: Text(strings.callAdminBtn, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              foregroundColor: AppTheme.primaryBlue,
                              side: const BorderSide(color: AppTheme.primaryBlue),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => provider.openWhatsAppEmergency(
                              phone: '0705001122',
                              message: 'Hello Prime Life Care Admin, I am caregiver ${provider.currentStaff.fullName}. I need support regarding my duties.',
                            ),
                            icon: const Icon(Icons.chat_rounded, size: 16, color: Colors.white),
                            label: Text(strings.whatsappAdminBtn, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white), overflow: TextOverflow.ellipsis),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25D366),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    Text(strings.sendInquiryTitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: messageCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: strings.inquiryHint,
                        hintStyle: const TextStyle(fontSize: 12, color: AppTheme.slate400),
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (messageCtrl.text.trim().isNotEmpty) {
                            Navigator.pop(sheetCtx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(strings.inquirySentSuccess),
                                backgroundColor: const Color(0xFF059669),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(strings.sendInquiryBtn, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 9. LANGUAGE PICKER SHEET
  void _showLanguagePickerSheet(BuildContext context, LanguageProvider langProvider, AppStrings strings) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        strings.appLanguageMenuTitle,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.slate900),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(sheetCtx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildLangTile('si', '🇱🇰 ${strings.sinhalaLabel}', langProvider, sheetCtx),
                _buildLangTile('en', '🇬🇧 ${strings.englishLabel}', langProvider, sheetCtx),
                _buildLangTile('ta', '🇮🇳 ${strings.tamilLabel}', langProvider, sheetCtx),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLangTile(String code, String name, LanguageProvider provider, BuildContext ctx) {
    final isSelected = provider.currentLocale == code;
    return InkWell(
      onTap: () {
        provider.setLanguageByCode(code);
        Navigator.pop(ctx);
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.blueLight : AppTheme.slate50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? AppTheme.primaryBlue : AppTheme.slate200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppTheme.primaryBlue : AppTheme.slate800,
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: AppTheme.primaryBlue, size: 20),
          ],
        ),
      ),
    );
  }

  // 10. CHANGE PASSWORD DIALOG (Responsive with SingleChildScrollView)
  void _showChangePasswordDialog(BuildContext context, StaffDutyProvider provider, AppStrings strings) {
    final currentPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              const Icon(Icons.lock_reset_rounded, color: AppTheme.primaryBlue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(strings.changePassword, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPassCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: strings.currentPasswordLabel,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newPassCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: strings.newPasswordLabel,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmPassCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: strings.confirmNewPasswordLabel,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(strings.backBtn, style: const TextStyle(color: AppTheme.slate600, fontWeight: FontWeight.w700)),
            ),
            ElevatedButton(
              onPressed: () {
                if (newPassCtrl.text.isEmpty || newPassCtrl.text != confirmPassCtrl.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(strings.passwordMismatchAlert)),
                  );
                  return;
                }
                provider.changePassword(
                  currentPassword: currentPassCtrl.text,
                  newPassword: newPassCtrl.text,
                );
                Navigator.pop(dialogCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(strings.passwordChangedSuccess),
                    backgroundColor: const Color(0xFF059669),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(strings.savePasswordBtn, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );
  }

  // 11. LOGOUT DIALOG
  void _showLogoutDialog(BuildContext context, AppStrings strings) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(strings.logoutConfirmTitle, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          content: Text(strings.logoutConfirmDesc, style: const TextStyle(fontSize: 13, color: AppTheme.slate600)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(strings.backBtn, style: const TextStyle(color: AppTheme.slate600, fontWeight: FontWeight.w700)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('is_logged_in', false);
                  await prefs.remove('logged_membership_no');
                } catch (e) {
                  debugPrint('[Logout] Session clear warning: $e');
                }
                if (context.mounted) {
                  Navigator.pop(dialogCtx);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(strings.logout, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPercentSlider({
    required String label,
    required int value,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.slate700), overflow: TextOverflow.ellipsis),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: value.toDouble(),
              min: 0,
              max: 100,
              divisions: 20,
              activeColor: AppTheme.primaryBlue,
              inactiveColor: AppTheme.slate200,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 38,
          child: Text(
            '$value%',
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.primaryBlue),
          ),
        ),
      ],
    );
  }

  Widget _buildBankRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.slate500)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.slate800),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({required IconData icon, required Color color, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.slate50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.slate200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.slate500), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppTheme.slate900), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildShiftTile(ShiftRosterModel shift, bool isCompleted, AppStrings strings) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.slate200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isCompleted ? AppTheme.emerald50 : AppTheme.blueLight,
            child: Icon(
              isCompleted ? Icons.check_circle_outline_rounded : Icons.schedule_rounded,
              size: 18,
              color: isCompleted ? AppTheme.emerald800 : AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shift.patientName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppTheme.slate900)),
                Text(
                  '${DateFormat('yyyy-MM-dd').format(shift.date)} • ${shift.shiftType.timing}',
                  style: const TextStyle(fontSize: 11, color: AppTheme.slate500),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '📍 ${shift.patientLocation}',
                  style: const TextStyle(fontSize: 10, color: AppTheme.slate400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${strings.currencySymbol} ${NumberFormat('#,###').format(shift.paymentAmount)}',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: AppTheme.primaryBlue),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isCompleted ? const Color(0xFFDCFCE7) : AppTheme.blueLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isCompleted ? strings.completedStatusBadge : strings.upcomingStatusBadge,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: isCompleted ? const Color(0xFF15803D) : AppTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- MENU BUILDERS ---
  Widget _buildMenuGroup({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppTheme.slate500,
              letterSpacing: 0.6,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
    bool isLast = false,
    bool isDestructive = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: isDestructive ? const Color(0xFFDC2626) : AppTheme.slate900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDestructive ? const Color(0xFFEF4444) : AppTheme.slate500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing,
                ],
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: isDestructive ? const Color(0xFFF87171) : const Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
        if (!isLast) const Divider(height: 1, indent: 58, color: Color(0xFFF1F5F9)),
      ],
    );
  }

  Widget _buildQuickStat({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: color.withValues(alpha: 0.12),
                child: Icon(icon, size: 15, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: AppTheme.slate900),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: const TextStyle(fontSize: 10, color: AppTheme.slate500, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StaffDutyProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final strings = langProvider.strings;
    final staff = provider.currentStaff;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(strings.profileTitle, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          // Notification Bell with Badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppTheme.slate800),
                tooltip: strings.notificationsTitle,
                onPressed: () => _showNotificationsSheet(context, provider, strings),
              ),
              if (provider.unreadNotificationCount > 0)
                Positioned(
                  top: 10,
                  right: 10,
                  child: IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Color(0xFFDC2626), shape: BoxShape.circle),
                      child: Text(
                        '${provider.unreadNotificationCount}',
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Switch Demo Staff Profile
          PopupMenuButton(
            icon: CircleAvatar(
              radius: 15,
              backgroundColor: AppTheme.primaryBlue,
              child: Text(
                staff.avatarInitials,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11),
              ),
            ),
            tooltip: strings.professionalSection,
            onSelected: (profile) => provider.switchStaff(profile),
            itemBuilder: (context) => provider.availableStaff
                .map(
                  (s) => PopupMenuItem(
                    value: s,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: s.id == staff.id ? AppTheme.primaryBlue : AppTheme.slate200,
                          child: Text(
                            s.avatarInitials,
                            style: TextStyle(
                              color: s.id == staff.id ? Colors.white : AppTheme.slate700,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            s.fullName,
                            style: TextStyle(
                              fontWeight: s.id == staff.id ? FontWeight.w800 : FontWeight.w600,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. TOP PROFILE HEADER CARD (PREMIUM COVER BANNER STYLE)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 14, offset: const Offset(0, 4)),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover Image Header with Overlapping Avatar Stack
                  SizedBox(
                    height: 168,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Cover Banner Image
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 120,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                'assets/images/profile_cover.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF1E3A8A), Color(0xFF0D9488)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                ),
                              ),
                              // Soft dark gradient overlay for branding readability
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.38),
                                      Colors.black.withValues(alpha: 0.08),
                                      Colors.black.withValues(alpha: 0.52),
                                    ],
                                  ),
                                ),
                              ),
                              // Top Left: Brand tag
                              Positioned(
                                top: 12,
                                left: 14,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.45),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF10B981),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'PRIME LIFE CARE',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Top Right: Certified Staff Badge
                              Positioned(
                                top: 12,
                                right: 14,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F766E).withValues(alpha: 0.88),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.verified_user_rounded, size: 12, color: Colors.white),
                                      SizedBox(width: 4),
                                      Text(
                                        'CERTIFIED AIDE',
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Overlapping Avatar with sample guide & camera upload button
                        Positioned(
                          left: 16,
                          bottom: 4,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3.5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.12),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(2.5),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 34,
                                    backgroundColor: AppTheme.primaryBlue,
                                    child: staff.profileImageUrl != null && staff.profileImageUrl!.isNotEmpty
                                        ? ClipOval(
                                            child: staff.profileImageUrl!.startsWith('data:image')
                                                ? Image.memory(
                                                    _getCachedBytes(staff.profileImageUrl!)!,
                                                    width: 68,
                                                    height: 68,
                                                    fit: BoxFit.cover,
                                                    gaplessPlayback: true,
                                                  )
                                                : staff.profileImageUrl!.startsWith('http')
                                                    ? Image.network(
                                                        staff.profileImageUrl!,
                                                        width: 68,
                                                        height: 68,
                                                        fit: BoxFit.cover,
                                                        gaplessPlayback: true,
                                                        errorBuilder: (context, error, stackTrace) => Image.asset(
                                                          'assets/images/profile_sample_image.png',
                                                          width: 68,
                                                          height: 68,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                    : Image.asset(
                                                        'assets/images/profile_sample_image.png',
                                                        width: 68,
                                                        height: 68,
                                                        fit: BoxFit.cover,
                                                      ),
                                          )
                                        : ClipOval(
                                            child: Image.asset(
                                              'assets/images/profile_sample_image.png',
                                              width: 68,
                                              height: 68,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Text(
                                                staff.avatarInitials,
                                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),

                              // Camera upload or status badge on avatar
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    if (staff.isProfileImageApproved) {
                                      _showLockedApprovedDialog(context, strings.profilePhotoTitle, strings);
                                    } else {
                                      _showProfilePhotoPickerSheet(context, staff, provider, strings);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: staff.isProfileImageApproved
                                          ? const Color(0xFF059669)
                                          : staff.profileImageStatus == 'pending'
                                              ? const Color(0xFFD97706)
                                              : staff.profileImageStatus == 'rejected'
                                                  ? const Color(0xFFDC2626)
                                                  : const Color(0xFF2563EB),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      staff.isProfileImageApproved
                                          ? Icons.verified_rounded
                                          : staff.profileImageStatus == 'pending'
                                              ? Icons.hourglass_top_rounded
                                              : staff.profileImageStatus == 'rejected'
                                                  ? Icons.error_outline_rounded
                                                  : Icons.camera_alt_rounded,
                                      size: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Rating & Verified / Inactive Member status pills side-by-side in a SINGLE ROW
                        Positioned(
                          right: 14,
                          bottom: 8,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.amber50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppTheme.amber100),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star_rounded, size: 14, color: AppTheme.amber500),
                                    const SizedBox(width: 3),
                                    Text(
                                      '${staff.rating} / 5.0',
                                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppTheme.amber800),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              if (staff.isVerifiedMember)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.emerald50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppTheme.emerald100),
                                  ),
                                  child: Text(
                                    '✓ ${strings.verifiedBadgeText}',
                                    style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: AppTheme.emerald800),
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF2F2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFFFECACA)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.warning_amber_rounded, size: 12, color: Color(0xFFDC2626)),
                                      const SizedBox(width: 3),
                                      Text(
                                        strings.inactiveBadgeText,
                                        style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Color(0xFFDC2626)),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Profile Details Content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        Text(
                          staff.fullName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.slate900),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),

                        // Qualification Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.blueLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.medical_services_rounded, size: 12, color: AppTheme.primaryBlue),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  staff.qualification,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primaryBlue),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Photo Status Badge if Pending or Rejected
                        if (staff.profileImageStatus == 'pending') ...[
                          InkWell(
                            onTap: () => _showProfilePhotoPickerSheet(context, staff, provider, strings),
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFFDE68A)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.hourglass_top_rounded, size: 12, color: Color(0xFFD97706)),
                                  SizedBox(width: 4),
                                  Text(
                                    'Photo Pending Admin Approval ⏳',
                                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF92400E)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                        ] else if (staff.profileImageStatus == 'rejected') ...[
                          InkWell(
                            onTap: () => _showProfilePhotoPickerSheet(context, staff, provider, strings),
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFFECACA)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.cancel_rounded, size: 12, color: Color(0xFFDC2626)),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      staff.profileImageRejectionReason != null && staff.profileImageRejectionReason!.isNotEmpty
                                          ? 'Photo Rejected: ${staff.profileImageRejectionReason} (Tap to change)'
                                          : 'Photo Rejected by Admin - Tap to Replace ✕',
                                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFFDC2626)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                        const SizedBox(height: 12),

                        // Reg No & Zone Strip
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.slate50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${strings.staffIdLabel}: ${staff.staffRegNo}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.slate700),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  '📍 ${staff.assignedZone}',
                                  style: const TextStyle(fontSize: 11, color: AppTheme.slate600, fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Caregiver Bio Snippet
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            staff.bio,
                            style: const TextStyle(fontSize: 12, color: AppTheme.slate600, height: 1.4),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Edit Profile Shortcut Button (Only shown before personal details are approved)
                        if (!staff.isPersonalDetailsApproved && !staff.isVerifiedMember) ...[
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => _showEditProfileSheet(context, staff, provider, strings),
                              icon: const Icon(Icons.edit_rounded, size: 16),
                              label: Text(strings.editProfile, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryBlue,
                                side: const BorderSide(color: AppTheme.primaryBlue),
                                padding: const EdgeInsets.symmetric(vertical: 11),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 1.5 INTERACTIVE MEMBERSHIP VERIFICATION & MISSING DOCUMENTS PIPELINE
            _buildVerificationPipelineCard(context, staff, provider, strings),
            const SizedBox(height: 14),

            // 2. QUICK STATS STRIP
            Row(
              children: [
                _buildQuickStat(
                  icon: Icons.task_alt_rounded,
                  color: AppTheme.primaryBlue,
                  value: '${staff.completedShiftsThisMonth} ${strings.shiftsCountLabel}',
                  label: strings.completedShifts,
                  onTap: () => _showShiftsRosterSheet(context, provider, strings),
                ),
                const SizedBox(width: 8),
                _buildQuickStat(
                  icon: Icons.account_balance_wallet_rounded,
                  color: const Color(0xFF059669),
                  value: '${strings.currencySymbol} ${NumberFormat('#,###').format(staff.totalEarningsThisMonth)}',
                  label: strings.monthlyEarnings,
                  onTap: () => _showFinancialOverviewSheet(context, staff, provider, strings),
                ),
                const SizedBox(width: 8),
                _buildQuickStat(
                  icon: Icons.workspace_premium_rounded,
                  color: const Color(0xFFD97706),
                  value: '${staff.documents.where((d) => d.isVerified).length} ${strings.verifiedBadge}',
                  label: strings.certificatesCountLabel,
                  onTap: () => _showDocumentsSheet(context, staff, provider, strings),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // 3. MENU GROUP 1: PROFESSIONAL PROFILE
            _buildMenuGroup(
              title: strings.professionalSection,
              children: [
                _buildMenuItem(
                  icon: Icons.badge_outlined,
                  iconColor: AppTheme.primaryBlue,
                  title: strings.personalDetailsMenuTitle,
                  subtitle: strings.personalDetailsMenuSub,
                  onTap: () => _showEditProfileSheet(context, staff, provider, strings),
                ),
                _buildMenuItem(
                  icon: Icons.translate_rounded,
                  iconColor: const Color(0xFF0284C7),
                  title: strings.languageProficiencyTitle,
                  subtitle: strings.languageSkillsMenuSub,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppTheme.blueLight, borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      '${staff.languages.length} ${strings.languagesCountBadge}',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.primaryBlue),
                    ),
                  ),
                  onTap: () => _showLanguageProficiencySheet(context, staff, provider, strings),
                ),
                _buildMenuItem(
                  icon: Icons.workspace_premium_outlined,
                  iconColor: const Color(0xFFD97706),
                  title: strings.documentsTitle,
                  subtitle: strings.documentsMenuSub,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      '${staff.documents.length} ${strings.docsCountLabel}',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFFB45309)),
                    ),
                  ),
                  isLast: true,
                  onTap: () => _showDocumentsSheet(context, staff, provider, strings),
                ),
              ],
            ),

            // 4. MENU GROUP 2: EARNINGS & SHIFTS
            _buildMenuGroup(
              title: strings.earningsAndShiftsSection,
              children: [
                _buildMenuItem(
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: const Color(0xFF059669),
                  title: strings.financialOverview,
                  subtitle: strings.financialMenuSub,
                  trailing: Text(
                    '${strings.currencySymbol} ${NumberFormat('#,###').format(staff.totalEarningsThisMonth)}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF059669)),
                  ),
                  onTap: () => _showFinancialOverviewSheet(context, staff, provider, strings),
                ),
                _buildMenuItem(
                  icon: Icons.calendar_month_outlined,
                  iconColor: const Color(0xFF7C3AED),
                  title: strings.dutiesMenuTitle,
                  subtitle: strings.dutiesMenuSub,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: const Color(0xFFF3E8FF), borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      '${provider.shiftRoster.where((s) => s.status == ShiftStatus.upcoming || s.status == ShiftStatus.active).length} ${strings.activeShiftsBadgeText}',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF7C3AED)),
                    ),
                  ),
                  isLast: true,
                  onTap: () => _showShiftsRosterSheet(context, provider, strings),
                ),
              ],
            ),

            // 5. MENU GROUP 3: SUPPORT & SECURITY
            _buildMenuGroup(
              title: strings.supportAndSecuritySection,
              children: [
                _buildMenuItem(
                  icon: Icons.notifications_none_rounded,
                  iconColor: const Color(0xFFEA580C),
                  title: strings.notificationsTitle,
                  subtitle: strings.notificationsMenuSub,
                  trailing: provider.unreadNotificationCount > 0
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: const Color(0xFFDC2626), borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            '${provider.unreadNotificationCount} ${strings.newBadgeText}',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        )
                      : null,
                  onTap: () => _showNotificationsSheet(context, provider, strings),
                ),
                _buildMenuItem(
                  icon: Icons.support_agent_rounded,
                  iconColor: const Color(0xFF0D9488),
                  title: strings.helpAndSupport,
                  subtitle: strings.helpSupportMenuSub,
                  onTap: () => _showHelpSupportSheet(context, provider, strings),
                ),
                _buildMenuItem(
                  icon: Icons.language_rounded,
                  iconColor: AppTheme.primaryBlue,
                  title: strings.appLanguageMenuTitle,
                  subtitle: strings.appLanguageMenuSub,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppTheme.slate100, borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      langProvider.currentLocale == 'si'
                          ? '🇱🇰 ${strings.sinhalaLabel}'
                          : langProvider.currentLocale == 'ta'
                              ? '🇮🇳 ${strings.tamilLabel}'
                              : '🇬🇧 ${strings.englishLabel}',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.slate700),
                    ),
                  ),
                  onTap: () => _showLanguagePickerSheet(context, langProvider, strings),
                ),
                _buildMenuItem(
                  icon: Icons.lock_outline_rounded,
                  iconColor: const Color(0xFF64748B),
                  title: strings.changePassword,
                  subtitle: strings.changePasswordMenuSub,
                  isLast: true,
                  onTap: () => _showChangePasswordDialog(context, provider, strings),
                ),
              ],
            ),

            // 6. MENU GROUP 4: ACCOUNT ACTION & LOGOUT
            _buildMenuGroup(
              title: strings.accountActionSection,
              children: [
                _buildMenuItem(
                  icon: Icons.logout_rounded,
                  iconColor: const Color(0xFFDC2626),
                  title: strings.logout,
                  subtitle: strings.logoutSubtitle,
                  isDestructive: true,
                  isLast: true,
                  onTap: () => _showLogoutDialog(context, strings),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ===================== MEMBERSHIP VERIFICATION PIPELINE WIDGET =====================
  Widget _buildVerificationPipelineCard(
    BuildContext context,
    CaregiverUserModel staff,
    StaffDutyProvider provider,
    AppStrings strings,
  ) {
    final nextKey = staff.nextRequiredStepKey;
    final isAllApproved = staff.isVerifiedMember;

    String getNextKeyTitle() {
      switch (nextKey) {
        case 'profile_image':
          return strings.profilePhotoTitle;
        case 'personal_details':
        case 'nic_front':
        case 'nic_back':
          return strings.personalDetailsAndNicTitle;
        case 'police_report':
          return strings.policeReportTitle;
        case 'qualification_cert':
          return strings.qualificationCertTitle;
        case 'face_verification':
          return strings.faceVerificationTitle;
        default:
          return strings.allVerifiedComplete;
      }
    }

    void handleItemTap(String key) {
      switch (key) {
        case 'profile_image':
          if (staff.isProfileImageApproved) {
            _showLockedApprovedDialog(context, strings.profilePhotoTitle, strings);
          } else {
            _showProfilePhotoPickerSheet(context, staff, provider, strings);
          }
          break;
        case 'personal_details':
        case 'nic_front':
        case 'nic_back':
          _showEditProfileSheet(context, staff, provider, strings);
          break;
        case 'police_report':
          if (staff.isPoliceReportApproved) {
            _showLockedApprovedDialog(context, strings.policeReportTitle, strings);
          } else {
            _showPoliceReportUploadSheet(context, staff, provider, strings);
          }
          break;
        case 'qualification_cert':
          if (staff.isQualificationCertApproved) {
            _showLockedApprovedDialog(context, strings.qualificationCertTitle, strings);
          } else {
            _showUploadDocumentSheet(context, provider, strings);
          }
          break;
        case 'face_verification':
          if (staff.isFaceVerificationApproved) {
            _showLockedApprovedDialog(context, strings.faceVerificationTitle, strings);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FaceVerificationView()),
            );
          }
          break;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAllApproved ? const Color(0xFFA7F3D0) : const Color(0xFFFED7AA),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Arrow (Clickable to Expand / Collapse)
          InkWell(
            onTap: () => setState(() => _isVerificationPipelineExpanded = !_isVerificationPipelineExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isAllApproved ? const Color(0xFFD1FAE5) : const Color(0xFFFFEDD5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isAllApproved ? Icons.verified_user_rounded : Icons.pending_actions_rounded,
                      color: isAllApproved ? const Color(0xFF059669) : const Color(0xFFEA580C),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAllApproved ? strings.verifiedMemberStatus : strings.memberVerificationTitle,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppTheme.slate900),
                        ),
                        Text(
                          strings.verificationDocumentsApprovedCount(staff.approvedVerificationCount, (staff.verificationProgress * 100).toInt()),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isAllApproved ? const Color(0xFF059669) : const Color(0xFFD97706),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isAllApproved ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isAllApproved ? strings.verifiedBadgeText : strings.inactiveBadgeText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: isAllApproved ? const Color(0xFF047857) : const Color(0xFFDC2626),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.slate100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isVerificationPipelineExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      color: AppTheme.primaryBlue,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: staff.verificationProgress,
              minHeight: 7,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation(
                isAllApproved ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
              ),
            ),
          ),

          // Next Required Step Banner (Always visible if not all approved for quick 1-tap action)
          if (!isAllApproved && nextKey != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.arrow_circle_right_rounded, color: Color(0xFFD97706), size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.nextRequiredStepLabel,
                          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                        ),
                        Text(
                          getNextKeyTitle(),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF78350F)),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => handleItemTap(nextKey),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(strings.submitDocumentBtn, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],

          // Expand / Collapse Bar
          const SizedBox(height: 10),
          InkWell(
            onTap: () => setState(() => _isVerificationPipelineExpanded = !_isVerificationPipelineExpanded),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _isVerificationPipelineExpanded ? AppTheme.slate100 : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isVerificationPipelineExpanded ? strings.hideDocumentsList : strings.viewAllDocumentsList,
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _isVerificationPipelineExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: AppTheme.primaryBlue,
                  ),
                ],
              ),
            ),
          ),

          // List of 5 Verification Items (Collapsed by default, Expandable via arrow)
          if (_isVerificationPipelineExpanded) ...[
            const SizedBox(height: 12),
            _buildPipelineItemRow(
              title: '1. ${strings.profilePhotoTitle}',
              status: staff.profileImageStatus,
              rejectionReason: staff.profileImageRejectionReason,
              icon: Icons.account_box_rounded,
              strings: strings,
              onTap: () => handleItemTap('profile_image'),
            ),
            _buildPipelineItemRow(
              title: '2. ${strings.personalDetailsAndNicTitle}',
              status: staff.personalDetailsStatus,
              icon: Icons.badge_rounded,
              strings: strings,
              onTap: () => handleItemTap('personal_details'),
            ),
            _buildPipelineItemRow(
              title: '3. ${strings.policeReportTitle}',
              status: staff.policeReportStatus,
              icon: Icons.local_police_rounded,
              strings: strings,
              onTap: () => handleItemTap('police_report'),
            ),
            _buildPipelineItemRow(
              title: '4. ${strings.qualificationCertTitle}',
              status: staff.qualificationCertStatus,
              icon: Icons.school_rounded,
              strings: strings,
              onTap: () => handleItemTap('qualification_cert'),
            ),
            _buildPipelineItemRow(
              title: '5. ${strings.faceVerificationTitle}',
              status: staff.faceVerificationStatus,
              icon: Icons.face_retouching_natural_rounded,
              strings: strings,
              onTap: () => handleItemTap('face_verification'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPipelineItemRow({
    required String title,
    required String status,
    String? rejectionReason,
    required IconData icon,
    required AppStrings strings,
    required VoidCallback onTap,
  }) {
    final isAppr = status == 'approved';
    final isRej = status == 'rejected';
    final isPend = status == 'pending';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: isAppr
              ? Colors.green.shade50.withValues(alpha: 0.3)
              : isRej
                  ? Colors.red.shade50.withValues(alpha: 0.3)
                  : isPend
                      ? Colors.amber.shade50.withValues(alpha: 0.4)
                      : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isAppr
                ? Colors.green.shade200
                : isRej
                    ? Colors.red.shade200
                    : isPend
                        ? Colors.amber.shade300
                        : const Color(0xFFE2E8F0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isAppr
                      ? Colors.green.shade700
                      : isRej
                          ? Colors.red.shade700
                          : isPend
                              ? Colors.amber.shade800
                              : AppTheme.slate600,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isAppr ? FontWeight.w600 : FontWeight.bold,
                      color: AppTheme.slate800,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isAppr
                        ? Colors.green.shade100
                        : isRej
                            ? Colors.red.shade100
                            : isPend
                                ? Colors.amber.shade100
                                : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    isAppr
                        ? strings.statusApproved
                        : isRej
                            ? strings.statusRejected
                            : isPend
                                ? strings.statusPending
                                : strings.statusMissing,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                      color: isAppr
                          ? Colors.green.shade900
                          : isRej
                              ? Colors.red.shade900
                              : isPend
                                  ? Colors.amber.shade900
                                  : Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  isAppr ? Icons.lock_rounded : Icons.chevron_right_rounded,
                  size: 16,
                  color: isAppr ? Colors.green.shade700 : AppTheme.slate400,
                ),
              ],
            ),
            if (isRej && rejectionReason != null && rejectionReason.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                '${strings.rejectionReasonLabel}$rejectionReason',
                style: const TextStyle(fontSize: 10.5, color: Color(0xFFDC2626), fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
