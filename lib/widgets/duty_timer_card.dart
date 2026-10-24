import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/staff_duty_provider.dart';
import '../theme/app_theme.dart';

class DutyTimerCard extends StatelessWidget {
  const DutyTimerCard({super.key});

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final strings = langProvider.strings;
    final provider = context.watch<StaffDutyProvider>();
    final isClockedIn = provider.isClockedIn;
    final duration = provider.elapsedShiftDuration;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E3A8A), // Deep Navy Blue
            Color(0xFF2563EB), // Primary Blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Status badge + Shift type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isClockedIn
                        ? AppTheme.emeraldGreen.withValues(alpha: 0.25)
                        : Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isClockedIn
                          ? AppTheme.emeraldGreen.withValues(alpha: 0.8)
                          : Colors.white24,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isClockedIn ? const Color(0xFF34D399) : Colors.white70,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          isClockedIn ? strings.activeOnDutyBadge : strings.offDutyBadge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '12h Day Shift',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main Timer Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isClockedIn ? strings.shiftDurationElapsed : strings.readyToStartShift,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isClockedIn ? _formatDuration(duration) : '--:--:--',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Clock In / Out Toggle Button
              ElevatedButton(
                onPressed: () {
                  _showClockInOutDialog(context, provider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isClockedIn
                      ? const Color(0xFFEF4444) // Rose red
                      : AppTheme.emeraldGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isClockedIn ? Icons.stop_circle_outlined : Icons.play_circle_fill,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isClockedIn ? strings.clockOutBtn : strings.clockInBtn,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.white.withValues(alpha: 0.15), height: 1),
          const SizedBox(height: 10),

          // Bottom caregiver info row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${strings.staffLabel}: ${provider.currentStaff.fullName}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                provider.currentStaff.staffRegNo,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showClockInOutDialog(BuildContext context, StaffDutyProvider provider) {
    final isClockingOut = provider.isClockedIn;
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              isClockingOut ? Icons.logout_rounded : Icons.login_rounded,
              color: isClockingOut ? const Color(0xFFEF4444) : AppTheme.emeraldGreen,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              isClockingOut ? 'Daily Shift Check-Out' : 'Start Daily Shift (Check-In)',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isClockingOut) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Shift Hours Worked:', style: TextStyle(fontSize: 11.5, color: AppTheme.slate600)),
                          Text(
                            '${provider.elapsedShiftDuration.inHours}h ${provider.elapsedShiftDuration.inMinutes.remainder(60)}m',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.slate900),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Vitals Recorded Today:', style: TextStyle(fontSize: 11.5, color: AppTheme.slate600)),
                          Text(
                            '${provider.todayVitalsCount} Entries',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Bed Repositions Today:', style: TextStyle(fontSize: 11.5, color: AppTheme.slate600)),
                          Text(
                            '${provider.todayBedTurnsCount} Turns',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Handover Observation Notes:',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppTheme.slate800),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: notesController,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'e.g. Patient stable, vitals normal, took dinner & night meds.',
                    hintStyle: const TextStyle(fontSize: 11, color: AppTheme.slate400),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Notice: Check-Out completes only today\'s daily shift. Your remaining contract days will remain active for tomorrow.',
                  style: TextStyle(fontSize: 10, color: AppTheme.slate500, height: 1.3),
                ),
              ] else ...[
                Text(
                  'You are checking in for bedside duty at ${provider.currentPatient.fullName}\'s residence (${provider.currentPatient.city}).',
                  style: const TextStyle(fontSize: 12.5, color: AppTheme.slate700, height: 1.35),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.location_on_rounded, size: 14, color: Color(0xFF16A34A)),
                    SizedBox(width: 4),
                    Text(
                      'GPS location will be verified & logged for Admin audit.',
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Color(0xFF15803D)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              if (isClockingOut) {
                await provider.clockOutDailyShift(
                  handoverNotes: notesController.text.trim().isNotEmpty ? notesController.text.trim() : null,
                );
              } else {
                await provider.clockInDailyShift();
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isClockingOut
                          ? 'Daily shift checked out successfully! Shift report submitted for audit.'
                          : 'Shift started! Duty timer and GPS monitoring are now active.',
                    ),
                    backgroundColor: isClockingOut ? AppTheme.slate800 : AppTheme.emeraldGreen,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isClockingOut ? const Color(0xFFEF4444) : AppTheme.emeraldGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              isClockingOut ? 'Confirm Check-Out' : 'Confirm Check-In',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
