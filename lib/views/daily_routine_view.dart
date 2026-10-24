import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/care_task_model.dart';
import '../providers/language_provider.dart';
import '../providers/staff_duty_provider.dart';
import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';

class DailyRoutineView extends StatefulWidget {
  const DailyRoutineView({super.key});

  @override
  State<DailyRoutineView> createState() => _DailyRoutineViewState();
}

class _DailyRoutineViewState extends State<DailyRoutineView> {
  // Filter: 0: All, 1: Pending, 2: Confirmed & Locked
  int _selectedFilter = 0;

  void _openAddTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: const _AddCareTaskSheet(),
      ),
    );
  }

  void _openConfirmTaskModal(BuildContext context, CareTaskModel task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: _ConfirmCareTaskSheet(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final strings = langProvider.strings;
    final provider = context.watch<StaffDutyProvider>();
    final allTasks = provider.todayTasks;
    final confirmedCount = allTasks.where((t) => t.isConfirmed).length;
    final totalCount = allTasks.length;
    final pendingCount = totalCount - confirmedCount;
    final progress = totalCount > 0 ? confirmedCount / totalCount : 0.0;

    final filteredTasks = allTasks.where((t) {
      if (_selectedFilter == 1) return !t.isConfirmed;
      if (_selectedFilter == 2) return t.isConfirmed;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.routineCareTitle,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppTheme.slate900,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              strings.carePlanSubtitle,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.slate500,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: ElevatedButton.icon(
              onPressed: () => _openAddTaskModal(context),
              icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
              label: Text(
                strings.addCareTaskTooltip,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. TOP EXECUTIVE PROGRESS HERO CARD
            _buildProgressHeroCard(context, strings, confirmedCount, pendingCount, totalCount, progress),
            const SizedBox(height: 16),

            // 2. FILTER CHIPS ROW (ALL, PENDING, CONFIRMED)
            _buildFilterChips(strings, totalCount, pendingCount, confirmedCount),
            const SizedBox(height: 14),

            // 3. TASK LIST OR EMPTY STATE
            if (filteredTasks.isEmpty)
              _buildEmptyState(strings)
            else
              ...filteredTasks.map((task) => _buildCareTaskCard(context, task, provider, langProvider)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // 1. TOP EXECUTIVE PROGRESS HERO CARD (Slate Navy Gradient + Cyan/Emerald Glow)
  Widget _buildProgressHeroCard(
    BuildContext context,
    AppStrings strings,
    int confirmedCount,
    int pendingCount,
    int totalCount,
    double progress,
  ) {
    final percent = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F172A),
            Color(0xFF1E293B),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF334155), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
                      ),
                      child: const Icon(Icons.assignment_turned_in_rounded, size: 18, color: Color(0xFF38BDF8)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.carePlanCompletionSummary,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF94A3B8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$confirmedCount of $totalCount Locked',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: percent == 100
                        ? [const Color(0xFF059669), const Color(0xFF10B981)]
                        : [const Color(0xFF0284C7), const Color(0xFF2563EB)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (percent == 100 ? const Color(0xFF10B981) : const Color(0xFF2563EB)).withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Linear Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFF334155),
              valueColor: AlwaysStoppedAnimation<Color>(
                percent == 100 ? const Color(0xFF10B981) : const Color(0xFF38BDF8),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 3 Metric Stat Pillars
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF334155).withValues(alpha: 0.8)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.lock_rounded,
                    iconColor: const Color(0xFF10B981),
                    value: '$confirmedCount',
                    label: strings.confirmedCareTasksFilter,
                  ),
                ),
                Container(height: 24, width: 1, color: const Color(0xFF334155)),
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.pending_actions_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    value: '$pendingCount',
                    label: strings.pendingTasksFilter,
                  ),
                ),
                Container(height: 24, width: 1, color: const Color(0xFF334155)),
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.checklist_rtl_rounded,
                    iconColor: const Color(0xFF38BDF8),
                    value: '$totalCount',
                    label: strings.allTasksFilter,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13, color: iconColor),
            const SizedBox(width: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Color(0xFF94A3B8),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // 2. FILTER CHIPS
  Widget _buildFilterChips(
    AppStrings strings,
    int allCount,
    int pendingCount,
    int confirmedCount,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChipItem(0, '${strings.allTasksFilter} ($allCount)'),
          const SizedBox(width: 8),
          _buildChipItem(1, '${strings.pendingTasksFilter} ($pendingCount)', isWarning: true),
          const SizedBox(width: 8),
          _buildChipItem(2, '${strings.confirmedCareTasksFilter} ($confirmedCount)', isSuccess: true),
        ],
      ),
    );
  }

  Widget _buildChipItem(int index, String label, {bool isWarning = false, bool isSuccess = false}) {
    final isSelected = _selectedFilter == index;

    Color activeColor = AppTheme.primaryBlue;
    Color activeBg = const Color(0xFFEFF6FF);
    if (isWarning) {
      activeColor = const Color(0xFFD97706);
      activeBg = const Color(0xFFFFFBEB);
    } else if (isSuccess) {
      activeColor = const Color(0xFF059669);
      activeBg = const Color(0xFFECFDF5);
    }

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          color: isSelected ? activeColor : AppTheme.slate600,
        ),
      ),
      selected: isSelected,
      selectedColor: activeBg,
      backgroundColor: Colors.white,
      side: BorderSide(
        color: isSelected ? activeColor.withValues(alpha: 0.5) : const Color(0xFFE2E8F0),
        width: isSelected ? 1.4 : 1,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (_) => setState(() => _selectedFilter = index),
    );
  }

  // 3. EMPTY STATE
  Widget _buildEmptyState(AppStrings strings) {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.task_alt_rounded, size: 42, color: AppTheme.slate400),
            const SizedBox(height: 10),
            Text(
              strings.noTasksFound,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.slate600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // 4. CARE TASK CARD (Confirmed & Locked State vs Pending State)
  Widget _buildCareTaskCard(
    BuildContext context,
    CareTaskModel task,
    StaffDutyProvider provider,
    LanguageProvider langProvider,
  ) {
    final strings = langProvider.strings;
    final isLocked = task.isConfirmed;
    final categoryInfo = _getCategoryStyle(task.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isLocked ? const Color(0xFFFAFCFF) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isLocked ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
          width: isLocked ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          if (isLocked) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.lock_rounded, size: 16, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(strings.taskAlreadyLockedNotice)),
                  ],
                ),
                backgroundColor: const Color(0xFF0F172A),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          } else {
            _openConfirmTaskModal(context, task);
          }
        },
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Row 1: Time Slot Pill (Left) + Lock/Pending Status Badge (Right)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time_rounded, size: 12, color: AppTheme.slate600),
                        const SizedBox(width: 4),
                        Text(
                          task.timeSlot,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.slate800,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Lock Badge OR Pending Badge
                  if (isLocked)
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFA7F3D0)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock_rounded, size: 11.5, color: Color(0xFF059669)),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                strings.taskConfirmedLockedBadge,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF065F46),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.hourglass_top_rounded, size: 11.5, color: Color(0xFFD97706)),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                strings.pendingTasksFilter,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFB45309),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Top Row 2: Category Pill
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: categoryInfo.bgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: categoryInfo.color.withValues(alpha: 0.25)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(categoryInfo.icon, size: 12, color: categoryInfo.color),
                        const SizedBox(width: 5),
                        Text(
                          task.category.localizedTitle(langProvider.currentLocale),
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: categoryInfo.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Title
              Text(
                task.title,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w900,
                  color: isLocked ? AppTheme.slate700 : AppTheme.slate900,
                ),
              ),
              const SizedBox(height: 4),

              // Instructions
              Text(
                task.instructions,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.slate600,
                  height: 1.35,
                ),
              ),

              // Optional Bedside Notes Callout (If provided)
              if (task.notes != null && task.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.notes_rounded, size: 14, color: AppTheme.slate600),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          task.notes!,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontStyle: FontStyle.italic,
                            color: AppTheme.slate700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 10),

              // Bottom Section: Either Verification Timestamp (Locked) or Confirm & Lock Action Button (Pending)
              if (isLocked) ...[
                Row(
                  children: [
                    const Icon(Icons.verified_user_rounded, size: 14, color: Color(0xFF059669)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${task.confirmedBy ?? "Nurse/Caregiver"} • ${DateFormat('hh:mm a').format(task.confirmedAt ?? task.completedAt ?? DateTime.now())}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF065F46),
                        ),
                      ),
                    ),
                    const Icon(Icons.lock_rounded, size: 14, color: Color(0xFF059669)),
                  ],
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openConfirmTaskModal(context, task),
                    icon: const Icon(Icons.verified_rounded, size: 15, color: Colors.white),
                    label: Text(
                      strings.confirmTaskBtn,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  _CategoryStyle _getCategoryStyle(TaskCategory cat) {
    switch (cat) {
      case TaskCategory.medication:
        return _CategoryStyle(
          color: const Color(0xFF7C3AED),
          bgColor: const Color(0xFFF3E8FF),
          icon: Icons.medication_rounded,
        );
      case TaskCategory.nutrition:
        return _CategoryStyle(
          color: const Color(0xFFEA580C),
          bgColor: const Color(0xFFFFEDD5),
          icon: Icons.restaurant_rounded,
        );
      case TaskCategory.hygiene:
        return _CategoryStyle(
          color: const Color(0xFF0891B2),
          bgColor: const Color(0xFFCFFAFE),
          icon: Icons.clean_hands_rounded,
        );
      case TaskCategory.physiotherapy:
        return _CategoryStyle(
          color: const Color(0xFF059669),
          bgColor: const Color(0xFFD1FAE5),
          icon: Icons.directions_walk_rounded,
        );
      case TaskCategory.hydration:
        return _CategoryStyle(
          color: const Color(0xFF0284C7),
          bgColor: const Color(0xFFE0F2FE),
          icon: Icons.water_drop_rounded,
        );
    }
  }
}

class _CategoryStyle {
  final Color color;
  final Color bgColor;
  final IconData icon;

  _CategoryStyle({required this.color, required this.bgColor, required this.icon});
}

// Confirm & Lock Care Task Bottom Sheet
class _ConfirmCareTaskSheet extends StatefulWidget {
  final CareTaskModel task;

  const _ConfirmCareTaskSheet({required this.task});

  @override
  State<_ConfirmCareTaskSheet> createState() => _ConfirmCareTaskSheetState();
}

class _ConfirmCareTaskSheetState extends State<_ConfirmCareTaskSheet> {
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  void _confirmAndLock() {
    final provider = context.read<StaffDutyProvider>();
    provider.confirmCareTask(
      taskId: widget.task.id,
      notes: _notesCtrl.text.trim(),
    );
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Expanded(child: Text('සාත්තු කාර්යය සාර්ථකව තහවුරු කර අගුළු ලන ලදී!')),
          ],
        ),
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final strings = langProvider.strings;
    final staff = context.read<StaffDutyProvider>().currentStaff;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppTheme.slate200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: const Icon(Icons.verified_rounded, size: 24, color: Color(0xFF059669)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.confirmTaskDialogTitle,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.slate900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.task.timeSlot} • ${widget.task.title}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.slate600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Permanent Lock Disclosure Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lock_outline_rounded, size: 20, color: Color(0xFFD97706)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        strings.confirmTaskDialogDesc,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF92400E),
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Staff Attestation Info
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.badge_outlined, size: 16, color: AppTheme.slate500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${staff.fullName} (${staff.qualification})',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.slate700,
                        ),
                      ),
                    ),
                    Text(
                      DateFormat('hh:mm a').format(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.slate500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Bedside Observation Notes Input
              TextFormField(
                controller: _notesCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: strings.optionalBedsideNotes,
                  hintText: 'e.g. Patient swallowed without difficulty, no side effects observed.',
                  prefixIcon: const Icon(Icons.notes_rounded),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Buttons: Cancel & Confirm & Lock
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      child: Text(
                        strings.cancelBtn,
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.slate600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _confirmAndLock,
                      icon: const Icon(Icons.lock_rounded, size: 16, color: Colors.white),
                      label: Text(
                        strings.confirmAndLockAction,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Add Custom Care Task Bottom Sheet
class _AddCareTaskSheet extends StatefulWidget {
  const _AddCareTaskSheet();

  @override
  State<_AddCareTaskSheet> createState() => _AddCareTaskSheetState();
}

class _AddCareTaskSheetState extends State<_AddCareTaskSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _timeCtrl = TextEditingController(text: '03:00 PM');
  final _instructionsCtrl = TextEditingController();
  TaskCategory _category = TaskCategory.medication;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _timeCtrl.dispose();
    _instructionsCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<StaffDutyProvider>().addCustomTask(
            title: _titleCtrl.text.trim(),
            timeSlot: _timeCtrl.text.trim(),
            category: _category,
            instructions: _instructionsCtrl.text.trim(),
          );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final strings = langProvider.strings;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppTheme.slate200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  strings.addCareTaskTooltip,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.slate900,
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    hintText: 'e.g. Assist with gentle walking / Physiotherapy',
                    prefixIcon: Icon(Icons.task_alt_rounded),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Please enter task title' : null,
                ),
                const SizedBox(height: 12),

                // Category selector with isExpanded: true & ellipsis to prevent overflow!
                DropdownButtonFormField<TaskCategory>(
                  initialValue: _category,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category_rounded),
                  ),
                  items: TaskCategory.values
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c.localizedTitle(langProvider.currentLocale),
                              style: const TextStyle(fontSize: 12.5),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _category = val);
                  },
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _timeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Time Slot',
                    hintText: '03:00 PM',
                    prefixIcon: Icon(Icons.access_time_rounded),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _instructionsCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Specific Instructions',
                    hintText: 'e.g. Ensure wheelchair footrests are folded back first',
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                ),
                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                        ),
                        child: Text(
                          strings.cancelBtn,
                          style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.slate600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.add_task_rounded, size: 16, color: Colors.white),
                        label: Text(
                          strings.addToScheduleBtn,
                          style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
