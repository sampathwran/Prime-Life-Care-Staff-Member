import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/staff_duty_provider.dart';
import '../theme/app_theme.dart';

class BedTurnCountdownCard extends StatelessWidget {
  final VoidCallback onViewTurningScreen;

  const BedTurnCountdownCard({
    super.key,
    required this.onViewTurningScreen,
  });

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final strings = langProvider.strings;
    final provider = context.watch<StaffDutyProvider>();
    final isOverdue = provider.isBedTurnOverdue;
    final timeRemaining = provider.timeUntilNextTurn;
    final progress = provider.bedTurnProgress;
    final lastTurn = provider.bedTurns.isNotEmpty ? provider.bedTurns.first : null;

    final minutesLeft = timeRemaining.inMinutes;
    final hoursLeft = timeRemaining.inHours;

    return Container(
      decoration: BoxDecoration(
        color: isOverdue ? AppTheme.rose50 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOverdue ? AppTheme.rose500.withValues(alpha: 0.5) : AppTheme.slate200,
          width: isOverdue ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isOverdue ? AppTheme.rose100 : AppTheme.blueLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.airline_seat_flat_rounded,
                        color: isOverdue ? AppTheme.rose800 : AppTheme.primaryBlue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.bedsorePreventionTitle,
                            style: const TextStyle(
                              color: AppTheme.slate900,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            isOverdue
                                ? strings.bedTurnRepositioningOverdue
                                : strings.bedTurnNextIn(minutesLeft),
                            style: TextStyle(
                              color: isOverdue ? AppTheme.rose800 : AppTheme.slate500,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
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

              // Position status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOverdue ? AppTheme.rose500 : AppTheme.emerald50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isOverdue ? strings.actionDueBadge : strings.onScheduleBadge,
                  style: TextStyle(
                    color: isOverdue ? Colors.white : AppTheme.emerald800,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Center Progress & Current Position Info
          Row(
            children: [
              // Circular progress timer
              SizedBox(
                width: 68,
                height: 68,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      backgroundColor: isOverdue ? AppTheme.rose100 : AppTheme.slate100,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isOverdue
                            ? AppTheme.rose500
                            : (progress > 0.8 ? AppTheme.amber500 : AppTheme.emeraldGreen),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isOverdue ? '0m' : (hoursLeft > 0 ? '${hoursLeft}h ${minutesLeft % 60}m' : '${minutesLeft}m'),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: isOverdue ? AppTheme.rose800 : AppTheme.slate900,
                          ),
                        ),
                        Text(
                          strings.timeLeftBadge,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.slate400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Current position details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.currentPostureLabel,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.slate400,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lastTurn != null
                          ? lastTurn.posture.localizedLabel(langProvider.currentLocale)
                          : strings.notYetRepositioned,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.slate900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lastTurn != null
                          ? 'Skin: ${lastTurn.skinStatus.localizedLabel(langProvider.currentLocale)} • Heels elevated'
                          : 'Schedule: Every 2 hours strictly',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.slate500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onViewTurningScreen,
              icon: const Icon(Icons.sync_rounded, size: 18),
              label: Text(
                strings.logBedTurnBtn,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: isOverdue ? AppTheme.rose800 : AppTheme.primaryBlue,
                side: BorderSide(
                  color: isOverdue ? AppTheme.rose500 : AppTheme.primaryBlue,
                  width: 1.2,
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
