import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/staff_duty_provider.dart';
import '../theme/app_theme.dart';

class EmergencySosSheet extends StatelessWidget {
  const EmergencySosSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EmergencySosSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StaffDutyProvider>();
    final patient = provider.currentPatient;
    final staff = provider.currentStaff;
    final latestVitals = provider.latestVitals;

    final vitalsSummary = latestVitals != null
        ? 'BP: ${latestVitals.systolicBP}/${latestVitals.diastolicBP} mmHg | Pulse: ${latestVitals.heartRate} bpm | SpO2: ${latestVitals.spO2}% | Sugar: ${latestVitals.bloodSugar.toStringAsFixed(0)} mg/dL'
        : 'Vitals not logged today';

    final waMessage =
        '🚨 *PRIME LIFE CARE - BEDSIDE EMERGENCY ALERT*\n\n'
        '*Patient:* ${patient.fullName} (${patient.age} yrs, ${patient.gender})\n'
        '*Location:* ${patient.address}, ${patient.city}\n'
        '*Assigned Caregiver:* ${staff.fullName} (${staff.staffRegNo})\n'
        '*Caregiver Contact:* ${staff.phone}\n'
        '*Guardian:* ${patient.guardianName} (${patient.guardianPhone})\n\n'
        '*Latest Vitals Check:*\n$vitalsSummary\n\n'
        '*Diagnosis / Alerts:* ${patient.diagnosis}\n\n'
        '⚠️ _Please review clinical status or send immediate supervisor assistance._';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
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

            // Header Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.rose50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.rose100),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppTheme.rose500,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'EMERGENCY DISPATCH / SOS',
                          style: TextStyle(
                            color: AppTheme.rose800,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Patient: ${patient.fullName} (${patient.city})',
                          style: const TextStyle(
                            color: AppTheme.slate600,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            const Text(
              '1-Tap Emergency Calling',
              style: TextStyle(
                color: AppTheme.slate900,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),

            // 1. Suwaseriya 1990
            _EmergencyActionTile(
              icon: Icons.local_hospital_rounded,
              iconBgColor: AppTheme.rose500,
              title: 'Call 1990 Suwaseriya Ambulance',
              subtitle: 'Free Government Emergency Medical Dispatch',
              phoneNumber: '1990',
              onTap: () => provider.makePhoneCall('1990'),
            ),
            const SizedBox(height: 10),

            // 2. Clinical Supervisor
            _EmergencyActionTile(
              icon: Icons.health_and_safety_rounded,
              iconBgColor: AppTheme.primaryBlue,
              title: 'Call Clinical Supervisor',
              subtitle: '${patient.supervisorName} (24/7 Hotline)',
              phoneNumber: patient.supervisorPhone,
              onTap: () => provider.makePhoneCall(patient.supervisorPhone),
            ),
            const SizedBox(height: 10),

            // 3. Family Guardian
            _EmergencyActionTile(
              icon: Icons.person_pin_circle_rounded,
              iconBgColor: AppTheme.amber800,
              title: 'Call Family Guardian',
              subtitle: '${patient.guardianName} (${patient.guardianRelationship})',
              phoneNumber: patient.guardianPhone,
              onTap: () => provider.makePhoneCall(patient.guardianPhone),
            ),
            const SizedBox(height: 14),

            // WhatsApp Quick Alert
            ElevatedButton.icon(
              onPressed: () => provider.openWhatsAppEmergency(
                phone: patient.supervisorPhone,
                message: waMessage,
              ),
              icon: const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 20),
              label: const Text(
                'Send Live Vitals SOS via WhatsApp',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.whatsappGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 12),

            // Close sheet button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel & Return to Bedside',
                style: TextStyle(
                  color: AppTheme.slate500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String phoneNumber;
  final VoidCallback onTap;

  const _EmergencyActionTile({
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.phoneNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.slate50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.slate200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppTheme.slate900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.slate500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.blueLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.call, size: 14, color: AppTheme.primaryBlue),
                  const SizedBox(width: 4),
                  Text(
                    phoneNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
