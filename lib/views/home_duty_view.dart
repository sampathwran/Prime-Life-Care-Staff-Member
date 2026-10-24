import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/care_booking_model.dart';
import '../models/caregiver_user_model.dart';
import '../models/patient_duty_model.dart';
import '../providers/staff_duty_provider.dart';
import '../providers/language_provider.dart';
import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';
import '../widgets/duty_timer_card.dart';
import '../widgets/emergency_sos_sheet.dart';
import 'notifications_sheet.dart';
import 'profile_earnings_view.dart';

class HomeDutyView extends StatefulWidget {
  final Function(int) onNavigateTab;
  final VoidCallback? onOpenProfile;

  const HomeDutyView({
    super.key,
    required this.onNavigateTab,
    this.onOpenProfile,
  });

  @override
  State<HomeDutyView> createState() => _HomeDutyViewState();
}

class _HomeDutyViewState extends State<HomeDutyView> {
  bool _isActiveDutyExpanded = false;

  String _getShiftTypeEnglish(String shiftType) {
    switch (shiftType) {
      case '12h_day':
        return '12h Day Shift';
      case '12h_night':
        return '12h Night Shift';
      case '24h_full':
        return '24h Full Day Care';
      default:
        return '12h Shift';
    }
  }

  void _navigateToProfile(BuildContext context) {
    if (widget.onOpenProfile != null) {
      widget.onOpenProfile!();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileEarningsView()),
      );
    }
  }

  void _showAcceptConfirmation(
    BuildContext context,
    CareBookingModel booking,
    AppStrings strings,
    StaffDutyProvider provider,
    bool isUpcoming,
  ) {
    final currencyFmt = NumberFormat('#,###');

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isUpcoming ? const Color(0xFFF0FDF4) : AppTheme.blueLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isUpcoming ? Icons.calendar_today_rounded : Icons.handshake_rounded,
                  color: isUpcoming ? const Color(0xFF059669) : AppTheme.primaryBlue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isUpcoming ? strings.acceptAsNextDutyBtn : strings.acceptBookingConfirmTitle,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isUpcoming
                    ? strings.acceptAsNextDutyConfirmDesc
                    : strings.acceptBookingConfirmDesc,
                style: const TextStyle(fontSize: 13, color: AppTheme.slate600, height: 1.4),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.slate50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.slate200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${booking.bookingCode} • ${booking.careCategory}',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppTheme.slate900),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '📍 ${booking.city}, ${booking.district} • ${booking.durationDays} Days (${_getShiftTypeEnglish(booking.shiftType)})',
                      style: const TextStyle(fontSize: 12, color: AppTheme.slate600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Daily: LKR ${currencyFmt.format(booking.dailyRateLKR)}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.slate700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'LKR ${currencyFmt.format(booking.totalEarningsLKR)}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.primaryBlue),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                strings.backBtn,
                style: const TextStyle(color: AppTheme.slate600, fontWeight: FontWeight.w700),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                provider.acceptBooking(booking);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isUpcoming
                                ? strings.upcomingDutyAcceptedSnackbar(booking.city)
                                : strings.activeDutyAcceptedSnackbar(booking.bookingCode),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: const Color(0xFF059669),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isUpcoming ? const Color(0xFF059669) : AppTheme.primaryBlue,
              ),
              child: Text(
                isUpcoming ? strings.acceptAsNextDutyBtn : strings.acceptBookingBtn,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StaffDutyProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final strings = AppStrings(langProvider.currentLanguage);
    final staff = provider.currentStaff;
    final patient = provider.currentPatient;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        automaticallyImplyLeading: false,
        toolbarHeight: 68,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  '${strings.greetingGoodDay} ',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.slate500,
                  ),
                ),
                Flexible(
                  child: Text(
                    staff.fullName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.slate900,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: provider.hasActiveBooking ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                    shape: BoxShape.circle,
                    boxShadow: provider.hasActiveBooking
                        ? [
                            BoxShadow(
                              color: const Color(0xFF10B981).withValues(alpha: 0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  provider.hasActiveBooking ? strings.activeOnDutyBadge : strings.offDutyBadge,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: provider.hasActiveBooking ? const Color(0xFF065F46) : AppTheme.slate500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // NOTIFICATION BELL BUTTON WITH UNREAD BADGE
          Padding(
            padding: const EdgeInsets.only(right: 4, top: 4, bottom: 4),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: AppTheme.slate800, size: 24),
                  tooltip: strings.notificationsTitle,
                  onPressed: () => showStaffNotificationsSheet(context, provider, strings),
                ),
                if (provider.unreadNotificationCount > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withValues(alpha: 0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '${provider.unreadNotificationCount}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // TOP-RIGHT PROFILE AVATAR BUTTON
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 4, bottom: 4),
            child: InkWell(
              onTap: () => _navigateToProfile(context),
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.28),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppTheme.primaryBlue,
                      child: Text(
                        staff.avatarInitials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(milliseconds: 400)),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. ACTIVE DUTY SECTION (AT THE VERY TOP OF BODY)
              _buildTopActiveDutySection(context, provider, patient, staff, strings),
              const SizedBox(height: 16),

              // 2. UPCOMING QUEUED BOOKING CARD (IF ACCEPTED)
              if (provider.hasUpcomingBooking) ...[
                _buildUpcomingDutyCard(context, provider.upcomingBooking!, strings),
                const SizedBox(height: 16),
              ],

              // 2B. PENDING QUEUE BOOKINGS (WAITING FOR ADMIN SELECTION)
              if (provider.pendingBookings.isNotEmpty) ...[
                _buildPendingQueueSection(context, provider, strings),
                const SizedBox(height: 16),
              ],

              // 3. PRIVACY SHIELD BANNER
              _buildPrivacyShieldBanner(strings),
              const SizedBox(height: 16),

              // 4. AVAILABLE BOOKINGS (FILTERED BY QUALIFICATION CATEGORY)
              _buildAvailableBookingsSection(context, provider, staff, strings, langProvider),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // 1. TOP ACTIVE DUTY SECTION (EXPANDABLE ACCORDION)
  Widget _buildTopActiveDutySection(
    BuildContext context,
    StaffDutyProvider provider,
    PatientDutyModel patient,
    CaregiverUserModel staff,
    AppStrings strings,
  ) {
    if (!provider.hasActiveBooking) {
      // FREE / NO ACTIVE DUTY STATE
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.04),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFECFDF5), Color(0xFFD1FAE5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.readyForDutyBannerTitle,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.slate900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    strings.readyForDutyBannerSub,
                    style: const TextStyle(fontSize: 11.5, color: AppTheme.slate600, height: 1.35),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final activeBooking = provider.activeBooking!;
    final remainingDays = provider.activeDutyRemainingDays;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Header Strip: Active Pill + Remaining Days
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
            ),
            child: Row(
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF10B981),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    strings.activeDutyCardTitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: remainingDays <= 2
                        ? const Color(0xFFF59E0B).withValues(alpha: 0.25)
                        : Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: remainingDays <= 2
                          ? const Color(0xFFF59E0B).withValues(alpha: 0.5)
                          : Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.hourglass_top_rounded,
                        size: 13,
                        color: remainingDays <= 2 ? const Color(0xFFFBBF24) : Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${strings.daysRemainingLabel}: $remainingDays ${strings.daysUnitLabel}',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: remainingDays <= 2 ? const Color(0xFFFDE68A) : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Patient Overview
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF38BDF8)],
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 22,
                        backgroundColor: AppTheme.primaryBlue,
                        child: Icon(Icons.person_rounded, color: Colors.white, size: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  activeBooking.patientName,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.slate900),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${activeBooking.patientAge} Yrs • ${activeBooking.patientGender}',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.slate700),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            activeBooking.careCategory,
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppTheme.primaryBlue),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '📍 ${activeBooking.city}, ${activeBooking.district} • ${_getShiftTypeEnglish(activeBooking.shiftType)}',
                            style: const TextStyle(fontSize: 11, color: AppTheme.slate500, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Live Duty Timer (Clock-in / Clock-out)
                const DutyTimerCard(),

                // EXPANDED DETAILS ACCORDION
                if (_isActiveDutyExpanded) ...[
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 16),

                  // 1. Medical Diagnosis & Mobility
                  _buildSectionHeader(strings.medicalConditionSectionHeader),
                  const SizedBox(height: 8),
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
                        Text('${strings.diagnosisLabel}:', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.slate500)),
                        const SizedBox(height: 2),
                        Text(activeBooking.diagnosis, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppTheme.slate900)),
                        const SizedBox(height: 8),
                        Text('${strings.mobilityStatusLabel}:', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.slate500)),
                        const SizedBox(height: 2),
                        Text(patient.mobilityStatus, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFFD97706))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2. Exact Address & Google Map
                  _buildSectionHeader(strings.exactLocationSectionHeader),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(activeBooking.address, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppTheme.slate900)),
                              Text('${activeBooking.city}, ${activeBooking.district}', style: const TextStyle(fontSize: 11, color: AppTheme.slate500)),
                              if (activeBooking.hasLocation) ...[
                                const SizedBox(height: 3),
                                Row(
                                  children: const [
                                    Icon(Icons.check_circle_rounded, size: 11, color: Color(0xFF16A34A)),
                                    SizedBox(width: 3),
                                    Text(
                                      'GPS Pin Verified',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF16A34A)),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => provider.openMapForBooking(activeBooking),
                          icon: Icon(
                            activeBooking.hasLocation ? Icons.directions_rounded : Icons.map_rounded,
                            size: 15,
                            color: Colors.white,
                          ),
                          label: Text(
                            activeBooking.hasLocation ? 'GPS Navigate' : strings.openMapBtn,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: activeBooking.hasLocation ? const Color(0xFF2563EB) : const Color(0xFF0284C7),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 3. Family Guardian & Clinical Supervisor
                  _buildSectionHeader(strings.guardianContactLabel),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: AppTheme.blueLight, borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.people_alt_outlined, size: 18, color: AppTheme.primaryBlue),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${activeBooking.guardianName} (${activeBooking.guardianRelationship})',
                                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppTheme.slate900),
                                  ),
                                  Text(activeBooking.guardianPhone, style: const TextStyle(fontSize: 11, color: AppTheme.slate600)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.phone_rounded, color: AppTheme.primaryBlue, size: 20),
                              tooltip: strings.callGuardianBtn,
                              onPressed: () => provider.makePhoneCall(activeBooking.guardianPhone),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF25D366), size: 20),
                              tooltip: strings.whatsappGuardianBtn,
                              onPressed: () => provider.openWhatsAppEmergency(
                                phone: activeBooking.guardianPhone,
                                message: strings.whatsappNurseIntro,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16, color: Color(0xFFE2E8F0)),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.local_hospital_outlined, size: 18, color: Color(0xFF059669)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Sister N. Jayawardena (${strings.clinicalSupervisorRole})', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppTheme.slate900)),
                                  const Text('0705001122', style: TextStyle(fontSize: 11, color: AppTheme.slate600)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.phone_rounded, color: Color(0xFF059669), size: 20),
                              onPressed: () => provider.makePhoneCall('0705001122'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 4. Quick Bedside Shortcuts (Vitals & Routine)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => widget.onNavigateTab(1), // Vitals tab
                          icon: const Icon(Icons.monitor_heart_rounded, size: 17, color: Color(0xFFE11D48)),
                          label: Text(
                            strings.vitalsQuickBtn,
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFFE11D48)),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFF1F2),
                            side: const BorderSide(color: Color(0xFFFECDD3)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => widget.onNavigateTab(2), // Routine tab
                          icon: const Icon(Icons.checklist_rounded, size: 17, color: AppTheme.primaryBlue),
                          label: Text(
                            strings.routineQuickBtn,
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppTheme.primaryBlue),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFEFF6FF),
                            side: const BorderSide(color: Color(0xFFBFDBFE)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Centered Emergency SOS button (Vibrant, high-contrast, energetic)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => EmergencySosSheet.show(context),
                      icon: const Icon(Icons.emergency_rounded, color: Colors.white, size: 18),
                      label: Text(
                        strings.emergencySosBtn,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 12.5,
                          letterSpacing: 0.3,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: const Color(0xFFDC2626).withValues(alpha: 0.4),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Complete Duty Shift & Sign-Off Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showCompleteDutyDialog(context, provider, activeBooking),
                      icon: const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF059669), size: 18),
                      label: const Text(
                        'Complete Care Duty Shift & Sign-Off',
                        style: TextStyle(
                          color: Color(0xFF059669),
                          fontWeight: FontWeight.w800,
                          fontSize: 12.5,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFF0FDF4),
                        side: const BorderSide(color: Color(0xFF86EFAC)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // BOTTOM ACCORDION EXPAND / COLLAPSE ARROW BUTTON
          InkWell(
            onTap: () => setState(() => _isActiveDutyExpanded = !_isActiveDutyExpanded),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isActiveDutyExpanded ? strings.collapseDetailsLabel : strings.expandDetailsLabel,
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppTheme.primaryBlue),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    _isActiveDutyExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: AppTheme.primaryBlue,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. UPCOMING QUEUED DUTY CARD
  Widget _buildUpcomingDutyCard(
    BuildContext context,
    CareBookingModel upcoming,
    AppStrings strings,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF5FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9D5FF)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bookmark_added_rounded, color: Color(0xFF7C3AED), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        strings.upcomingDutyCardTitle,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF6B21A8)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('QUEUED', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${upcoming.bookingCode} • ${upcoming.patientName}',
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: AppTheme.slate900),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '📍 ${upcoming.city} • Starts: ${upcoming.startDate}',
                  style: const TextStyle(fontSize: 11.5, color: AppTheme.slate600),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. PRIVACY SHIELD BANNER (PROTECTION BEFORE ACCEPTANCE)
  Widget _buildPrivacyShieldBanner(AppStrings strings) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.shield_outlined, color: AppTheme.primaryBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              strings.privacyShieldNote,
              style: const TextStyle(fontSize: 11.5, color: Color(0xFF1E40AF), height: 1.4, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // 5. AVAILABLE BOOKINGS SECTION (FILTERED BY QUALIFICATION CATEGORY)
  Widget _buildAvailableBookingsSection(
    BuildContext context,
    StaffDutyProvider provider,
    CaregiverUserModel staff,
    AppStrings strings,
    LanguageProvider langProvider,
  ) {
    final currencyFmt = NumberFormat('#,###');
    final isStaffNurse = staff.isNurse;

    // Show bookings matching caregiver's qualification category:
    // NVQ 5 Nurses see NVQ 5 clinical nursing bookings (as well as general care bookings).
    // NVQ 4 Aides see NVQ 4 bookings (NVQ 5 is medically restricted to certified nurses).
    final availableBookings = provider.publishedBookings.where((b) {
      if (!b.isOpen) return false;
      if (b.requiredTier == 'nvq5_nurse') {
        return isStaffNurse;
      }
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.publishedByAdmin,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.slate900),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    strings.availableBookingsSubtitle,
                    style: const TextStyle(fontSize: 11.5, color: AppTheme.slate500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '${availableBookings.length} ${isStaffNurse ? 'NVQ 5' : 'NVQ 4'} Bookings',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // List of Published Booking Cards
        if (availableBookings.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.assignment_outlined, size: 40, color: AppTheme.slate400),
                  const SizedBox(height: 10),
                  Text(
                    strings.noBookingsForCategory(isStaffNurse ? "NVQ Level 5" : "NVQ Level 4"),
                    style: const TextStyle(color: AppTheme.slate600, fontSize: 13, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ...availableBookings.map((booking) {
            final eligibility = provider.checkBookingEligibility(booking);
            // Dynamic clinical and booking details presented in pure English
            final maskedTitle = booking.maskedTitleEnglish;

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: eligibility.canAccept ? const Color(0xFF93C5FD) : const Color(0xFFE2E8F0),
                  width: eligibility.canAccept ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: eligibility.canAccept
                        ? const Color(0xFF2563EB).withValues(alpha: 0.08)
                        : const Color(0xFF0F172A).withValues(alpha: 0.04),
                    blurRadius: 18,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Row: Masked Title + Tier Badge + Booking Code
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppTheme.blueLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.person_pin_rounded, size: 16, color: AppTheme.primaryBlue),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  maskedTitle,
                                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: AppTheme.slate900),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.blueLight,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
                              ),
                              child: Text(
                                booking.requiredTier == 'nvq5_nurse' ? 'NVQ Level 5' : 'NVQ Level 4',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.primaryBlue),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFA7F3D0)),
                              ),
                              child: Text(
                                booking.bookingCode,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF065F46)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Care Category (English)
                    Text(
                      booking.careCategory,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppTheme.primaryBlue),
                    ),
                    const SizedBox(height: 4),

                    // Diagnosis overview (English)
                    Text(
                      booking.diagnosis,
                      style: const TextStyle(fontSize: 11.5, color: AppTheme.slate600, height: 1.35),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    // City & Duration & Shift Type (English)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.slate500),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      '${booking.city}, ${booking.district}',
                                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppTheme.slate700),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (booking.hasLocation) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFF6FF),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: const Color(0xFF93C5FD)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(Icons.location_on_rounded, size: 9.5, color: Color(0xFF2563EB)),
                                            SizedBox(width: 2),
                                            Text(
                                              'GPS Pinned',
                                              style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w700, color: Color(0xFF1D4ED8)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, size: 13, color: AppTheme.slate500),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '${booking.durationDays} Days • ${_getShiftTypeEnglish(booking.shiftType)}',
                                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppTheme.slate700),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Start date & Daily Rate & Total Allowance (English)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Start Date:',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.slate500),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                booking.startDate,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.slate800),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Daily: LKR ${currencyFmt.format(booking.dailyRateLKR)}',
                              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppTheme.slate500),
                            ),
                            Text(
                              'LKR ${currencyFmt.format(booking.totalEarningsLKR)}',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF1D4ED8)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ELIGIBILITY ACTION OR LOCKED REASON
                    if (eligibility.canAccept)
                      ElevatedButton.icon(
                        onPressed: () => _showAcceptConfirmation(
                          context,
                          booking,
                          strings,
                          provider,
                          eligibility.isUpcoming,
                        ),
                        icon: Icon(
                          eligibility.isUpcoming ? Icons.calendar_today_rounded : Icons.check_circle_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: Text(
                          eligibility.isUpcoming ? strings.acceptAsNextDutyBtn : strings.acceptBookingBtn,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: eligibility.isUpcoming ? const Color(0xFF059669) : AppTheme.primaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lock_rounded, size: 16, color: Color(0xFFD97706)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                eligibility.localizedReason(langProvider.currentLocale),
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF92400E), height: 1.35),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildPendingQueueSection(
    BuildContext context,
    StaffDutyProvider provider,
    AppStrings strings,
  ) {
    final currencyFmt = NumberFormat('#,###');
    final staffId = provider.currentStaff.staffRegNo.isNotEmpty
        ? provider.currentStaff.staffRegNo
        : provider.currentStaff.id;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.hourglass_top_rounded, color: Color(0xFFB45309), size: 18),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Pending Admin Confirmation (Queued)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF92400E),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${provider.pendingBookings.length} Active',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'You accepted the following duty bookings. Admin is reviewing the first-come candidate queue. You can accept other bookings while waiting.',
            style: TextStyle(fontSize: 11, color: Color(0xFF78350F), height: 1.3),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.pendingBookings.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (ctx, idx) {
              final bk = provider.pendingBookings[idx];
              final pos = bk.getQueuePosition(staffId);

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFCD34D)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${bk.bookingCode} • ${bk.careCategory}',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppTheme.slate900),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: pos == 1 ? const Color(0xFFECFDF5) : const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: pos == 1 ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                            ),
                          ),
                          child: Text(
                            pos == 1 ? '⚡ Queue #1 (First Responder)' : 'Queue Position #$pos',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: pos == 1 ? const Color(0xFF047857) : const Color(0xFFB45309),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '📍 ${bk.city}, ${bk.district} • ${bk.durationDays} Days (${_getShiftTypeEnglish(bk.shiftType)})',
                      style: const TextStyle(fontSize: 11.5, color: AppTheme.slate600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Daily: LKR ${currencyFmt.format(bk.dailyRateLKR)} • Total Payout: LKR ${currencyFmt.format(bk.totalEarningsLKR)}',
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showCompleteDutyDialog(
    BuildContext context,
    StaffDutyProvider provider,
    CareBookingModel activeBooking,
  ) {
    final currencyFmt = NumberFormat('#,###');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.task_alt_rounded, color: Color(0xFF059669)),
            SizedBox(width: 8),
            Text('Complete Care Duty Shift', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient: ${activeBooking.patientName} (${activeBooking.city})'),
            const SizedBox(height: 6),
            Text(
              'Earnings to be Credited: LKR ${currencyFmt.format(activeBooking.totalEarningsLKR)}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF059669)),
            ),
            const SizedBox(height: 10),
            const Text(
              'Completing this duty will finalize your patient records and credit this shift payout to your account. Your status will return to Available.',
              style: TextStyle(fontSize: 12, color: AppTheme.slate600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await provider.completeActiveDuty();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Care duty completed successfully! Shift earnings credited to your finance account.'),
                    backgroundColor: Color(0xFF059669),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669)),
            child: const Text('Confirm & Complete Duty', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.slate800),
    );
  }
}
