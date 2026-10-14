import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                          isClockedIn ? 'ACTIVE ON DUTY' : 'OFF DUTY',
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
                      isClockedIn ? 'SHIFT DURATION ELAPSED' : 'READY TO START SHIFT',
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
                      isClockedIn ? 'Clock Out' : 'Clock In',
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
                  'Staff: ${provider.currentStaff.fullName}',
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isClockingOut ? 'End Current Shift?' : 'Start Shift Duty?'),
        content: Text(
          isClockingOut
              ? 'Are you sure you want to clock out? This will finalize your shift hours and notify the clinical coordinator.'
              : 'You are clocking in for duty at ${provider.currentPatient.fullName}\'s residence (${provider.currentPatient.city}).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.toggleClockIn();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isClockingOut
                        ? 'Successfully clocked out. Shift report submitted.'
                        : 'Shift started! Duty timer is now running.',
                  ),
                  backgroundColor: isClockingOut ? AppTheme.slate800 : AppTheme.emeraldGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isClockingOut ? AppTheme.rose500 : AppTheme.emeraldGreen,
            ),
            child: Text(isClockingOut ? 'Confirm Clock Out' : 'Confirm Clock In'),
          ),
        ],
      ),
    );
  }
}
