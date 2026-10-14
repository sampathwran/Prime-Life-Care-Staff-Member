import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/staff_duty_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/duty_timer_card.dart';
import '../widgets/emergency_sos_sheet.dart';
import '../widgets/bed_turn_countdown_card.dart';
import '../widgets/vitals_summary_card.dart';

class HomeDutyView extends StatelessWidget {
  final Function(int) onNavigateTab;

  const HomeDutyView({
    super.key,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StaffDutyProvider>();
    final staff = provider.currentStaff;
    final patient = provider.currentPatient;

    final completedTasks = provider.todayTasks.where((t) => t.isCompleted).length;
    final totalTasks = provider.todayTasks.length;
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.blueLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.volunteer_activism_rounded, color: AppTheme.primaryBlue, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prime Life Care',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.slate900,
                  ),
                ),
                Text(
                  'STAFF & CAREGIVER PORTAL',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryBlue,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Switch Demo Staff Profile
          PopupMenuButton(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryBlue,
              child: Text(
                staff.avatarInitials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            tooltip: 'Switch Caregiver Persona (Demo)',
            onSelected: (profile) {
              provider.switchStaff(profile);
            },
            itemBuilder: (context) => provider.availableStaff
                .map(
                  (s) => PopupMenuItem(
                    value: s,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: s.id == staff.id ? AppTheme.primaryBlue : AppTheme.slate200,
                          child: Text(
                            s.avatarInitials,
                            style: TextStyle(
                              color: s.id == staff.id ? Colors.white : AppTheme.slate700,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.fullName,
                                style: TextStyle(
                                  fontWeight: s.id == staff.id ? FontWeight.w800 : FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                s.qualification,
                                style: const TextStyle(fontSize: 11, color: AppTheme.slate500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Shift Duty Card (Timer & Clock In/Out)
              const DutyTimerCard(),
              const SizedBox(height: 14),

              // 2. High-Priority Emergency SOS Button
              InkWell(
                onTap: () => EmergencySosSheet.show(context),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.white, size: 26),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EMERGENCY SOS DISPATCH',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              '1-Tap Call: 1990 Ambulance • Supervisor • Family',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Assigned Patient Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.slate200),
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppTheme.blueLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.elderly_rounded, color: AppTheme.primaryBlue, size: 26),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      patient.fullName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.slate900,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppTheme.emerald50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${patient.age} Yrs (${patient.gender})',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.emerald800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                patient.diagnosis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.slate600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Address & Map Action
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.slate50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.place_rounded, size: 16, color: AppTheme.primaryBlue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${patient.address}, ${patient.city}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.slate700,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          InkWell(
                            onTap: () => provider.openMapForAddress(patient.address, patient.city),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              child: Text(
                                'Directions',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.primaryBlue,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Quick Patient Guardian Call Row
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => provider.makePhoneCall(patient.guardianPhone),
                            icon: const Icon(Icons.phone_rounded, size: 16),
                            label: Text(
                              'Call ${patient.guardianRelationship}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.slate700,
                              side: const BorderSide(color: AppTheme.slate200),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => provider.makePhoneCall(patient.supervisorPhone),
                            icon: const Icon(Icons.support_agent_rounded, size: 16),
                            label: const Text(
                              'Call Supervisor',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primaryBlue,
                              side: const BorderSide(color: AppTheme.primaryBlue),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 4. 2-Hour Bed Turning Countdown
              BedTurnCountdownCard(
                onViewTurningScreen: () => onNavigateTab(2), // Navigate to Routine/Turning tab
              ),
              const SizedBox(height: 16),

              // 5. Bedside Vitals Card
              VitalsSummaryCard(
                onLogVitals: () => onNavigateTab(1), // Navigate to Vitals tab
              ),
              const SizedBox(height: 16),

              // 6. Care Routine Progress Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.slate200),
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Today\'s Care Routine',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.slate900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$completedTasks of $totalTasks Done',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: AppTheme.slate100,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // First 2 pending tasks preview
                    ...provider.todayTasks.where((t) => !t.isCompleted).take(2).map(
                          (task) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: task.isCompleted,
                                  onChanged: (_) => provider.toggleCareTask(task.id),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.slate800,
                                        ),
                                      ),
                                      Text(
                                        'Scheduled: ${task.timeSlot} • ${task.category.titleEn}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.slate500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                    // View all tasks button
                    TextButton(
                      onPressed: () => onNavigateTab(2),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              'Open Care Checklist & Turning Log',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: AppTheme.primaryBlue,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 14, color: AppTheme.primaryBlue),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
