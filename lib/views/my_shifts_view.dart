import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/shift_roster_model.dart';
import '../providers/language_provider.dart';
import '../providers/staff_duty_provider.dart';
import '../theme/app_theme.dart';

class MyShiftsView extends StatefulWidget {
  const MyShiftsView({super.key});

  @override
  State<MyShiftsView> createState() => _MyShiftsViewState();
}

class _MyShiftsViewState extends State<MyShiftsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openRatingModal(BuildContext context, ShiftRosterModel shift) {
    final langProvider = context.read<LanguageProvider>();
    final strings = langProvider.strings;
    final provider = context.read<StaffDutyProvider>();

    double currentRating = shift.ratingByMember ?? 5.0;
    final feedbackController = TextEditingController(text: shift.memberFeedback ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            String getRatingDescription(double rating) {
              if (rating >= 5.0) return '⭐⭐⭐⭐⭐ (Excellent)';
              if (rating >= 4.0) return '⭐⭐⭐⭐ (Very Good)';
              if (rating >= 3.0) return '⭐⭐⭐ (Satisfactory)';
              if (rating >= 2.0) return '⭐⭐ (Needs Improvement)';
              return '⭐ (Difficult)';
            }

            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppTheme.slate200,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.amber50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.star_rounded, color: AppTheme.amber500, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strings.rateCustomerModalTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.slate900,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              shift.patientName,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: AppTheme.slate400),
                        onPressed: () => Navigator.pop(bottomSheetContext),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text(
                    strings.rateCustomerModalSubtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.slate600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Star Rating Bar
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (starIndex) {
                        final starNumber = starIndex + 1.0;
                        final isFilled = starNumber <= currentRating;
                        return InkWell(
                          onTap: () {
                            setModalState(() {
                              currentRating = starNumber;
                            });
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                              size: 38,
                              color: isFilled ? const Color(0xFFF59E0B) : AppTheme.slate300,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      getRatingDescription(currentRating),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.slate700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Optional Feedback Input
                  TextField(
                    controller: feedbackController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: strings.ratingFeedbackHint,
                      hintStyle: const TextStyle(fontSize: 13, color: AppTheme.slate400),
                      filled: true,
                      fillColor: AppTheme.slate50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.slate200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.slate200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      provider.submitCustomerRating(
                        shiftId: shift.id,
                        rating: currentRating,
                        feedback: feedbackController.text.trim().isEmpty ? null : feedbackController.text.trim(),
                      );
                      Navigator.pop(bottomSheetContext);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(strings.ratingSuccessSnackbar),
                              ),
                            ],
                          ),
                          backgroundColor: AppTheme.emeraldGreen,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(
                      strings.submitRatingBtn,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final strings = langProvider.strings;
    final provider = context.watch<StaffDutyProvider>();
    final allShifts = provider.shiftRoster;
    final staff = provider.currentStaff;

    final activeShifts = allShifts.where((s) => s.status == ShiftStatus.active).toList();
    final upcomingShifts = allShifts.where((s) => s.status == ShiftStatus.upcoming).toList();
    final canceledShifts = allShifts.where((s) => s.status == ShiftStatus.canceled).toList();
    final completedShifts = allShifts.where((s) => s.status == ShiftStatus.completed).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.shiftHistoryTitle),
      ),
      body: Column(
        children: [
          // Top Monthly Summary Card (Pinned)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.15),
                    offset: const Offset(0, 6),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          strings.monthlyDutySummary,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Colors.white.withValues(alpha: 0.7),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.emeraldGreen.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF6EE7B7).withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          strings.shiftsCompletedCount(staff.completedShiftsThisMonth),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF6EE7B7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${strings.currencySymbol} ',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        NumberFormat('#,###').format(staff.totalEarningsThisMonth),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    strings.allowanceDirectDepositNote,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4-Tab Custom Segmented Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: AppTheme.primaryBlue,
                unselectedLabelColor: AppTheme.slate600,
                labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                dividerColor: Colors.transparent,
                labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                tabs: [
                  Tab(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(strings.tabActive),
                          if (activeShifts.isNotEmpty) ...[
                            const SizedBox(width: 4),
                            _buildCountBadge(activeShifts.length, AppTheme.emeraldGreen),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(strings.tabUpcoming),
                          if (upcomingShifts.isNotEmpty) ...[
                            const SizedBox(width: 4),
                            _buildCountBadge(upcomingShifts.length, AppTheme.amber800),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(strings.tabCanceled),
                          if (canceledShifts.isNotEmpty) ...[
                            const SizedBox(width: 4),
                            _buildCountBadge(canceledShifts.length, AppTheme.rose500),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(strings.tabCompleted),
                          if (completedShifts.isNotEmpty) ...[
                            const SizedBox(width: 4),
                            _buildCountBadge(completedShifts.length, AppTheme.slate700),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Active Tab
                _buildShiftList(
                  shifts: activeShifts,
                  emptyMessage: strings.noActiveShifts,
                  icon: Icons.check_circle_outline_rounded,
                  allowContact: true,
                ),

                // 2. Upcoming Tab (Rule: At most 1 upcoming shift allowed)
                _buildUpcomingTab(
                  upcomingShifts: upcomingShifts,
                  emptyMessage: strings.noUpcomingShifts,
                ),

                // 3. Canceled Tab (Contact details hidden + Cancellation reason shown)
                _buildShiftList(
                  shifts: canceledShifts,
                  emptyMessage: strings.noCanceledShifts,
                  icon: Icons.cancel_outlined,
                  allowContact: false,
                  isCanceledTab: true,
                ),

                // 4. Completed Tab (Contact details hidden + Member-to-Customer Rating)
                _buildShiftList(
                  shifts: completedShifts,
                  emptyMessage: strings.noCompletedShifts,
                  icon: Icons.task_alt_rounded,
                  allowContact: false,
                  isCompletedTab: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountBadge(int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }

  Widget _buildUpcomingTab({
    required List<ShiftRosterModel> upcomingShifts,
    required String emptyMessage,
  }) {
    final langProvider = context.watch<LanguageProvider>();
    final strings = langProvider.strings;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        // Rule Banner: Max 1 upcoming duty queued at a time
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: AppTheme.primaryBlue, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  strings.upcomingLimitBanner,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.slate800,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        if (upcomingShifts.isEmpty)
          _buildEmptyState(emptyMessage, Icons.calendar_today_outlined)
        else
          ...upcomingShifts.map((shift) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildShiftCard(shift: shift, allowContact: true),
              )),
      ],
    );
  }

  Widget _buildShiftList({
    required List<ShiftRosterModel> shifts,
    required String emptyMessage,
    required IconData icon,
    required bool allowContact,
    bool isCanceledTab = false,
    bool isCompletedTab = false,
  }) {
    if (shifts.isEmpty) {
      return _buildEmptyState(emptyMessage, icon);
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: shifts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildShiftCard(
          shift: shifts[index],
          allowContact: allowContact,
          isCanceledTab: isCanceledTab,
          isCompletedTab: isCompletedTab,
        );
      },
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.slate100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: AppTheme.slate400),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.slate600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftCard({
    required ShiftRosterModel shift,
    required bool allowContact,
    bool isCanceledTab = false,
    bool isCompletedTab = false,
  }) {
    final langProvider = context.watch<LanguageProvider>();
    final strings = langProvider.strings;
    final provider = context.watch<StaffDutyProvider>();

    final isActive = shift.status == ShiftStatus.active;
    final isUpcoming = shift.status == ShiftStatus.upcoming;
    final isCanceled = shift.status == ShiftStatus.canceled;
    final isCompleted = shift.status == ShiftStatus.completed;

    Color badgeColor;
    Color badgeBg;
    String badgeText;

    if (isActive) {
      badgeColor = AppTheme.emerald800;
      badgeBg = AppTheme.emerald50;
      badgeText = 'ACTIVE';
    } else if (isUpcoming) {
      badgeColor = AppTheme.amber800;
      badgeBg = AppTheme.amber50;
      badgeText = 'UPCOMING';
    } else if (isCanceled) {
      badgeColor = AppTheme.rose500;
      badgeBg = const Color(0xFFFEF2F2);
      badgeText = 'CANCELED';
    } else {
      badgeColor = AppTheme.slate700;
      badgeBg = AppTheme.slate100;
      badgeText = 'COMPLETED';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? AppTheme.primaryBlue : (isCanceled ? const Color(0xFFFECACA) : AppTheme.slate200),
          width: isActive ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Date badge, shift timing, status tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        DateFormat('EEE, MMM dd').format(shift.date),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: badgeColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        shift.shiftType.timing,
                        style: const TextStyle(fontSize: 11, color: AppTheme.slate500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Patient Name & Care Notes (English clinical terms preserved)
          Text(
            shift.patientName,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppTheme.slate900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            shift.careNotes,
            style: const TextStyle(fontSize: 12, color: AppTheme.slate600),
          ),
          const SizedBox(height: 10),

          // Location & Allowance Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.slate500),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        shift.patientLocation,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.slate700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${strings.currencySymbol} ${NumberFormat('#,###').format(shift.paymentAmount)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.emeraldGreen,
                ),
              ),
            ],
          ),

          // Privacy Protection Note for Completed & Canceled Shifts (No phone numbers shown)
          if (!allowContact) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: AppTheme.slate50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.slate200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lock_outline_rounded, size: 14, color: AppTheme.slate500),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      strings.privacyContactHiddenNotice,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.slate600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Canceled Tab: Show Reason for Cancellation clearly
          if (isCanceled) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppTheme.rose500, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.cancellationReasonLabel,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.rose500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          shift.cancellationReason ?? 'Duty canceled by administration.',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.slate800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Completed Tab: Member-to-Customer Rating Component
          if (isCompleted) ...[
            const SizedBox(height: 12),
            if (shift.ratingByMember != null) ...[
              // Already rated banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.amber50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 18),
                            const SizedBox(width: 4),
                            Text(
                              '${shift.ratingByMember!.toStringAsFixed(1)} / 5.0',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFB45309),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: InkWell(
                            onTap: () => _openRatingModal(context, shift),
                            child: Text(
                              strings.updateRatingBtn,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryBlue,
                                decoration: TextDecoration.underline,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (shift.memberFeedback != null && shift.memberFeedback!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '"${shift.memberFeedback}"',
                        style: const TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: AppTheme.slate700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ] else ...[
              // Not rated yet: prominent rating button
              OutlinedButton.icon(
                onPressed: () => _openRatingModal(context, shift),
                icon: const Icon(Icons.star_outline_rounded, size: 16, color: Color(0xFFD97706)),
                label: Text(
                  strings.rateCustomerBtn,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFFB45309)),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppTheme.amber50,
                  side: const BorderSide(color: Color(0xFFFDE68A)),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ],

          // Actions for Active & Upcoming ONLY (Never for Canceled or Completed)
          if (allowContact) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => provider.openMapForAddress(shift.patientLocation, 'Sri Lanka'),
                    icon: const Icon(Icons.navigation_outlined, size: 15),
                    label: Text(strings.mapRouteBtn, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      side: const BorderSide(color: AppTheme.slate200),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => provider.makePhoneCall(shift.patientPhone),
                    icon: const Icon(Icons.call_outlined, size: 15),
                    label: Text(strings.callFamilyBtn, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      side: const BorderSide(color: AppTheme.slate200),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
