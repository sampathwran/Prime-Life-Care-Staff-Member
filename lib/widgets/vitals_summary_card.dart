import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/vitals_entry_model.dart';
import '../providers/language_provider.dart';
import '../providers/staff_duty_provider.dart';
import '../theme/app_theme.dart';

class VitalsSummaryCard extends StatelessWidget {
  final VoidCallback onLogVitals;

  const VitalsSummaryCard({
    super.key,
    required this.onLogVitals,
  });

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final strings = langProvider.strings;
    final provider = context.watch<StaffDutyProvider>();
    final vitals = provider.latestVitals;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.slate200),
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.emerald50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.monitor_heart_rounded,
                        color: AppTheme.emeraldGreen,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.bedsideVitalsMonitor,
                            style: const TextStyle(
                              color: AppTheme.slate900,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            vitals != null
                                ? strings.recordedAtTime(DateFormat('hh:mm a').format(vitals.recordedAt))
                                : strings.noVitalsRecordedToday,
                            style: const TextStyle(
                              color: AppTheme.slate500,
                              fontSize: 12,
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
              IconButton(
                onPressed: onLogVitals,
                icon: const Icon(Icons.add_circle, color: AppTheme.primaryBlue, size: 28),
                tooltip: strings.recordVitalsTooltip,
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (vitals != null) ...[
            // Vitals 4-Grid
            Row(
              children: [
                Expanded(
                  child: _VitalMetricBox(
                    label: 'BLOOD PRESSURE',
                    value: '${vitals.systolicBP}/${vitals.diastolicBP}',
                    unit: 'mmHg',
                    isAlert: vitals.systolicBP >= 140 || vitals.diastolicBP >= 90,
                    icon: Icons.favorite_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _VitalMetricBox(
                    label: 'BLOOD GLUCOSE',
                    value: vitals.bloodSugar.toStringAsFixed(0),
                    unit: 'mg/dL',
                    isAlert: vitals.bloodSugar > 180 || vitals.bloodSugar < 70,
                    icon: Icons.bloodtype_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _VitalMetricBox(
                    label: 'OXYGEN (SpO2)',
                    value: '${vitals.spO2}%',
                    unit: 'Room Air',
                    isAlert: vitals.spO2 < 95,
                    icon: Icons.air_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _VitalMetricBox(
                    label: 'HEART RATE',
                    value: '${vitals.heartRate}',
                    unit: 'bpm',
                    isAlert: vitals.heartRate > 100 || vitals.heartRate < 55,
                    icon: Icons.speed_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Temperature & Clinical Note snippet
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.slate50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.thermostat_rounded, size: 16, color: AppTheme.slate600),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Temp: ${vitals.temperatureC.toStringAsFixed(1)}°C (${(vitals.temperatureC * 9 / 5 + 32).toStringAsFixed(1)}°F)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.slate700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: vitals.severity == VitalsSeverity.normal
                          ? AppTheme.emerald50
                          : (vitals.severity == VitalsSeverity.warning
                              ? AppTheme.amber50
                              : AppTheme.rose50),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      vitals.severity == VitalsSeverity.normal
                          ? 'STABLE'
                          : (vitals.severity == VitalsSeverity.warning ? 'ATTENTION' : 'CRITICAL'),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: vitals.severity == VitalsSeverity.normal
                            ? AppTheme.emerald800
                            : (vitals.severity == VitalsSeverity.warning
                                ? AppTheme.amber800
                                : AppTheme.rose800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Text(
                    'No vitals logged yet for this shift',
                    style: TextStyle(color: AppTheme.slate500, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: onLogVitals,
                    child: const Text('Record First Vitals Check'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VitalMetricBox extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final bool isAlert;
  final IconData icon;

  const _VitalMetricBox({
    required this.label,
    required this.value,
    required this.unit,
    required this.isAlert,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAlert ? AppTheme.rose50 : AppTheme.slate50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isAlert ? AppTheme.rose100 : AppTheme.slate200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: isAlert ? AppTheme.rose800 : AppTheme.slate500,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                icon,
                size: 14,
                color: isAlert ? AppTheme.rose500 : AppTheme.slate400,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: isAlert ? AppTheme.rose800 : AppTheme.slate900,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isAlert ? AppTheme.rose800.withValues(alpha: 0.8) : AppTheme.slate400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
